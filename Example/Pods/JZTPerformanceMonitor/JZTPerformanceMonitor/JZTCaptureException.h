//
//  JZTCaptureException.h
//  JZTAudio
//
//  Created by 梁泽 on 2017/10/9.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZTCaptureException : NSObject<NSCoding>
@property (nonatomic, strong, readonly) NSArray *exceptionHistory;
+ (void)start;
+ (instancetype)manager;
@end
