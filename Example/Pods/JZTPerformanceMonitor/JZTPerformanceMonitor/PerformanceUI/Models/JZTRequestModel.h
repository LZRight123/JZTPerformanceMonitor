//
//  JZTRequestModel.h
//  hyb
//
//  Created by 梁泽 on 2017/9/6.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JZTReachabilityStatus) {
    JZTReachabilityStatusNone,
    JZTReachabilityStatusWiFi,
    JZTReachabilityWWANStatus2G,
    JZTReachabilityWWANStatus3G,
    JZTReachabilityWWANStatus4G,
};

@interface JZTRequestModel : NSObject<NSCopying>
@property (nonatomic, strong, readonly) NSString *requestUUID;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSData *requestBodyData;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSMutableData *mutableData;

@property (nonatomic, assign) JZTReachabilityStatus networkStatus;

- (void)endCofig;
@end


@interface JZTRequestModel()
@property (nonatomic, strong, readonly) NSString *URLString;
@property (nonatomic, strong, readonly) NSString *contentSize;//K

- (id)requestParameters;
- (NSString *)requestParametersString;
- (NSDictionary *)requestHeaderFields;
- (NSString *)requestHeaderFieldsString;
- (NSTimeInterval)duration;
- (NSString *)startTime;
- (NSString *)endTime;
- (id)responseObj;
- (NSString *)responseString;
- (BOOL)isImgSource;
- (NSString *)networkStatusString;

@end

