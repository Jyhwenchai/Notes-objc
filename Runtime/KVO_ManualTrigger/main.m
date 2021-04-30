//
//  main.m
//  KVO_ManualTrigger
//
//  Created by 蔡志文 on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import "Base.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Base *base = [[Base alloc] init];
        [base addObserver:base forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        base.text = @"Hello";   // 通过重写 setter 方法主动触发KVO
        
    }
    return 0;
}
