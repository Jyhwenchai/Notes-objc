//
//  Address.h
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ILMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Address : ILMModel

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *detail;

@end

NS_ASSUME_NONNULL_END
