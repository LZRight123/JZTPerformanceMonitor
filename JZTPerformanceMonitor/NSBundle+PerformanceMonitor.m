//
//  NSBundle+PerformanceMonitor.m
//  JZTPerformanceMonitor_Example
//
//  Created by 梁泽 on 2018/4/10.
//  Copyright © 2018年 350442340@qq.com. All rights reserved.
//

#import "NSBundle+PerformanceMonitor.h"
#import "JZTCaptureException.h"
@implementation NSBundle (PerformanceMonitor)
+ (instancetype)performanceMonitorBundle{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[JZTCaptureException class]] pathForResource:@"JZTPerformanceMonitor" ofType:@"bundle"]];
    }
    return refreshBundle;
}
    
+ (UIImage *)jzt_drugImage{
    static UIImage *jzt_drugImage = nil;
    if (jzt_drugImage == nil) {
        jzt_drugImage = [[UIImage imageWithContentsOfFile:[[self performanceMonitorBundle] pathForResource:@"drug_Image@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return jzt_drugImage;
}
@end
