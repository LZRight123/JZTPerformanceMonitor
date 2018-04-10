//
//  JZTAPiDeatilCell.h
//  hyb
//
//  Created by 梁泽 on 2017/9/8.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZTRequestModel;
@class JZTAPiDeatilCell;
@protocol JZTAPiDeatilCellDelegate<NSObject>
- (void)JZTAPiDeatilCell:(JZTAPiDeatilCell *)cell shareURL:(NSString *)url response:(NSString *)response;
- (void)JZTAPiDeatilCellDidClickRequestHistory:(JZTAPiDeatilCell *)cell;
@end


@interface JZTAPiDeatilCell : UITableViewCell
@property (nonatomic, weak  ) id<JZTAPiDeatilCellDelegate> delegate;
@property (nonatomic, strong) JZTRequestModel *model;
+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView;
@end
