//
//  ILMModel.m
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ILMModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ILMModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
        
        // 遍历属性列表
        unsigned int outCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(self.class, &outCount);
        for (unsigned int i = 0; i < outCount; i++) {
            objc_property_t property = propertyList[i];
            // 获取属性名称
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            id value = [dict objectForKey: propertyName];
            // 如果 value 不存在，则忽略
            if (!value) {
                continue;
            }
            
            // 获取属性的类型
            NSString *propertyType = [NSString stringWithUTF8String: property_getAttributes(property)];
            NSString *className = @"";
            
            // 引用类型的属性
            if ([propertyType hasPrefix:@"T@"]) {
                
                
                if ([value isKindOfClass: NSDictionary.class]) {
                    className = [propertyType substringFromIndex:3];
                    className = [className substringToIndex:[className rangeOfString:@"\""].location];
                    Class cls = NSClassFromString(className);
                    [self setValue:[[cls alloc] initWithDictionary: value] forKey: propertyName];
                } else if ([value isKindOfClass: NSArray.class]) {
                    NSDictionary *dict = [self.class modelContainerPropertyGenericClass];
                    Class cls = dict[propertyName];
                    if (cls) {
                        NSArray *array = [NSArray ilm_modelArrayWithClass:cls value:value];
                        [self setValue:array forKey:propertyName];
                    }
                } else {
                    [self setValue:value forKey:propertyName];
                }
            } else {
                // 值类型的属性
                NSString *setterName = [NSString stringWithFormat:@"set%@:", propertyName.capitalizedString];
                SEL sel = NSSelectorFromString(setterName);
                if ([propertyType hasPrefix:@"Td"]) {
                    ((void(*)(id, SEL, double))objc_msgSend)(self, sel, [value doubleValue]);
                } else if ([propertyType hasPrefix:@"Ti"]) {
                    ((void(*)(id, SEL, int))objc_msgSend)(self, sel, [value intValue]);
                } else if ([propertyType hasPrefix:@"Tf"]) {
                    ((void(*)(id, SEL, float))objc_msgSend)(self, sel, [value floatValue]);
                }  else if ([propertyType hasPrefix:@"Tq"]) {
                    ((void(*)(id, SEL, NSInteger))objc_msgSend)(self, sel, [value integerValue]);
                }/*else if {
                   /// 其它的类型
                   }*/
            }
        }
        free(propertyList);
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{};
}

@end

@implementation NSArray (ILMModel)

+ (NSArray *)ilm_modelArrayWithClass:(Class)cls value:(NSArray *)value {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in value) {
        NSObject *obj = [[cls alloc] initWithDictionary:dict];
        [array addObject:obj];
    }
    return array;
}

@end
