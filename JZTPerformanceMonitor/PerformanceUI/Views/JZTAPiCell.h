//
//  JZTAPiCell.h
//  hyb
//
//  Created by 梁泽 on 2017/9/8.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZTRequestModel;

@interface JZTAPiCell : UITableViewCell
@property (nonatomic, strong) JZTRequestModel *model;
+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView;
@end
