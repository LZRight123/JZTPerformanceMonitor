//
//  JZTHookViewDisplayTimeManager.h
//  JZTAudio
//
//  Created by 梁泽 on 2017/7/11.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JZTHookViewDisplayTimeManagerDelegate<NSObject>
- (void)JZTHookViewDisplayTimeManagerDidResfresh:(id)manager;
@end
@interface JZTHookViewDisplayTimeManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *list;
@property (nonatomic, weak  ) id<JZTHookViewDisplayTimeManagerDelegate> delegate;
#define JZTDisPlayTimeManager [JZTHookViewDisplayTimeManager manager]
+ (instancetype)manager;
- (void)addText:(NSString *)text;
- (void)deleteRecordAtIndex:(NSInteger)index;
- (void)deleteAllRecord;
@end
