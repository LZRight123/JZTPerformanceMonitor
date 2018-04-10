//
//  JZTLaunchTimeManager.m
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTLaunchTimeManager.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTLaunchTimeManager()
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign,getter=isAlreadyRecord) BOOL alreadyRecord;
@end

@implementation JZTLaunchTimeManager
+ (instancetype)manager{
    static JZTLaunchTimeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JZTLaunchTimeManager alloc]init];
    });
    return instance;
}

-(void)startRecord{
    self.startTime = CACurrentMediaTime();
}

- (void)endRecord{
    if (!self.isAlreadyRecord) {
        self.alreadyRecord = YES;
        self.endTime = CACurrentMediaTime();
    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ systmeVersion %.3f LaunchTimeInterval %f",[[UIDevice currentDevice]machineModelName],[UIDevice systemVersion],self.endTime - self.startTime];

}
@end
