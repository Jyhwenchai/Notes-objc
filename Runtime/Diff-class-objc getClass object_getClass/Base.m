//
//  Base.m
//  Diff-class-objc getClass object_getClass
//
//  Created by 蔡志文 on 2021/4/28.
//

#import "Base.h"

@implementation Base

- (instancetype)init
{
    self = [super init];
    if (self) {
        _text = @"Hello, World!";
    }
    return self;
}

@end
