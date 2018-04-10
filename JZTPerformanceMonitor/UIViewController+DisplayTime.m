//
//  UIViewController+DisplayTime.m
//  hyb
//
//  Created by 梁泽 on 2017/7/11.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "UIViewController+DisplayTime.h"
#import "JZTHookViewDisplayTimeManager.h"
#import <objc/runtime.h>
@implementation UIViewController(DisplayTime)
void jzt_swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jzt_swizzle(self, @selector(init), @selector(jzt_init));
        jzt_swizzle(self, @selector(initWithNibName:bundle:), @selector(initWithNibName:bundle:));
        jzt_swizzle(self, @selector(loadView), @selector(jzt_loadView));
        jzt_swizzle(self, @selector(TC_viewDidAppear:), @selector(jzt_viewDidAppear:));
    });
}

- (instancetype)jzt_init{
    self.createTime = CACurrentMediaTime();
    return [self jzt_init];
}

- (instancetype)jzt_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self.createTime = CACurrentMediaTime();
    return [self jzt_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)jzt_loadView{
    self.loadViewTime = CACurrentMediaTime();
    [self jzt_loadView];
}

- (NSArray *)ignoreList{
    return @[ @"JZTMonitorNavigationVC", @"JZTMonitorListViewController", @"JZTLaunchTimeVC", @"JZTAPiListVC", @"JZTApiDetailVC", @"JZTExceptionListVC", @"JZTExceptionDetailVC", @"JZTVCLoadTimeVC", @"JZTVCLoadTimeDetailVC", @"JZTHistoryRequestVC", @"JZTAllImageRequestVC", @"", @"", ];
}

- (BOOL)atIgnoreList{
    BOOL result = NO;
    for (NSString *class in [self ignoreList]) {
        if ([class isEqualToString:NSStringFromClass([self class])]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (void)jzt_viewDidAppear:(BOOL)animated{
    if (![self atIgnoreList] && !self.alreadyDisplay) {
        self.displayTime = CACurrentMediaTime();
        NSString *logString = nil;
        if (self.loadViewTime != 0) {
            logString = [NSString stringWithFormat:@"[%@] from loadView to display time is : %f",NSStringFromClass([self class]),self.displayTime - self.loadViewTime];
            
        }else if(self.createTime != 0){
            logString = [NSString stringWithFormat:@"[%@] from create to display time is : %f",NSStringFromClass([self class]),self.displayTime - self.createTime];
        }
        if (logString) {
            JZTDisplayLog(@"%@",logString);
            [JZTDisPlayTimeManager addText:logString];
        }
        self.alreadyDisplay = YES;
    }
    
    [self jzt_viewDidAppear:animated];
}

#pragma mark -
- (void)setCreateTime:(CFTimeInterval)createTime{
    objc_setAssociatedObject(self, @selector(createTime), @(createTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval)createTime{
    return [objc_getAssociatedObject(self, @selector(createTime)) doubleValue];
}

- (void)setLoadViewTime:(CFTimeInterval)loadViewTime{
    objc_setAssociatedObject(self, @selector(loadViewTime), @(loadViewTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval)loadViewTime{
    return [objc_getAssociatedObject(self, @selector(loadViewTime)) doubleValue];
}

- (void)setDisplayTime:(CFTimeInterval)displayTime{
    objc_setAssociatedObject(self, @selector(displayTime), @(displayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval)displayTime{
    return [objc_getAssociatedObject(self, @selector(displayTime)) doubleValue];
}

- (void)setAlreadyDisplay:(BOOL)alreadyDisplay{
    objc_setAssociatedObject(self, @selector(alreadyDisplay), @(alreadyDisplay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)alreadyDisplay{
    return [objc_getAssociatedObject(self, @selector(displayTime)) boolValue];
}


@end


