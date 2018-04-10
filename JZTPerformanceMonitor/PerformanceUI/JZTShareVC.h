//
//  JZTShareVC.h
//  JZTAudio
//
//  Created by 梁泽 on 2017/6/9.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface JZTShareVC : UIActivityViewController
//参数可传nil
- (instancetype)initWithShareTitle:(NSString *)title img:(UIImage *)img urlStr:(NSString *)url;

@end
