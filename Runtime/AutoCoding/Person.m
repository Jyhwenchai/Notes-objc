//
//  Person.m
//  AutoCoding
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "Person.h"
#import "NSObject+ILMCoding.h"

@implementation Person

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self ilm_encodeWithCoder:coder];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self ilm_decoderWithCoder:coder];
    }
    return self;
}


@end
