//
//  JZTShareVC.m
//  JZTAudio
//
//  Created by 梁泽 on 2017/6/9.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import "JZTShareVC.h"
@interface JZTShareVC ()
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) NSString *shareURL;
@end

@implementation JZTShareVC
- (instancetype)initWithShareTitle:(NSString *)title img:(UIImage *)img urlStr:(NSString *)url{
    NSMutableArray *activityItems = [NSMutableArray array];
    if (url) {
        [activityItems addObject:[NSURL URLWithString:url]];
    }
    if (title) {
        [activityItems addObject:title];
    }
    if (img) {
        [activityItems addObject:img];
    }

    self = [super initWithActivityItems:activityItems applicationActivities:nil];
    self.shareTitle = title;
    self.shareImg = img?:[UIImage imageNamed:@"logo"];
    self.shareURL = url;
    [self configActivityType];
    return self;
}

- (void)configActivityType{
    NSMutableArray *tmpArr = @[UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePrint,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAirDrop].mutableCopy;
    if (self.shareURL) {
        [tmpArr addObject:UIActivityTypeSaveToCameraRoll];
    }
    self.excludedActivityTypes = tmpArr.copy;

}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError){
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
//        if (activityType == UIActivityTypeCopyToPasteboard) {
//            hud.label.text = @"copy success";
//            [hud hideAnimated:YES afterDelay:.6];
//        }
//        if (activityType == UIActivityTypeSaveToCameraRoll) {
//            hud.label.text = @"save success";
//            [hud hideAnimated:YES afterDelay:.6];
//        }
//        [hud hideAnimated:NO afterDelay:0];
    }];
}

#pragma mark - 定制
/*系统做了
- (void)copyToPasteboard{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.shareType == JZTShareTypeWeb) {
        if (self.shareURL) {
            pasteboard.string = self.shareURL;
        }else if(self.shareImg){
            pasteboard.image = self.shareImg;
        }else if(self.shareTitle){
            pasteboard.string = self.shareTitle;
        }
    }
    if (self.shareType == JZTShareTypeOnlyImg && self.shareImg) {
        pasteboard.image = self.shareImg;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
    hud.label.text = @"copy success";
    [hud hideAnimated:YES afterDelay:.7];
}*/


@end
