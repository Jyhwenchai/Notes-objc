//
//  NSObject+ILMKVO.m
//  KVO_Custom
//
//  Created by 蔡志文 on 2021/4/28.
//

#import "NSObject+ILMKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const ILMKVONotifying_ = @"ILMKVONotifying_";
static const char ILMKVO_ObserverInfo;

@implementation NSObject (ILMKVO)

/**
 1. 注册当前类的子类
    - 检查当前类是否实现了要监听属性的setter方法
    - 检查当前类的isa是否被替换过
    - 注册新类
 2. 替换当前类的isa
 3. 重定向当前子类的key所对应的setter方法的imp实现 => ILMKVO_Setter
 4. 重定向当前子类的class方法的imp实现 => ILMKVO_Class
 5. 保存观察者及监听的属性等内容
 */
- (void)ilm_addObserver:(NSObject *)observer forKey:(NSString *)key options:(ILMKeyValueObservingOptions)options {
    // 1. 注册一个继承当前类的子类
    // - 判断当前类是否实现了 key 属性的 setter 方法，如果未实现，则无法实现KVO
    NSString *setterName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
    SEL sel = NSSelectorFromString(setterName);
    
    // 获取当前类中指定的方法
    Method setterMethod = class_getInstanceMethod(self.class, sel);
    if (!setterMethod) {
        NSLog(@"未找到指定key:%@对应的 setter 方法", key);
        return;
    }
    
    // 判断当前类的isa是否已经被替换过，如果已经被替换过则不需要进行替换
    Class isa = object_getClass(self);
    NSString *isaName = NSStringFromClass(isa);
    if (![isaName hasPrefix: ILMKVONotifying_]) {
        Class cls = self.class;
        NSString *subClassName = [ILMKVONotifying_ stringByAppendingString:NSStringFromClass(isa)];
        // 创建一个继承当前类的子类子类名以 ILMKVONotifying_ 为前缀
        isa = objc_allocateClassPair(cls, subClassName.UTF8String, 0);
        // 注册子类
        objc_registerClassPair(isa);
    }
    
    // 2. 修改原类（也就是当前类）的 isa, 使其指向子类（前面创建的以 ILMKVONotifying_ 为前缀的子类）
    object_setClass(self, isa);
    
    // 3. 修改好 isa 之后需要替换子类 key 属性对应的 setter 的实现，也就是要修改对应 setter 方法的 imp
    // - 新增一个方法，使执行 key 对应的 setter 方法后都会重定向到我们自己实现的方法
    class_addMethod(isa, sel, (IMP)ILMKVO_Setter, method_getTypeEncoding(setterMethod));
    
    // 4. 同样替换掉 class 方法为自己的实现
    SEL classSel = @selector(class);
    Method classMethod = class_getClassMethod(isa, classSel);
    class_addMethod(isa, classSel, (IMP)ILMKVO_Class, method_getTypeEncoding(classMethod));
    
    // 5. 处理消息监听信息
    ILMObserverInfo *observerInfo = [[ILMObserverInfo alloc] initWithObserver:observer withKey:key options:options];
    NSMutableArray *array = objc_getAssociatedObject(self, &ILMKVO_ObserverInfo);
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:observerInfo];
    objc_setAssociatedObject(self, &ILMKVO_ObserverInfo, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 1. 获取属性名
 2. 获取旧值并修改父类对应属性的值
 3. 修改完成向观察者发送相应的消息
 */
void ILMKVO_Setter(id self, SEL _cmd, id newValue) {
    // 1. 获取属性名
    NSString *selString = NSStringFromSelector(_cmd);
    NSString *cap = [[selString substringWithRange:NSMakeRange(3, 1)] lowercaseString]; // set 后的第一个字符
    NSString *remainKeyName = [selString substringWithRange:NSMakeRange(4, [selString rangeOfString:@":"].location-4)];
    NSString *key = [NSString stringWithFormat:@"%@%@", cap, remainKeyName];
    
    // 获取旧值
    id oldValue = [self valueForKey:key];
    
    // 为父类的 key 属性赋值
    // 指定为 self 的 父类 class_getSuperclass(object_getClass(self)) 发送消息
    struct objc_super objcSuper;
    objcSuper.receiver = self;
    objcSuper.super_class = class_getSuperclass(object_getClass(self));
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&objcSuper, _cmd, newValue);
    
    // 2. 通知观察者值变化的消息
    NSMutableArray *array = objc_getAssociatedObject(self, &ILMKVO_ObserverInfo);
    if (!array && array.count == 0) {
        return;
    }
    
    for (ILMObserverInfo *observerInfo in array) {
        if ([observerInfo.key isEqualToString: key]) {
            NSMutableDictionary<ILMKeyValueChangeKey, id> *change = [NSMutableDictionary dictionaryWithCapacity:2];
            if (observerInfo.options & ILMKeyValueObservingOptionsOld) {
                [change setObject:oldValue forKey: ILMKeyValueChangeOldKey];
            }
            
            if (observerInfo.options & ILMKeyValueObservingOptionsNew) {
                [change setObject:newValue forKey: ILMKeyValueChangeNewKey];
            }
            
            // 向观察者发送消息
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(observerInfo.observer, @selector(ilm_observeValueForKey:ofObject:change:), key, self, change);
        }
    }
}

Class ILMKVO_Class(id self, SEL _cmd) {
    // 得到父类的 isa，这样子使原类调用 class 方法时看起来没有变化，得到的还是未加上 ILMKVONotifying_ 前缀的类对象
    return class_getSuperclass(object_getClass(self));
}

- (void)ilm_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<ILMKeyValueChangeKey,id> *)change {}


- (void)ilm_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray *array =  objc_getAssociatedObject(self, &ILMKVO_ObserverInfo);
    if (!array || array.count == 0) {
        return;
    }
    
    for (ILMObserverInfo *observerInfo in array) {
        if ([observerInfo.key isEqualToString:key]) {
            [array removeObject: observerInfo];
            objc_setAssociatedObject(self, &ILMKVO_ObserverInfo, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    // 如果没有观察者了，则恢复isa的指向
    if (array.count == 0) {
        object_setClass(self, self.class);
    }
}


@end
