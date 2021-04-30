//
//  ILMModel.h
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ILMModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end

@interface NSArray (ILMModel)

+ (NSArray *)ilm_modelArrayWithClass:(Class)cls value:(NSArray *)value;

@end

NS_ASSUME_NONNULL_END
