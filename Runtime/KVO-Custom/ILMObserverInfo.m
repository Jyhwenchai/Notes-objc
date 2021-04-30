//
//  ILMObserverInfo.m
//  KVO_Custom
//
//  Created by 蔡志文 on 2021/4/28.
//

#import "ILMObserverInfo.h"

ILMKeyValueChangeKey const ILMKeyValueChangeNewKey = @"ILMKeyValueChangeNewKey";
ILMKeyValueChangeKey const ILMKeyValueChangeOldKey = @"ILMKeyValueChangeOldKey";

@implementation ILMObserverInfo

- (instancetype)initWithObserver:(id)observer withKey:(NSString *)key options:(ILMKeyValueObservingOptions)options {
    if (self) {
        self.observer = observer;
        self.key = key;
        self.options = options;
    }
    return self;
}

@end
