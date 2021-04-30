//
//  Person.h
//  AutoCoding
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger height;

@end

NS_ASSUME_NONNULL_END
