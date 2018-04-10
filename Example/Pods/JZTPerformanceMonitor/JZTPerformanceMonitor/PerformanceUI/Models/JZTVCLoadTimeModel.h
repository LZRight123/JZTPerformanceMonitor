//
//  JZTVCLoadTimeModel.h
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZTVCLoadTimeModel : NSObject<NSCoding>
@property (nonatomic, strong, readonly) NSString *recordTime;
@property (nonatomic, strong, readonly) NSString *deviceInfo;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *loadList;

@end
