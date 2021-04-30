
1. [[NSObject alloc] init] 和 [NSObject new] 有什么区别？

    没有区别
    
2. 是否能向编译好的类添加变量？是否能向运行时的类添加变量
    - 不能向编译好的类添加变量，以为编译好的类的变量在内存中的布局已经固定，不能被修改instanceSize已经固定，此时在运行时添加变量会超出其instanceSize范围。
    - 可以向运行时的类添加变量，但必须在 `objc_allocateClassPair` 和 `objc_registerClassPair` 之间添加

3. 给类添加一个属性之后，类中的结构体有那些元素会发生变化？
    - 通过 `@property` 添加
        - instanceSize 实例大小
        - ivar_list_t 变量列表
        - method_list_t 方法列表
        - property_list_t 属性列表
    - 通过 `class_addProperty
        - property_list_t 属性列表, 因为在编译好的类中 instanceSize 已经固定 

4. _objc_msgForward 函数是做什么的？直接调用会发生什么？

    _objc_msgForward 会进入消息转发处理, 直接调用奔溃，因为直接调用就直接进入消息转发了，如果没有实现消息转发相关方法的处理就回奔溃

5. 使用runtime Associate 方法关联对象，需要在主对象dealloc的时候释放吗？

    不需要, 它们会被 NSObject-dealloc 调用的 object-dispose 方法中释放，释放时，如果是强引用retain则release

6. runtime 如何实现 weak 属性，如何做到自动释放置为nil

7. 下面的代码输出是什么？
```objective-c
@implementation Son: Father
- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}
@end
```
都是输出 Son, 因为执行 `[super class]` 的时候会调用 objc_msgSendSuper(&objcSuper, @selector(class)) , 而objcSuper 是一个结构体其中的消息的接收者为 self，所以打印的还是 Son。
 ```
 struct objc_super objcSuper = {
    self,
    class_getSuperclass([self class]),
};
objc_msgSendSuper(&objcSuper, @selector(class))
```

