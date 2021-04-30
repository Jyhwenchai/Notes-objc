//
//  Base.m
//  KVO_ClassChange
//
//  Created by 蔡志文 on 2021/4/27.
//

#import "Base.h"

@implementation Base

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@修改前的值为：%@", keyPath, change[NSKeyValueChangeOldKey]);
    NSLog(@"%@修改前的值为：%@", keyPath, change[NSKeyValueChangeNewKey]);
}

@end
