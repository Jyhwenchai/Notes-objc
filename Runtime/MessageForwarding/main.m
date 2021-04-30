//
//  main.m
//  MessageForwarding
//
//  Created by 蔡志文 on 2021/4/26.
//

#import <Foundation/Foundation.h>
#import "People.h"
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        /*
         打印 runtime 信息
         开启：call (void)instrumentObjcMessageSends(YES)
         关闭：call (void)instrumentObjcMessageSends(NO)
         日志：/private/tmp/ 文件夹，找到最新的 msgSends-xxxx文件
         */
        Person *person  = [Person new];
        [person performSelector:@selector(working)];
        [person performSelector:@selector(working)];
        
        printf("\n");
        
        [Person performSelector:NSSelectorFromString(@"sleeping")];
        [Person performSelector:NSSelectorFromString(@"saying")];
        
        printf("\n");
        
        [person performSelector:NSSelectorFromString(@"eating")];
        
        person.name = @"ilosic";
        NSLog(@"person name：%@", person.name);
        
        printf("\n");
        
        [person performSelector:NSSelectorFromString(@"swimming")];
        [person performSelector:NSSelectorFromString(@"running")];
    }
    return 0;
}
