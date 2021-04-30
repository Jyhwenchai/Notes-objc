//
//  CustomProtocol.h
//  RuntimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomProtocol <NSObject>

@optional
@property (nonatomic, copy) NSString *description;

- (void)print;
+ (void)output;

@required
@property (nonatomic, assign) NSInteger size;

- (void)toString;
+ (NSInteger)count;

@end

NS_ASSUME_NONNULL_END
