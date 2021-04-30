//
//  NSArray+Category.m
//  SolveArrayOutOfBounds
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "NSArray+Category.h"
#import "NSObject+ILMSwizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Category)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取 NSArray 的 isa 真正指向的类对象
        Class cls = objc_getClass("__NSArrayI");
        [cls ilm_swizzeMethod:@selector(objectAtIndex:) withMethod:@selector(ilm_objectAtIndex:)];
        [cls ilm_swizzeMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(ilm_objectAtIndexedSubscript:)];
    });
}

- (id)ilm_objectAtIndex:(NSUInteger)idx {
    if (idx > self.count - 1) {
        NSLog(@"err: index out of range");
        return nil;
    } else {
        return [self ilm_objectAtIndex:idx];
    }
}

// 下标实现
- (id)ilm_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx > self.count - 1) {
        NSLog(@"err: index out of range");
        return nil;
    } else {
        return [self ilm_objectAtIndexedSubscript:idx];
    }
}

@end
