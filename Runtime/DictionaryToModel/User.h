//
//  User.h
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ILMModel.h"
#import "Address.h"
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : ILMModel

@property (nonatomic, assign) int age;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *dogs;

@end

NS_ASSUME_NONNULL_END
