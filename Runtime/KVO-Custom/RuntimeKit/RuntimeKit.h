//
//  RuntimeKit.h
//  RuntimeAPI
//
//  Created by 蔡志文 on 2021/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeKit : NSObject

/// 根据指定类名获取类
/// @param className 类名
+ (Class)fetchClass:(NSString *)className;

/// 根据指定类获取类名
/// @param cls 要获取类名的类
+ (NSString *)fetchClassName:(Class)cls;

/// 获取指定类的成员变量列表
/// @param cls 要获取成员变量列表的类
+ (NSArray *)fetchIvarList:(Class)cls;

/// 获取指定类的成员属性列表
/// @param cls 要获取成员属性列表的类
+ (NSArray *)fetchPropertyList:(Class)cls;

/// 获取指定类的方法列表
/// @param cls 要获取方法列表的类
/// @discussion 获取的方法可以是类方法或者是实例方法，取决于传入的 cls，如果 cls 是类则得到实例方法，如果 cls 是元类则得到的是类方法。
+ (NSArray *)fetchMethodList:(Class)cls;

/// 获取指定类的协议列表
/// @param cls 要获取协议列表的类
+ (NSArray *)fetchProtocolList:(Class)cls;

/// 获取指定协议的属性列表
/// @param protocol 要获取属性列表的协议
+ (NSArray *)fetchProtocolPropertyList:(Protocol *)protocol;

/// 获取指定协议的方法列表
/// @param protocol 要获取方法列表的协议
+ (NSArray *)fetchProtocolMethodList:(Protocol *)protocol;


/// 为指定类添加方法
/// @param fromCls 添加方法真正实现的类
/// @param fromMethod 真正实现类中方法的签名
/// @param toCls 要添加的类
/// @param toMethod 要添加的类的方法签名
+ (void)addMethod:(Class)fromCls fromMethod:(SEL)fromMethod methodClass:(Class)toCls toMethod:(SEL)toMethod;



/// 动态交换方法
/// @param cls 指定交换方法的类
/// @param method1 要交换的方法
/// @param method2 要交换的方法
+ (void)exchangeMethod:(Class)cls firstMethod:(SEL)method1 secondeMethod:(SEL)method2;
@end

NS_ASSUME_NONNULL_END
//95589
