//
//  JZTViewController.m
//  JZTPerformanceMonitor
//
//  Created by 350442340@qq.com on 04/10/2018.
//  Copyright (c) 2018 350442340@qq.com. All rights reserved.
//

#import "JZTViewController.h"
#import "JZTDragWindow.h"
@interface JZTViewController ()

@end

@implementation JZTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}
    
    - (void)viewDidAppear:(BOOL)animated{
        [super viewDidAppear:animated];
        JZTDragWindow *dragWindow = [JZTDragWindow window];
        [dragWindow makeKeyAndVisible];
    }



@end
