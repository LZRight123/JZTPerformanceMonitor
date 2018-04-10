//
//  JZTExceptionListVC.m
//  hyb
//
//  Created by 梁泽 on 2017/10/9.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTExceptionListVC.h"
#import "JZTNavTitleView.h"
#import "JZTCaptureException.h"
#import "JZTMenuCell.h"
#import "JZTExceptionDetailVC.h"
@interface JZTExceptionListVC ()

@end

@implementation JZTExceptionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"carsh list"];
    self.tableView.estimatedRowHeight = 120;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [JZTCaptureException manager].exceptionHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JZTMenuCell *cell = [JZTMenuCell cellWithTableView:tableView];
    cell.textLabel.numberOfLines = 0;
    NSString *text = [JZTCaptureException manager].exceptionHistory[indexPath.row];
    NSArray *tema = [text componentsSeparatedByString:@"("];
    cell.textLabel.text = tema.firstObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTExceptionDetailVC *nextVC = [[JZTExceptionDetailVC alloc]init];
    nextVC.exceptionInfo = [JZTCaptureException manager].exceptionHistory[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
