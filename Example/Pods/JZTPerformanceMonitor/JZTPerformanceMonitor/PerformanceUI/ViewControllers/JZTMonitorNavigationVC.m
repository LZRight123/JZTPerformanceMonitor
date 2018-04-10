//
//  JZTMonitorNavigationVC.m
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTMonitorNavigationVC.h"
#import "JZTMonitorListViewController.h"
#import "JZTDragWindow.h"

@interface JZTMonitorNavigationVC ()

@end

@implementation JZTMonitorNavigationVC
+ (instancetype)create{
    JZTMonitorListViewController *rootVC = [[JZTMonitorListViewController alloc]init];
    return [[self alloc]initWithRootViewController:rootVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  重写这个方法,能拦截所有的push操作
 *
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(clickBackItem)];
    }
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    [super pushViewController:viewController animated:animated];
}
- (void)dismiss{
    [[JZTDragWindow window] setState:JZTDragWindowStateSmall];
}

- (void)clickBackItem{
    [self popViewControllerAnimated:YES];
}
@end
