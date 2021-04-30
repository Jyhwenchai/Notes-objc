//
//  NSObject+Extension.m
//  ClassMethodDiffOfInstanceMethod
//
//  Created by 蔡志文 on 2021/4/25.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (NSString *)hello {
    NSString *desc = @"hello, objc";
    NSLog(@"%@", desc);
    return desc;
}

@end
