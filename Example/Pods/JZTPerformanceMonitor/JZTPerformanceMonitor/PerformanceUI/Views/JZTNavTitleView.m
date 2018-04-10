//
//  JZTNavTitleView.m
//  hyb
//
//  Created by 梁泽 on 2017/9/19.
//  Copyright © 2017年 九州通. All rights reserved.
//
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#import "JZTNavTitleView.h"
#import "JZTDragWindow.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTNavTitleView()
@property (nonatomic, strong) NSString *title;
@end
@implementation JZTNavTitleView

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.title = title;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.frame = CGRectMake(0, 0, ScreenWidth/2, 44);
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}


#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[JZTDragWindow window] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[JZTDragWindow window] touchesMoved:touches withEvent:event];
}

@end
