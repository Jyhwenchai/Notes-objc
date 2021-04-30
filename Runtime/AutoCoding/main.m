//
//  main.m
//  AutoCoding
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        // 获取Document目录
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"ilosic.plist"];
    
        Person *person = [[Person alloc] init];
        person.name = @"ilosc";
        person.age = 27;
        person.height = 170;
        [NSKeyedArchiver archiveRootObject:person toFile:filePath];
        
        Person *fetchPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSLog(@"name:%@, age:%d, height:%d", fetchPerson.name, fetchPerson.age, fetchPerson.height);
        
        
    }
    return 0;
}
