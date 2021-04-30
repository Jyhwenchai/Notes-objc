//
//  NSObject+ILMCoding.h
//  AutoCoding
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ILMCoding)

- (void)ilm_encodeWithCoder:(NSCoder *)coder;
- (void)ilm_decoderWithCoder:(NSCoder *)coder;

@end

NS_ASSUME_NONNULL_END
