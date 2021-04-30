//
//  main.m
//  KVO_ClassChange
//
//  Created by 蔡志文 on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import "RuntimeKit.h"
#import "Base.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 观察设置KVO后类中属性、变量、方法的变化
        Base *base = [[Base alloc] init];
        Class beforeCls = object_getClass(base);

        printf("============ 添加KVO之前 ============\n");
        
        // 类名
        NSLog(@"change before class name: %@", base.class);
        
        // isa
        NSLog(@"change before ISA: %@", beforeCls);
        
        // 属性列表
        NSArray *propertyList = [RuntimeKit fetchPropertyList: beforeCls];
        NSLog(@"change before preperty list %@", propertyList);
        
        // 变量列表
        NSArray *ivarList = [RuntimeKit fetchIvarList: beforeCls];
        NSLog(@"change before ivar list %@", ivarList);
        
        // 方法列表
        NSArray *methodList = [RuntimeKit fetchMethodList: beforeCls];
        NSLog(@"change before method list %@", methodList);
        
        // setter方法的IMP
        IMP setterIMPBefore = [base methodForSelector:@selector(setName:)];
        NSLog(@"change before setter imp：%p", setterIMPBefore);
        
        // class方法的IMP
        IMP classIMPBefore = [base methodForSelector:@selector(class)];
        NSLog(@"change before class imp：%p", classIMPBefore);
        
        
        [base addObserver:base forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        base.text = @"dd";
        printf("============ 添加KVO之后 ============\n");

        Class afterCls = object_getClass(base);
        // 类名
        NSLog(@"change after class name: %@", base.class);
        
        // isa
        NSLog(@"change after ISA: %@", afterCls);
        
        // 属性列表
        NSArray *propertyListChange = [RuntimeKit fetchPropertyList: afterCls];
        NSLog(@"change after preperty list %@", propertyListChange);
        
        // 变量列表
        NSArray *ivarListChange = [RuntimeKit fetchIvarList: afterCls];
        NSLog(@"change after ivar list %@", ivarListChange);
        
        // 方法列表
        NSArray *methodListChange = [RuntimeKit fetchMethodList: afterCls];
        NSLog(@"change after method list %@", methodListChange);
        
        // setter方法的IMP
        IMP setterIMPAfter = [base methodForSelector:@selector(setName:)];
        NSLog(@"change after setter imp：%p", setterIMPAfter);
        
        // class方法的IMP
        IMP classIMPAfter = [base methodForSelector:@selector(class)];
        NSLog(@"change after class imp：%p", classIMPAfter);
    }
    return 0;
}
