//
//  JZTCaptureException.m
//  JZTAudio
//
//  Created by 梁泽 on 2017/10/9.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import "JZTCaptureException.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTCaptureException()
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation JZTCaptureException
static NSString *cacheKey = @"cache_exception";
static NSUncaughtExceptionHandler *_previousHandler;

void JZTUncaughtExceptionHandler(NSException *exception) {
    NSString *time = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"%@\n%@  %@\n%@", time, name, reason, callStack];
    [[JZTCaptureException manager] recordException:exceptionInfo];
    _previousHandler(exception);
}

+ (void)start{
    _previousHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&JZTUncaughtExceptionHandler);
}

+ (instancetype)manager{
    static JZTCaptureException *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JZTCaptureException alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    YYCache *cache = [YYCache cacheWithName:NSStringFromClass([self class])];
    NSArray *exceptionList = (NSArray *)[cache objectForKey:cacheKey];
    if (exceptionList) {
        self.list = exceptionList.mutableCopy;
    }else{
        self.list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)exceptionHistory{
    return self.list.copy;
}

- (void)recordException:(NSString *)exceptionInfo{
    [self.list insertObject:exceptionInfo atIndex:0];
    [self saveToDisk];
}

- (void)saveToDisk{
    YYCache *cache = [YYCache cacheWithName:NSStringFromClass([self class])];
    [cache setObject:self.list.copy forKey:cacheKey];
}


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end
