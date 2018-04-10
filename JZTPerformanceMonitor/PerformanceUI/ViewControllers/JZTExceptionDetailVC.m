//
//  JZTExceptionListVC.m
//  hyb
//
//  Created by 梁泽 on 2017/10/9.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTExceptionDetailVC.h"
#import "JZTNavTitleView.h"
#import "JZTCaptureException.h"
#import "JZTMenuCell.h"
@interface JZTExceptionDetailVC ()<JZTMenuCellDelegate>

@end

@implementation JZTExceptionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"exception detail"];
    self.tableView.estimatedRowHeight = 120;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JZTMenuCell *cell = [JZTMenuCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.exceptionInfo;
    return cell;
}

#pragma mark - JZTMenuCellDelegate
- (NSString *)JZTMenuCellNeedCopyText:(JZTMenuCell *)cell{
    return self.exceptionInfo;
}
@end

