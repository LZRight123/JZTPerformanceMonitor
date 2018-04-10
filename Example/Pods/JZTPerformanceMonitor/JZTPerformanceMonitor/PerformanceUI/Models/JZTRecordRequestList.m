//
//  JZTRecordRequestList.m
//  hyb
//
//  Created by 梁泽 on 2017/9/6.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTRecordRequestList.h"
@interface JZTRecordRequestList()
@property (nonatomic, strong, readwrite) NSMutableArray<JZTRequestModel *> *list;
@property (nonatomic, strong) NSLock *lock;
@end

static NSString * const JZTRecordRequestListLockName = @"com.JZTRecordRequestList.lock";

@implementation JZTRecordRequestList
+ (instancetype)defaultInstance{
    static JZTRecordRequestList *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.lock = [[NSLock alloc] init];
        self.lock.name = JZTRecordRequestListLockName;
    }
    return self;
}

- (NSInteger)indexOfApi:(JZTRequestModel *)api{
    if(![api isKindOfClass:[JZTRequestModel class]]){
        return -1;
    }
    NSInteger index = -1;
    for (NSInteger i = 0; i != self.list.count; ++i) {
        JZTRequestModel *model = self.list[i];
        if ([api.requestUUID isEqualToString:model.requestUUID]) {
            index = i;
            break;
        }
    }
    return index;
}

- (void)recordRequestApi:(JZTRequestModel *)api{
    if (api == nil) {
        return;
    }
    if(![api isKindOfClass:[JZTRequestModel class]]){
        return;
    }
    if ([api.URLString containsString:@"null"]) {
        return;
    }
    
    [self.lock lock];
    NSInteger index = [self indexOfApi:api];
    if (index >= 0) {
        [self.list removeObjectAtIndex:index];
    }
    
    [self.list insertObject:api atIndex:0];
    [self.lock unlock];
    [self notificationRequestUpdate];
}

- (void)deleteRequestApi:(JZTRequestModel *)api{
    NSInteger index = [self indexOfApi:api];
    if (index >= 0) {
        [self.lock lock];
        [self.list removeObjectAtIndex:index];
        [self.lock unlock];
        [self notificationRequestUpdate];
    }
}

- (void)notificationRequestUpdate{
    if ([self.delegate respondsToSelector:@selector(JZTRecordRequestListDidChange:)]) {
        [self.delegate JZTRecordRequestListDidChange:self];
    }
}



#pragma mark - getter
- (NSArray<JZTRequestModel *> *)apiList{
    return self.list.copy;
}

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
@end

