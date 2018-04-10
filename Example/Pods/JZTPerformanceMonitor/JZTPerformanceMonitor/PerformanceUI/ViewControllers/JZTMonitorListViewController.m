//
//  JZTMonitorListViewController.m
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTMonitorListViewController.h"
#import "JZTNavTitleView.h"

#import "JZTLaunchTimeVC.h"
#import "JZTAPiListVC.h"
#import "JZTExceptionListVC.h"
#import "JZTVCLoadTimeVC.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTMonitorListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation JZTMonitorListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"Monitor list"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    SEL method = NSSelectorFromString(dic[@"method"]);
    if ([self respondsToSelector:method]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:method];
#pragma clang diagnostic pop
    }
}

#pragma mark - event
- (void)launchTime{
    JZTLaunchTimeVC *nextVC = [[JZTLaunchTimeVC alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)requestApi{
    JZTAPiListVC *nextVC = [[JZTAPiListVC alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)crashHistory{
    JZTExceptionListVC *nextVC = [[JZTExceptionListVC alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)changeWebServers{
    
}

- (void)vcloadTime{
    JZTVCLoadTimeVC *nextVC = [JZTVCLoadTimeVC new];
    [self.navigationController pushViewController:nextVC animated:YES];
}
#pragma mark - dataSource
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[
                        @{
                            @"title" : @"启动时间",
                            @"method": @"launchTime",
                            },
                        @{
                            @"title" : @"请求接口",
                            @"method": @"requestApi",
                            },
                        @{
                            @"title" : @"崩溃历史",
                            @"method": @"crashHistory",
                            },
                        @{
                            @"title" : @"测试切服",
                            @"method" : @"changeWebServers"
                            },
                        @{
                            @"title" : @"控制器加载列表",
                            @"method": @"vcloadTime",
                            },
                        ];
    }
    return _dataSource;
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
