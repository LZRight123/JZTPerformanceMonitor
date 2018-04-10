//
//  JZTVCLoadTimeVC.m
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTVCLoadTimeVC.h"
#import "JZTNavTitleView.h"
#import "JZTMenuCell.h"
#import "JZTHookViewDisplayTimeManager.h"
#import "JZTVCLoadTimeModel.h"
#import "JZTVCLoadTimeDetailVC.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTVCLoadTimeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JZTVCLoadTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"vc loadTime list"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return JZTDisPlayTimeManager.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTMenuCell *cell = [JZTMenuCell cellWithTableView:tableView];
    JZTVCLoadTimeModel *model = JZTDisPlayTimeManager.list[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"now";
    }else{
        cell.textLabel.text = model.recordTime;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTVCLoadTimeModel *model = JZTDisPlayTimeManager.list[indexPath.row];
    JZTVCLoadTimeDetailVC *nextVC = [[JZTVCLoadTimeDetailVC alloc]initWithModel:model];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.row == 0) {
            return ;
        }
        [JZTDisPlayTimeManager deleteRecordAtIndex:indexPath.row];
        [tableView reloadData];
    }];
    return @[action];
}

#pragma mark - getter @property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
