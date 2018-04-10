//
//  JZTAPiListVC.m
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#import "JZTAPiListVC.h"
#import "JZTRecordRequestList.h"
#import "JZTAPiCell.h"
#import "JZTApiDetailVC.h"
#import "JZTNavTitleView.h"
#import "JZTAllImageRequestVC.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTAPiListVC ()<UITableViewDataSource,UITableViewDelegate,JZTRecordRequestListDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JZTRequestModel *> *apiList;
@end

@implementation JZTAPiListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JZTRecordRequestList defaultInstance].delegate = self;
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"API list"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"look all image request" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLookAllImage) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = btn;
//    UIRefreshControl
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refershUI];
    }];
    header.stateLabel.hidden = YES;
    header.arrowView.alpha = 0;
    
    self.tableView.mj_header = header;
    [self refershUI];
}

- (void)refershUI{
    @try {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            self.apiList = [JZTRecordRequestList defaultInstance].apiList;
            [self.tableView reloadData];
        });
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)clickLookAllImage{
    JZTAllImageRequestVC *nextVC = [[JZTAllImageRequestVC alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
}
#pragma mark - JZTRecordRequestListDelegate
- (void)JZTRecordRequestListDidChange:(JZTRecordRequestList *)requestList{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });    
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.apiList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTAPiCell *cell = [JZTAPiCell cellWithTableView:tableView];
    
    JZTRequestModel *model = self.apiList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JZTRequestModel *model = self.apiList[indexPath.row];
    JZTApiDetailVC *nextVC = [[JZTApiDetailVC alloc]init];
    nextVC.model = model;
    [self.navigationController pushViewController:nextVC animated:YES];
}



#pragma mark - getter @property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.estimatedRowHeight = 50;

    }
    return _tableView;
}

@end
