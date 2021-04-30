//
//  main.m
//  runtimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import <Foundation/Foundation.h>
#import "RuntimeKit.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "CustomProtocol.h"
#import "Common.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
      
        // 根据类名获取类
        Class cls = [RuntimeKit fetchClass:@"Person"];
        NSLog(@"fetch class: \n%@", cls);
        
        // 根据类获取类名
        NSString *className = [RuntimeKit fetchClassName:cls];
        NSLog(@"fetch class name: \n%@", className);
        
        // 获取指定类的成员变量列表
        NSArray *ivarList = [RuntimeKit fetchIvarList:cls];
        NSLog(@"fetch class Member variables: \n%@", ivarList);
        
        // 获取指定类的成员属性列表
        NSArray *propertyList = [RuntimeKit fetchPropertyList:cls];
        NSLog(@"fetch class Member propertys: \n%@", propertyList);
        
        
        // 获取指定类的实例方法列表
        NSArray *instanceMethodList = [RuntimeKit fetchMethodList:cls];
        NSLog(@"fetch instance methods: \n%@", instanceMethodList);
        
        // 获取指定类的类方法列表
        NSArray *classMethodList = [RuntimeKit fetchMethodList:objc_getMetaClass(class_getName(cls))];
        NSLog(@"fetch class methods: \n%@", classMethodList);
        
        // 获取指定类的协议列表
        NSArray *protocolList = [RuntimeKit fetchProtocolList:cls];
        NSLog(@"fetch class protocols: \n%@", protocolList);
        
        // 获取指定协议的属性列表
        Protocol *protocol = @protocol(CustomProtocol);
        NSArray *protocolPropertyList = [RuntimeKit fetchProtocolPropertyList:protocol];
        NSLog(@"fetch protocol propertys: \n%@", protocolPropertyList);

        // 获取指定协议的方法列表
        NSArray *protocolMethodList = [RuntimeKit fetchProtocolMethodList:protocol];
        NSLog(@"fetch protocol methods: \n%@", protocolMethodList);
        
        // 动态添加方法
        Person *person = [[Person alloc] init];
        // 添加不存在的方法
        [RuntimeKit addMethod:Common.class fromMethod:@selector(hello) methodClass:Person.class toMethod:@selector(hello)];
        [person performSelector:@selector(hello)];
        
        // 添加已存在的方法，无法添加会执行自己已存在的方法
        [RuntimeKit addMethod:Common.class fromMethod:@selector(swimming) methodClass:Person.class toMethod:@selector(swimming)];
        [person performSelector:@selector(swimming)];
        
        // 方法交换
        [RuntimeKit exchangeMethod:cls firstMethod:@selector(swimming) secondeMethod:@selector(doing)];
        [person performSelector:@selector(swimming)];
        [person performSelector:@selector(doing)];
        
        // 动态添加变量(无法为已经存在的类添加变量，因为类在编译时就已经确定变量在内存的布局)
        // 被添加的类不能时元类
        Class People = objc_allocateClassPair(NSObject.class, "People", 0);
        BOOL isAdd = class_addIvar(People, "name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        if (isAdd) {
            id people = [[People alloc] init];
            [people setValue:@"ilosic" forKey:@"name"];
            NSLog(@"create People class and add ivar: %@", [people valueForKey:@"name"]);
        }
        
    }
    return 0;
}
