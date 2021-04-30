//
//  Person.m
//  RuntimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import "Person.h"


@interface Person () {
    CGFloat _height;
    CGFloat _weight;
}

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSArray *likes;

@end

@implementation Person

- (void)swimming {
    NSLog(@"swimming");
}

- (void)doing {
    NSLog(@"doing something");
}

+ (void)working {
    NSLog(@"working");
}

@end

#pragma mark - Category

@implementation Person (Extension)

- (void)running {
    NSLog(@"running");
}

- (void)speaking {
    NSLog(@"speaking");
}

@end
