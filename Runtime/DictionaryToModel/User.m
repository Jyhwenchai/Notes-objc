//
//  User.m
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "User.h"

@implementation User

- (void)setAge:(int)age {
    _age = age;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"dogs": Dog.class
    };
}

@end
