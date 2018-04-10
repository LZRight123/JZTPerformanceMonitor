//
//  JZTLaunchTimeManager.h
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZTLaunchTimeManager : NSObject

+ (instancetype)manager;
- (void)startRecord;
- (void)endRecord;

@end
