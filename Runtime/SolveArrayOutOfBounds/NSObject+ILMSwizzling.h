//
//  NSObject+ILMSwizzling.h
//  SolveArrayOutOfBounds
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ILMSwizzling)

+ (void)ilm_swizzeMethod:(SEL)originSel withMethod:(SEL)swizzledSel;

@end

NS_ASSUME_NONNULL_END
