//
//  JZTViewDrawTimeManager.h
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZTViewDrawTimeManager : NSObject

//@property (nonatomic, strong, readonly) UIView *tagView;
//@property (nonatomic, strong, readonly) UIView *rootView;

- (BOOL)findTagView:(UIView *)tagV inViewHierarchy:(UIView *)rootView;
//- (void)endPageRenderEvent:(UIView *)tagV;
- (NSTimeInterval)drawInterval;
@end
