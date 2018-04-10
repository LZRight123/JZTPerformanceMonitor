//
//  JZTHookViewDisplayTimeManager.m
//  JZTAudio
//
//  Created by 梁泽 on 2017/7/11.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import "JZTHookViewDisplayTimeManager.h"
#import "JZTVCLoadTimeModel.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTHookViewDisplayTimeManager()
@property (nonatomic, strong, readwrite) NSMutableArray *list;
@property (nonatomic, strong) JZTVCLoadTimeModel *currentRecordModel;
@end

@implementation JZTHookViewDisplayTimeManager
static NSString *cacheKey = @"JZTHookViewDisplayTimeManager";
+ (instancetype)manager{
    static JZTHookViewDisplayTimeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self unarchiveFromDisk];
    }
    return self;
}

- (void)unarchiveFromDisk {
    YYCache *cache = [YYCache cacheWithName:NSStringFromClass([self class])];
    NSArray *list = (NSArray *)[cache objectForKey:cacheKey];
    if (list) {
        self.list = list.mutableCopy;
    }else{
        self.list = [[NSMutableArray alloc] init];
    }
 
    
}

- (JZTVCLoadTimeModel *)currentRecordModel{
    if (!_currentRecordModel) {
        _currentRecordModel = [[JZTVCLoadTimeModel alloc]init];
        [self.list insertObject:_currentRecordModel atIndex:0];
    }
    return _currentRecordModel;
}

- (void)saveToDisk{
    YYCache *cache = [YYCache cacheWithName:NSStringFromClass([self class])];
    [cache setObject:self.list.copy forKey:cacheKey];
}

- (void)addText:(NSString *)text{
    [self.currentRecordModel.loadList insertObject:text atIndex:0];
    if ([self.delegate respondsToSelector:@selector(JZTHookViewDisplayTimeManagerDidResfresh:)]) {
        [self.delegate JZTHookViewDisplayTimeManagerDidResfresh:self];
    }
    
    [self saveToDisk];
}

- (void)deleteRecordAtIndex:(NSInteger)index{
    [self.list removeObjectAtIndex:index];
    [self saveToDisk];
}

- (void)deleteAllRecord{
    self.list = [NSMutableArray array];
    YYCache *cache = [YYCache cacheWithName:NSStringFromClass([self class])];
    [cache removeObjectForKey:cacheKey];
}
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone{
    return [self modelCopy];
}
@end
