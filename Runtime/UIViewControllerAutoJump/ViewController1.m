//
//  ViewController1.m
//  UIViewControllerAutoJump
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColor.redColor;
    label.text = _name;
    [self.view addSubview: label];
    self.view.backgroundColor = UIColor.whiteColor;
}



@end
