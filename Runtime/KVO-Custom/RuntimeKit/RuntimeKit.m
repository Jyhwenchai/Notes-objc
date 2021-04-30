//
//  RuntimeKit.m
//  RuntimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import "RuntimeKit.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation RuntimeKit

+ (Class)fetchClass:(NSString *)className {
    return objc_getClass(className.UTF8String);
}

+ (NSString *)fetchClassName:(Class)cls {
    return [NSString stringWithUTF8String: class_getName(cls)];
}

+ (NSArray *)fetchIvarList:(Class)cls {
    unsigned int outCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String: ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String: ivar_getTypeEncoding(ivar)];
        [array addObject:@{@"ivarName": ivarName, @"ivarType": ivarType}];
    }
    free(ivarList);
    return array;
}

+ (NSArray *)fetchPropertyList:(Class)cls {
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String: property_getName(property)];
        NSString *propertyAttributes = [NSString stringWithUTF8String: property_getAttributes(property)];
        [array addObject:@{@"propertyName": propertyName, @"propertyAttributes": propertyAttributes}];
    }
    free(propertyList);
    return array;
}

+ (NSArray *)fetchMethodList:(Class)cls {
    unsigned int outCount = 0;
    
    Method *methodList = class_copyMethodList(cls, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        Method method = methodList[i];

        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSString *methodType = [NSString stringWithUTF8String: method_getTypeEncoding(method)];
        size_t dstLen = 255;
        char dst[dstLen];
        method_getReturnType(method, dst, dstLen);
        NSString *methodReturnType = [NSString stringWithUTF8String:dst];
        int numberOfArgs = method_getNumberOfArguments(method);
//        method_getImplementation(method)
//        method_getDescription(method)
//        method_getArgumentType(method, 0, dst, dstLen)
        [array addObject:@{@"methodName": methodName,
                           @"methodType": methodType,
                           @"methodReturnType": methodReturnType,
                           @"methodArgsCount": @(numberOfArgs)
        }];
        objc_getMetaClass(class_getName(cls));
    }
    free(methodList);
    return array;
}

+ (NSArray *)fetchProtocolList:(Class)cls {
    unsigned int outCount = 0;
    // Prococol 是一个 OC 类
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(cls, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        Protocol *protocol = protocolList[i];
        NSString *propertyName = [NSString stringWithUTF8String: protocol_getName(protocol)];

//        NSString *propertyAttributes = [NSString stringWithUTF8String: protocol_getProperty(protocol, name, isRequiredProperty, isInstanceProperty)];
//        protocol_getMethodDescription(protocol, aSel, isRequredMethod, isInstanceMethod)
        [array addObject:@{@"protocolName": propertyName}];
    }
    free(protocolList);
    return array;
}

+ (NSArray *)fetchProtocolPropertyList:(Protocol *)protocol {
    unsigned int outCount = 0;
    objc_property_t *propertyList = protocol_copyPropertyList(protocol, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String: property_getName(property)];
        NSString *propertyAttributes = [NSString stringWithUTF8String: property_getAttributes(property)];
        [array addObject:@{@"propertyName": propertyName, @"propertyAttributes": propertyAttributes}];
    }
    free(propertyList);
    return array;
}

+ (NSArray *)fetchProtocolMethodList:(Protocol *)protocol {
    unsigned int outCount = 0;
    BOOL isRequiredMethod = YES;
    BOOL isInstanceMethod = YES;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &outCount);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:outCount];
    for (unsigned int i = 0; i < outCount; i++) {
        struct objc_method_description methodDescription = methodList[i];
        NSString *propertyName = NSStringFromSelector(methodDescription.name);
        NSString *propertyType = [NSString stringWithUTF8String: methodDescription.types];
        [array addObject:@{@"propertyName": propertyName, @"propertyType": propertyType}];
    }
    free(methodList);
    return array;
}

+ (void)addMethod:(Class)fromCls fromMethod:(SEL)fromMethod methodClass:(Class)toCls toMethod:(SEL)toMethod {
    Method method = class_getInstanceMethod(fromCls, fromMethod);
    IMP imp = method_getImplementation(method);
    const char * types = method_getTypeEncoding(method);
    class_addMethod(toCls, toMethod, imp, types);
}

+ (void)exchangeMethod:(Class)cls firstMethod:(SEL)method1 secondeMethod:(SEL)method2 {
    Method m1 = class_getInstanceMethod(cls, method1);
    Method m2 = class_getInstanceMethod(cls, method2);
    method_exchangeImplementations(m1, m2);
}

@end
