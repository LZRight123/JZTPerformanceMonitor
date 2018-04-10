//
//  JZTMenuLabel.m
//  hyb
//
//  Created by 梁泽 on 2017/9/25.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTMenuLabel.h"
#import "JZTShareVC.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@implementation JZTMenuLabel

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:gesture];
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];

        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(copyAction:)];
        UIMenuItem *share = [[UIMenuItem alloc] initWithTitle:@"share" action:@selector(shareAction:)];

        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuItems:@[copy,share]];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)copyAction:(UIMenuController *)sender{
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)shareAction:(UIMenuController *)sender{
    JZTShareVC *nextVC = [[JZTShareVC alloc] initWithShareTitle:self.text img:nil urlStr:nil];
    [self.viewController presentViewController:nextVC animated:YES completion:nil];
}



- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copyAction:) || action == @selector(shareAction:));
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


@end
