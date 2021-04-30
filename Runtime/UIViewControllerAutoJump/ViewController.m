//
//  ViewController.m
//  UIViewControllerAutoJump
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = @{@"controller": @"ViewController1", @"property": @{ @"name": @"ilosic"}};
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.data = @{@"controller": @"ViewController1", @"property": @{ @"name": @"ilosic"}};
            break;
        case 1:
            self.data = @{@"controller": @"ViewController2", @"property": @{ @"like": @"music"}};
            break;
        case 2:
            self.data = @{@"controller": @"ViewController3", @"property": @{ @"say": @"Hello, World"}};
            break;
        default:
            break;
    }
}

- (IBAction)push:(UIButton *)sender {
    NSDictionary *data = self.data;
    
    const char *vcName = [data[@"controller"] UTF8String];
    NSDictionary *propertys = data[@"property"];
    NSArray *keys = propertys.allKeys;
    
    Class cls = objc_getClass(vcName);
    /// 不存在指定Controller就创建一个
    if (!cls) {
        Class superCls = UIViewController.class;
        cls = objc_allocateClassPair(superCls, vcName, 0);
        // 添加成员变量
        [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            class_addIvar(cls, obj.UTF8String, sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        }];
      
        objc_registerClassPair(cls);
        
        // 添加方法来执行 viewDidLoad
        SEL sel = @selector(viewDidLoad);
        Method method = class_getInstanceMethod(self.class, @selector(customViewDidLoad));
        IMP imp = method_getImplementation(method);
        class_addMethod(cls, sel, imp, method_getTypeEncoding(method));
    }
    
    // 创建并为要跳转的控制器赋值
    id controller = [[cls alloc] init];
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 找到对应的属性则赋值
        if (class_getProperty(cls, obj.UTF8String)) {
            [controller setValue:propertys[obj] forKey:obj];
        } else if (class_getInstanceVariable(cls, obj.UTF8String)) {
            // 找到对应的成员变量则赋值
            [controller setValue:propertys[obj] forKey:obj];
        }
    }];
    
    // 跳转
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)customViewDidLoad {
    [super viewDidLoad];
    // 动态添加一个label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColor.redColor;
    label.text = [self valueForKey: @"say"];
    [self.view addSubview: label];
//    self.view.backgroundColor = UIColor.whiteColor;
    [self setValue:UIColor.orangeColor forKeyPath:@"view.backgroundColor"];
    
}

@end
