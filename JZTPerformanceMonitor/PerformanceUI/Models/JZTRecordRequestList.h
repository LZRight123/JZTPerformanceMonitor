//
//  JZTRecordRequestList.h
//  hyb
//
//  Created by 梁泽 on 2017/9/6.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZTRequestModel.h"
@class JZTRecordRequestList;

@protocol JZTRecordRequestListDelegate<NSObject>
- (void)JZTRecordRequestListDidChange:(JZTRecordRequestList *)requestList;
@end

@interface JZTRecordRequestList : NSObject
@property (nonatomic, strong, readonly) NSArray<JZTRequestModel *> *apiList;
@property (nonatomic, weak  ) id<JZTRecordRequestListDelegate> delegate;

+ (instancetype)defaultInstance;
- (void)recordRequestApi:(JZTRequestModel *)api;
- (void)deleteRequestApi:(JZTRequestModel *)api;
@end


