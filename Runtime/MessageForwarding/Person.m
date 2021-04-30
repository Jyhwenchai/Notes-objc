//
//  Person.m
//  MessageForwarding
//
//  Created by 蔡志文 on 2021/4/26.
//

#import "Person.h"
#import "People.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString * _name;

@implementation Person

@dynamic name;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(working)) {
        return People.new;  // 转发给 People 类处理
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 处理类方法 (消息动态解析)

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"sleeping")) {
        // 类方法实在元类中查找的，所以要将方法的实现添加到元类中
        class_addMethod(objc_getMetaClass(class_getName(Person.class)), sel, [Person methodForSelector:@selector(sleeping)], "v@:");
        return YES;
    }
    
    if (sel == NSSelectorFromString(@"saying")) {
        // 也可以将类方法转发到实例方法的实现
        class_addMethod(objc_getMetaClass(class_getName(Person.class)), sel, [Person.new methodForSelector:@selector(saying)], "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (void)sleeping {
    NSLog(@"sleeping.");
}

- (void)saying {
    NSLog(@"saying.");
}

#pragma mark - 处理实例方法 （消息动态查找）
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"eating")) {
        class_addMethod([Person class], sel, [Person methodForSelector:@selector(eating)], "v@:");
        return YES;
    }
    
    // 手动合成 name 的 get、set 方法
    if (sel == @selector(setName:)) {
        class_addMethod(self, sel, (IMP)setName, "v@:@");
        return YES;
    }
    if (sel == @selector(name)) {
        class_addMethod(self, sel, (IMP)getName, "@@:");
        return YES;
    }
    return  [super resolveInstanceMethod:sel];
}

- (void)eating {
    NSLog(@"eating.");
}

void setName(id cls, SEL cmd, NSString *name) {
    _name = name;
}

id getName(id cls, SEL cmd) {
    return _name;
}

#pragma mark - 消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == NSSelectorFromString(@"swimming")) {
//        return [self methodSignatureForSelector:@selector(swimming)];
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    // 也可以转发到另外一个类
    if (aSelector == NSSelectorFromString(@"running")) {
        return [People.new methodSignatureForSelector:aSelector];;
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == NSSelectorFromString(@"swimming")) {
        // 改变执行的函数
       // anInvocation.selector = @selector(swimming);// 因为方法签名与真正实现的方法签名相同，所以可以忽略
        [anInvocation invokeWithTarget:self];
    }
    
    if (anInvocation.selector == NSSelectorFromString(@"running")) {
        [anInvocation invokeWithTarget:People.new];
    }
}

- (void)swimming {
    NSLog(@"swimming.");
}

@end

/**
 给指定类添加方法
 BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
    * cls: 指定要添加方法的类 (可以是类对象，也可以是元类对象，具体看添加的方法是实例方法还是类方法)
    * name: 添加方法的签名
    * imp: 方法的具体实现
    * types: 字符数组，描述方法参数的类型
 */
