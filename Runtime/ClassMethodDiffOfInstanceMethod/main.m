//
//  main.m
//  ClassMethodDiffOfInstanceMethod
//
//  Created by 蔡志文 on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+Extension.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /**
         正常的类方法和实例方法的调用
         */
        Person *person = [[Person alloc] init];
        [person eating];
        [person sleeping];
        [Person working];
        
        // 使用 objc_msgSend 实现执行实例方法和类方法
        /**
            objc_msgSend 函数签名：objc_msgSend(self, op, ...)
                - self: 指向要接收消息的类的实例的指针。
                - op: 要处理消息的方法的选择器。
                - ...: 要处理方法的参数列表
         
            (void (*)(id,SEL))：这是一个函数指针
                - void: 是函数的返回值类型
                - (*): 表示这是一个函数指针
                - (id,SEL): 为函数的两个参数
         
            (void *): 是一个万能指针，所以下面的语句这个指针是可以去掉的
         
            根据字符串映射得到一个 SEL 对象
            SEL sel_registerName(const char *str)
                
         */
        printf("\n");
        ((void (*)(id,SEL))(void *)objc_msgSend)(person, sel_registerName("eating"));
        ((void (*)(id,SEL))objc_msgSend)(objc_getClass("Person"), sel_registerName("working"));
        // 下面的调用与上面等价
        ((void (*)(id,SEL))(void *)objc_msgSend)(person, NSSelectorFromString(@"eating"));
        ((void (*)(id,SEL))objc_msgSend)(Person.class, NSSelectorFromString(@"working"));
        
        printf("\n");
        
        /**
         类方法与示例方法在哪里查找？
             1. 如果是调用实例对象的方法，那么在类的方法列表中查找 （实例对象的isa指向类对象）
             2. 如果是调用类对象的方法，那么在元类的方法列表中查找 （类对象的isa指向元类对象）
         */
        
        // 验证
        // 1. 从类对象中查找 sleeping 方法
        IMP sleepIMP = class_getMethodImplementation(Person.class, @selector(sleeping));
        sleepIMP();

        IMP workIMP = class_getMethodImplementation(objc_getMetaClass(class_getName(Person.class)), @selector(working));
        workIMP();
        
        /**
         给父类发送消息
         */
        struct objc_super objcSuper;
        objcSuper.receiver = person;
        objcSuper.super_class = [NSObject class];
        SEL descriptionSel = @selector(hello);
        ((void (*)(void *, SEL))objc_msgSendSuper)(&objcSuper,descriptionSel);
        
        printf("\n");
        
        // 跳过消息发送执行函数
        // typedef void (*IMP)(id, SEL, ...);
        // IMP 是一个函数指针
        SEL sleepSEL = @selector(sleeping);
        IMP sleepIMP2 = [person methodForSelector:sleepSEL];
        ((void (*)(id, SEL))sleepIMP2)(person, sleepSEL);
    }
    return 0;
}

/**
 获取类名：
 const char * class_getName(Class cls);
 NSString * NSStringFromClass(Class aClass);
 
 获取指定的类：
 id objc_getClass(const char *name);
 Class NSClassFromString(NSString *aClassName);
 
 获取指定名字的方法签名：
 SEL sel_registerName(const char *str);
 SEL NSSelectorFromString(NSString *aSelectorName);
 
 获取指定名字的元类：
 id objc_getMetaClass(const char *name);
 
 获得将特定消息发送到类的实例时将调用的函数指针：
 IMP class_getMethodImplementation(Class cls, SEL name);
 - (IMP)methodForSelector:(SEL)aSelector;
 */

/**
 设置指定对象的isa
 Class object_setClass(id obj, Class cls);
 
 获取指定类对象的父类对象
 Class class_getSuperclass(Class cls);
 */

/**
 
 objc_super
 通过指定 receiver 和 super_class 可以得到他父类结构，那么就可以使用 `objc_msgSendSuper` 想父类发送消息了
 struct objc_super superClass;
 superClass.receiver = self;
 superClass.super_class = class_getSuperclass(object_getClass(self));
 ((void (*)(void *,SEL,id))(void *)objc_msgSendSuper)(&superClass,_cmd,newValue);
 */
