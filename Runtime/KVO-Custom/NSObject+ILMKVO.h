//
//  NSObject+ILMKVO.h
//  KVO_Custom
//
//  Created by 蔡志文 on 2021/4/28.
//

#import <Foundation/Foundation.h>
#import "ILMObserverInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ILMKVO)

- (void)ilm_addObserver:(NSObject *)observer forKey:(NSString *)key options:(ILMKeyValueObservingOptions)options;
- (void)ilm_observeValueForKey:(NSString *)key ofObject:(id)object change:(NSDictionary<ILMKeyValueChangeKey,id> *)change;
- (void)ilm_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
