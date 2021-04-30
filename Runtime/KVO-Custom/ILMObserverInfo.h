//
//  ILMObserverInfo.h
//  KVO_Custom
//
//  Created by 蔡志文 on 2021/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ILMKeyValueObservingOptions){
    ILMKeyValueObservingOptionsNew = 0x01,
    ILMKeyValueObservingOptionsOld = 0x02
};

typedef NSString * ILMKeyValueChangeKey NS_STRING_ENUM;

FOUNDATION_EXPORT ILMKeyValueChangeKey const ILMKeyValueChangeNewKey;
FOUNDATION_EXPORT ILMKeyValueChangeKey const ILMKeyValueChangeOldKey;

@interface ILMObserverInfo : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id observer;

@property (nonatomic, assign) ILMKeyValueObservingOptions options;

- (instancetype)initWithObserver:(id)observer withKey:(NSString *)key options:(ILMKeyValueObservingOptions)options;

@end

NS_ASSUME_NONNULL_END
