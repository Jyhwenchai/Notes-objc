//
//  NSObject+ILMCoding.m
//  AutoCoding
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "NSObject+ILMCoding.h"
#import <objc/runtime.h>

@implementation NSObject (ILMCoding)

- (void)ilm_encodeWithCoder:(NSCoder *)coder
{
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self.class, &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *pName = [NSString stringWithUTF8String: property_getName(property)];
        id pValue = [self valueForKey:pName];
        [coder encodeObject:pValue forKey: pName];
    }
    
}

- (void)ilm_decoderWithCoder:(NSCoder *)coder {
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self.class, &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *pName = [NSString stringWithUTF8String: property_getName(property)];
        id pValue = [coder decodeObjectForKey:pName];
        [self setValue:pValue forKey:pName];
    }
}

@end
