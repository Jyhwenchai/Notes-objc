//
//  NSObject+ILMSwizzling.m
//  SolveArrayOutOfBounds
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "NSObject+ILMSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (ILMSwizzling)

+ (void)ilm_swizzeMethod:(SEL)originSel withMethod:(SEL)swizzledSel {
    // 1. 获取 SEL 对应的 Method, 并检查是否有实现相应的方法
    Method originMethod = class_getInstanceMethod(self, originSel);
    if (!originMethod) {
        NSLog(@"origin method %@ not implemented", NSStringFromSelector(originSel));
        return;
    }
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
    if (!swizzledMethod) {
        NSLog(@"swizzle method %@ not implemented", NSStringFromSelector(swizzledSel));
        return;
    }
    
    // 2. 添加 originMethod 方法，避免 originMethod 方法是由父类实现的而子类并未实现
    // 如果父类已经存在此方法，子类未重写则会添加成功，如果子类重写了此方法则添加失败
    class_addMethod(self, originSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    // 同样，为了避免父类中已经存在 swizzledMethod 方法
    class_addMethod(self, swizzledSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // 3. 交换方法
    method_exchangeImplementations(originMethod, swizzledMethod);
}

@end
