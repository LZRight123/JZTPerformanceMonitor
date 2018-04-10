//
//  JZTDragWindow.h
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JZTDragWindowState) {
    JZTDragWindowStateSmall,
    JZTDragWindowStateMedium,
};

@interface JZTDragWindow : UIWindow
@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) JZTDragWindowState state;
@property (nonatomic, weak  ) UIViewController *sourceVC;

+ (instancetype)window;
@end
