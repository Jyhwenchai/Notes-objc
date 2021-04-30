//
//  Base.m
//  KVO_ClassChange
//
//  Created by 蔡志文 on 2021/4/27.
//

#import "Base.h"
#import "NSObject+ILMKVO.h"

@implementation Base

- (void)ilm_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<ILMKeyValueChangeKey,id> *)change {
    NSLog(@"%@修改前的值为：%@", key, change[ILMKeyValueChangeOldKey]);
    NSLog(@"%@修改前的值为：%@", key, change[ILMKeyValueChangeNewKey]);
}


+ (void)test {
    NSLog(@"test: %p", self);
}

@end
