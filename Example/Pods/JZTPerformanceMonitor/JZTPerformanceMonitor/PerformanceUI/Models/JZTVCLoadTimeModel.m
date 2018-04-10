//
//  JZTVCLoadTimeModel.m
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTVCLoadTimeModel.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTVCLoadTimeModel()
@property (nonatomic, strong, readwrite) NSString *recordTime;
@property (nonatomic, strong, readwrite) NSString *deviceInfo;
@property (nonatomic, strong, readwrite) NSMutableArray<NSString *> *loadList;
@end

@implementation JZTVCLoadTimeModel
- (instancetype)init{
    if (self = [super init]) {
        self.loadList = [NSMutableArray array];
        NSString *device = [[UIDevice currentDevice]machineModelName];
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        NSMutableString *infoString = [[NSMutableString alloc]initWithString:device];
        [infoString appendFormat:@"\nversion is : %@",phoneVersion];
        self.deviceInfo = infoString;
        self.recordTime = [[NSDate date]stringWithFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return self;
}

- (NSString *)description{
    NSMutableString *mutableString = [[NSMutableString alloc]init];
    [mutableString appendString:self.recordTime];
    [mutableString appendFormat:@"\n%@",self.deviceInfo];
    [mutableString appendFormat:@"\n%@",[self.loadList componentsJoinedByString:@"\n"]];
    return mutableString.copy;
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
