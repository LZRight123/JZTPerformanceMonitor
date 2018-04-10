//
//  JZTRequestModel.m
//  hyb
//
//  Created by 梁泽 on 2017/9/6.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTRequestModel.h"
#import "JZTRecordRequestList.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTRequestModel()
@property (nonatomic, strong,readwrite) NSString *requestUUID;
@end

@implementation JZTRequestModel

- (instancetype)init{
    if (self = [super init]) {
        self.startDate = [NSDate date];
        self.mutableData = [NSMutableData data];
        
//        CFUUIDRef uuid = CFUUIDCreate(nil);
//        _requestUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
//        CFRelease(uuid);
        self.requestUUID =[NSUUID UUID].UUIDString;
        
        YYReachability *reach =[YYReachability reachability];
        YYReachabilityStatus status = reach.status;
        if (status == YYReachabilityStatusNone) {
            self.networkStatus = JZTReachabilityStatusNone;
        }
        if (status == YYReachabilityStatusWiFi) {
            self.networkStatus = JZTReachabilityStatusWiFi;
        }
        if (status == YYReachabilityStatusWWAN) {
            YYReachabilityWWANStatus wwan = reach.wwanStatus;
            switch (wwan) {
                case YYReachabilityWWANStatusNone:
                    self.networkStatus = JZTReachabilityStatusNone;
                    break;
                case YYReachabilityWWANStatus2G:
                    self.networkStatus = JZTReachabilityWWANStatus2G;
                    break;
                case YYReachabilityWWANStatus3G:
                    self.networkStatus = JZTReachabilityWWANStatus3G;
                    break;
                case YYReachabilityWWANStatus4G:
                    self.networkStatus = JZTReachabilityWWANStatus4G;
                    break;
            }
        }
    }
    return self;
}

- (void)endCofig{
    [[JZTRecordRequestList defaultInstance] recordRequestApi:self.copy];
}

- (NSString *)URLString{
    return self.request.URL.absoluteString;
}

- (NSString *)contentSize{
    return [NSString stringWithFormat:@"size:%.2fk",self.mutableData.length / 1024.];
}

- (NSTimeInterval)duration{
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

- (id)requestParameters{
    return [self.requestBodyData jsonValueDecoded];
}

- (NSString *)requestParametersString{
    return [self.requestBodyData utf8String];
}

- (NSDictionary *)requestHeaderFields{
    return self.request.allHTTPHeaderFields;
}

- (NSString *)requestHeaderFieldsString{
    return [self.requestHeaderFields jsonStringEncoded];
}

- (NSString *)startTime{
    return [self.startDate stringWithFormat:@"MM.dd hh:mm:ss.SSS"];
}

- (NSString *)endTime{
    return [self.endDate stringWithFormat:@"MM.dd hh:mm:ss.SSS"];
}

- (NSString *)responseString{
    return [self.mutableData utf8String];
}

- (id)responseObj{
    return [self.mutableData jsonValueDecoded];
}

- (BOOL)isImgSource{
    return [[self.MIMEType lowercaseString] containsString:@"jpg"] || [[self.MIMEType lowercaseString] containsString:@"image"] || [[self.MIMEType lowercaseString] containsString:@"png"] || [[self.MIMEType lowercaseString] containsString:@"jpeg"];
}

- (NSString *)networkStatusString{
    NSString *net = @"未知";
    switch (self.networkStatus) {
        case JZTReachabilityStatusNone:
            net = @"未知";
            break;
        case JZTReachabilityStatusWiFi:
            net = @"WiFi";
            return net;
            break;
        case JZTReachabilityWWANStatus2G:
            net = @"2G";
            break;
        case JZTReachabilityWWANStatus3G:
            net = @"3G";
            break;
        case JZTReachabilityWWANStatus4G:
            net = @"4G";
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",[self chekMoblileOperator],net];
}


#pragma mark - tool
- (NSString *)chekMoblileOperator{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
    if (!mobileNetworkCode) {
        return @"";
    }
    return carrier.carrierName;
}


#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone{
    return [self modelCopy];
}
@end
