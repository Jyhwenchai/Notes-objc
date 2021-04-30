//
//  ViewController2.m
//  UIViewControllerAutoJump
//
//  Created by 蔡志文 on 2021/4/29.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColor.redColor;
    label.text = _like;
    [self.view addSubview: label];
    self.view.backgroundColor = UIColor.whiteColor;
}


@end
