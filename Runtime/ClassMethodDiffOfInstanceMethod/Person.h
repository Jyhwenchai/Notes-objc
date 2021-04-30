//
//  Person.h
//  ClassMethodDiffOfInstanceMethod
//
//  Created by 蔡志文 on 2021/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

- (void)eating;
- (void)sleeping;
+ (void)working;

@end

NS_ASSUME_NONNULL_END
