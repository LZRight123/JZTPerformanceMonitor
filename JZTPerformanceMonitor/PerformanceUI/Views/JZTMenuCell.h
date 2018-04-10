//
//  JZTMenuCell.h
//  JZTAudio
//
//  Created by 梁泽 on 2017/10/10.
//  Copyright © 2017年 梁泽. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  JZTMenuCell;
@protocol JZTMenuCellDelegate<NSObject>
- (NSString *)JZTMenuCellNeedCopyText:(JZTMenuCell *)cell;
@end

@interface JZTMenuCell : UITableViewCell
@property (nonatomic, weak  ) id<JZTMenuCellDelegate> delegate;

+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView;
@end
