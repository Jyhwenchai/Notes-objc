//
//  main.m
//  DictionaryToModel
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "User.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary *dict = @{
            @"age": @20,
            @"address": @{
                    @"num": @101,
                    @"detail": @"福建省福州市万福中心..."
            },
            @"dogs": @[
                    @{@"name": @"dog1"},
                    @{@"name": @"dog2"},
                    @{@"name": @"dog3"},
            ],
        };
        User *user = [[User alloc] initWithDictionary:dict];
        NSLog(@"user.name: %d\n\nuser.address.num: %ld, user.address.detail: %@\n", user.age, (long)user.address.num, user.address.detail);
        NSLog(@"user.dogs: ");
        for (Dog *dog in user.dogs) {
            NSLog(@"dog name: %@", dog.name);
        }
    }
    return 0;
}
