//
//  UIViewController+DisplayTime.h
//  hyb
//
//  Created by 梁泽 on 2017/7/11.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LogDisplayTime 1
#ifdef LogDisplayTime
# define JZTDisplayLog(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#else
# define JZTDisplayLog(...);
#endif
@interface UIViewController(DisplayTime)
@property (nonatomic, assign) CFTimeInterval createTime;
@property (nonatomic, assign) CFTimeInterval loadViewTime;
@property (nonatomic, assign) CFTimeInterval displayTime;
@property (nonatomic, assign) BOOL alreadyDisplay;
@end
