//
//  JZTSessionConfiguration.m
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTSessionConfiguration.h"
#import <objc/runtime.h>
#import "JZTHttpProtocol.h"
@interface JZTSessionConfiguration()
@property (nonatomic, assign) BOOL isSwizzle;
@end

@implementation JZTSessionConfiguration

+ (void)configurationURLProtocol{
    [[[JZTSessionConfiguration alloc]init] load];
    [NSURLProtocol registerClass:[JZTHttpProtocol class]];
}

+ (JZTSessionConfiguration *) defaultConfiguration{
    static JZTSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration =[[JZTSessionConfiguration alloc] init];
    });
    return staticConfiguration;
}

- (instancetype) init{
    self = [super init];
    if(self){
        self.isSwizzle = NO;
    }
    return self;
}

- (void)load{
    self.isSwizzle=YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?:NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub{
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if(!originalMethod || !stubMethod){
        [NSException raise:NSInternalInconsistencyException format:@"Could't load NSURLSessionConfiguration "];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses{
    return @[[JZTHttpProtocol class]];
}

@end
