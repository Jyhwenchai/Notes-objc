//
//  main.m
//  SolveArrayOutOfBounds
//
//  Created by 蔡志文 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *array = @[@1, @2, @3];
        NSLog(@"%@", [array objectAtIndex:4]);
        NSLog(@"%@", [array objectAtIndex:3]);
    }
    return 0;
}
