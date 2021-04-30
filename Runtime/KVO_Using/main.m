//
//  main.m
//  KVO_Using
//
//  Created by 蔡志文 on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import "Base.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Base *base = [[Base alloc] init];
        base.text = @"Hello";   // 未观察前不会执行 `- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context` 方法
        
        /**
         下面表示为 base 添加属性观察其中的参数：
         observer：由谁来观察属性的变化
         keyPath：要观察的属性名
         options: 要观察新值还是旧值
         context: 可以做标志
         */
        [base addObserver:base forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
         base.text = @"World";
        
        printf("\n");
        
        // 使用 KVC 出发 KVO
        [base setValue: @"Hello, World" forKey:@"text"];
    }
    return 0;
}
