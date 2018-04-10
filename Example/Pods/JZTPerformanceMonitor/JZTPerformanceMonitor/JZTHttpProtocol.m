//
//  JZTHttpProtocol.m
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTHttpProtocol.h"
#import "JZTRecordRequestList.h"

@interface JZTHttpProtocol()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSOperationQueue *sessionDelegateQueue;

@property (nonatomic, strong) JZTRequestModel *model;
@end


@implementation JZTHttpProtocol

static NSString *kOurRequestFlagProperty = @"com.apple.JZTHTTPProtocol";
#define kTimeOutTime 30

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *scheme =[[request URL] scheme];
    
    if(![[scheme lowercaseString] isEqualToString:@"http"] &&
       ![[scheme lowercaseString] isEqualToString:@"https"]){
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:kOurRequestFlagProperty inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
//    if (!request.HTTPBody && [request.URL.absoluteString containsString:BASE_TRACKER_URL]){
//        NSMutableURLRequest *mutableRequest = request.mutableCopy;
//        if (![request.HTTPBodyStream isKindOfClass:NSClassFromString(@"AFMultipartBodyStream")]) {
//            NSUInteger lenght = [[request.allHTTPHeaderFields objectForKey:@"Content-Length"] integerValue];
//            if (lenght > 0 && lenght < 20 * 1024 * 1024) {
//                NSInputStream * stream =  request.HTTPBodyStream;//[self.request.HTTPBodyStream copy];
//                [stream open];
//                NSMutableData * tempData = [NSMutableData data];
//
//                while (YES) {
//                    uint8_t buffer[lenght];
//                    unsigned int numBytes;
//                    if(stream.hasBytesAvailable)
//                    {
//                        numBytes = [stream read:buffer maxLength:lenght];
//                        if (numBytes > 0) {
//                            [tempData appendData:[NSData dataWithBytes:buffer length:numBytes]];
//                        }
//                        if (tempData.length == lenght) {
//                            [stream close];
//                            break;
//                        }
//                    }
//                }
//                mutableRequest.HTTPBody = tempData;
//                return mutableRequest;
//            }
//        }
//    }
    
    return request;
}

- (void)startLoading{
     [NSURLProtocol setProperty:@(YES) forKey:kOurRequestFlagProperty inRequest:self.request];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionDelegateQueue                             = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name                        = @"urlprotocol.session.queue";
    NSURLSession *session                                 = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.sessionDelegateQueue];
    self.dataTask                                         = [session dataTaskWithRequest:self.request];
    
    [self startConfigRequestModel];
    [self.dataTask resume];
}

-(void)stopLoading{
    [self.dataTask cancel];
}

#pragma mark - config model
- (void)startConfigRequestModel{
    self.model = [[JZTRequestModel alloc]init];
    
    NSURLRequest *request =  self.request;
    self.model.request = request.copy;
    
    if (request.HTTPBody) {
        self.model.requestBodyData = request.HTTPBody;
    }else
    {
        if (![request.HTTPBodyStream isKindOfClass:NSClassFromString(@"AFMultipartBodyStream")]) {
            NSUInteger lenght = [[request.allHTTPHeaderFields objectForKey:@"Content-Length"] integerValue];
            if (lenght > 0 && lenght < 20 * 1024 * 1024) {
                
                NSInputStream * stream =  self.request.HTTPBodyStream;//[self.request.HTTPBodyStream copy];
                [stream open];
                NSMutableData * tempData = [NSMutableData data];
                
                while (YES) {
                    uint8_t buffer[lenght];
                    unsigned int numBytes;
                    if(stream.hasBytesAvailable)
                    {
                        numBytes = [stream read:buffer maxLength:lenght];
                        if (numBytes > 0) {
                            [tempData appendData:[NSData dataWithBytes:buffer length:numBytes]];
                        }
                        if (tempData.length == lenght) {
                            [stream close];
                            break;
                        }
                    }
                }
                self.model.requestBodyData = tempData;
            }
        }
    }
}

- (void)endConfigRequestModel{
    [self.model endCofig];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
//    NSMutableURLRequest *redirectRequest = [newRequest mutableCopy];
//    [[self class] removePropertyForKey:kOurRequestFlagProperty inRequest:redirectRequest];
//    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
//    [self.dataTask cancel];
//    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
//    if (response != nil){
//        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
//        if ([HTTPResponse statusCode] == 301 || [HTTPResponse statusCode] == 302)
//        {
//            completionHandler(nil);
//        }else{
//            [[self client] URLProtocol:self wasRedirectedToRequest:newRequest redirectResponse:response];
//        }
//    }
    [[self client] URLProtocol:self wasRedirectedToRequest:newRequest redirectResponse:response];
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        if(completionHandler){
//            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//        }
//    }else{
//        if(completionHandler){
//            completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
//        }
//    }
//}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.client URLProtocol:self didLoadData:data];
    [self.model.mutableData appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler{
    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    self.model.endDate = [NSDate date];
    if (error) {
        self.model.error = error;
        if (self.model.duration > kTimeOutTime) {
            self.model.statusCode = NSURLErrorTimedOut;
        }else{
            self.model.statusCode = error.code;
        }
    }else{
        NSURLResponse *response = task.response;
        self.model.MIMEType = response.MIMEType;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            self.model.statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        
    }
    
    [self.model endCofig];
    
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    
}


@end
