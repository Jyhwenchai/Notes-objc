//
//  main.m
//  Diff-class-objc getClass object_getClass
//
//  Created by 蔡志文 on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Base.h"

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Base *base = [[Base alloc] init];
        /**
         class
         类对象和实例对象都可以执行 class 方法，返回的都是类对象本身
         */
        
        Class instanceCls = base.class;
        Class classCls = Base.class;
        //NSLog(@"%@", ((Base *)instanceCls).text);   // crash, 因为返回的不是一个实例对象
        NSLog(@"instance class: (%@:%p), class class: (%@:%p)", instanceCls, instanceCls, classCls, classCls);
        
        /**
         objc_getClass
         通过传入的字符串得到一个类对象（不是实例对象）
         */
        Class objcCls = objc_getClass("Base");
        // NSLog(@"%@", ((Base *)objcCls).text);   // crash, 因为返回的不是一个实例对象
        Base *objcInstance = [[objcCls alloc] init];
        NSLog(@"(%@:%p), text: %@", objcCls, objcCls, objcInstance.text);
        
        /**
         object_getClass
         得到的是传入对象的 isa 所指向的对象
         - 实例对象 base 的 isa 所执行的对象是其类对象 -> objectClassCls
         - 类对象 objectClassCls 的 isa 所指向的对象是元类对象 -> objectMetaCls
         - 类对象 Base.class 的 isa 所指向的对象是元类对象 -> objectMetaCls2
         所以下面 objectMetaCls 和 objectMetaCls2 的地址是相同的, 都是元类对象的地址
         */
        Class objectClassCls = object_getClass(base);           // 得到 base 的类对象 Base
        Class objectMetaCls = object_getClass(objectClassCls);  // 得到 Base 的元类对象
        Class objectMetaCls2 = object_getClass(Base.class);     // 得到 Base 的元类对象
        
        NSLog(@"instanceObjectCls-(%@:%p), classObjectCls-(%@:%p), objectMetaCls2-(%@:%p)", objectClassCls, objectClassCls, objectMetaCls, objectMetaCls, objectMetaCls2, objectMetaCls2);
    }
    return 0;
}
