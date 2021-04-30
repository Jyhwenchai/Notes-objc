//
//  Person.h
//  RuntimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import <Foundation/Foundation.h>
#import "Runnable.h"
#import "Speakable.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;

- (void)swimming;
- (void)doing;
+ (void)working;

@end

#pragma mark - Category
@interface Person (Extension)<Runnable, Speakable>

@end

NS_ASSUME_NONNULL_END
