//
//  JZTLineChartView.h
//  图形图像集合
//
//  Created by 梁泽 on 16/5/11.
//  Copyright © 2016年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZTLineChartView;
@protocol JZTLineChartViewDataSource <NSObject>
- (NSInteger)numberOfDotsInLineChar:(JZTLineChartView*)lineChartView;
- (CGFloat)lineChart:(JZTLineChartView*)lineChartView valueForLineChartAtIndex:(NSInteger)index;
@optional
- (NSString *)lineChart:(JZTLineChartView*)lineChartView xLabelForLineChartAtIndex:(NSInteger)index;
- (NSString*)lineChart:(JZTLineChartView*)lineChartView lineTextForLineChartAtIndex:(NSInteger)index;
- (UIColor *)lineChart:(JZTLineChartView*)lineChartView colorForLineChartDotAtIndex:(NSInteger)index;
- (UIColor *)lineChartColorForLine:(JZTLineChartView*)lineChartView;
- (BOOL)lineChartShouldDot:(JZTLineChartView*)lineChartView;
@end
@protocol JZTLineChartViewDelegate <NSObject>
@optional
- (void)lineChartAnimationWillBegin:(JZTLineChartView*)lineChartView;
- (void)lineChartAnimationDidEnd:(JZTLineChartView*)lineChartView;

@end
@interface JZTLineChartView : UIView
@property (nonatomic,assign) IBInspectable CGFloat animationDuration;
@property (nonatomic,strong) IBInspectable UIColor *chartBorderColor;

@property (nonatomic,assign) IBInspectable BOOL hasVGrid;//垂直
@property (nonatomic,strong) IBInspectable UIColor *vGridColor;
@property (nonatomic,assign) IBInspectable BOOL hasHGrid;
@property (nonatomic,strong) IBInspectable UIColor *hGridColor;
@property (nonatomic,assign) IBInspectable CGFloat  lineWidth;
@property (nonatomic,assign) IBInspectable CGFloat dotRadius;

@property (nonatomic,assign) IBInspectable NSInteger incrementValue;// lineChart增量

@property (nonatomic,assign) IBInspectable BOOL hasYLabels;
@property (nonatomic,strong) IBInspectable UIFont *yLabelFont;
@property (nonatomic,strong) IBInspectable UIColor *yLabelColor;

@property (nonatomic,strong) IBInspectable UIFont *xLabelFont;
@property (nonatomic,strong) IBInspectable UIColor *xLabelColor;
@property (nonatomic,strong) IBInspectable UIFont *lineTextFont;
@property (nonatomic,strong) IBInspectable UIColor *lineTextColor;



@property (nonatomic,weak) IBOutlet id<JZTLineChartViewDataSource> dataSource;
@property (nonatomic,weak) IBOutlet id<JZTLineChartViewDelegate> delegate;
- (void) reloadData;
@end
