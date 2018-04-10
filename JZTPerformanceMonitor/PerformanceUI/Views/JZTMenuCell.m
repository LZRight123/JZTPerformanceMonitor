//
//  JZTMenuCell.m
//  JZTAudio
//
//  Created by 梁泽 on 2017/10/10.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import "JZTMenuCell.h"
#import "JZTShareVC.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@implementation JZTMenuCell

+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView{
    NSString *ID = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[self class] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupUI];
    return self;
}

- (void)setupUI{
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
    if ([self.delegate respondsToSelector:@selector(JZTMenuCellNeedCopyText:)]) {
        [UIPasteboard generalPasteboard].string = [self.delegate JZTMenuCellNeedCopyText:self];
    }else{
        [UIPasteboard generalPasteboard].string = self.textLabel.text?:@"";
    }
}

- (void)shareAction:(UIMenuController *)sender{
    if ([self.delegate respondsToSelector:@selector(JZTMenuCellNeedCopyText:)]) {
        NSString *text = [self.delegate JZTMenuCellNeedCopyText:self];
        if (text.length) {
            JZTShareVC *nextVC = [[JZTShareVC alloc] initWithShareTitle:text img:nil urlStr:nil];
            [self.viewController presentViewController:nextVC animated:YES completion:nil];
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copyAction:) || action == @selector(shareAction:));
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
