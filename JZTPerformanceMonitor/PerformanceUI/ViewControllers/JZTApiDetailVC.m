//
//  JZTApiDetailVC.m
//  hyb
//
//  Created by 梁泽 on 2017/9/8.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTApiDetailVC.h"
#import "JZTAPiDeatilCell.h"
#import "JZTNavTitleView.h"
#import "JZTRecordRequestList.h"
#import "JZTHistoryRequestVC.h"
#import "JZTMenuCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTApiDetailVC ()<UITableViewDataSource,UITableViewDelegate,JZTAPiDeatilCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation JZTApiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.canLoad = YES;
    [self.tableView reloadData];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"API detail"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.canLoad?3:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        JZTAPiDeatilCell *cell = [JZTAPiDeatilCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = self.model;
        [self.hud hide:YES afterDelay:0.5];
        return cell;
    }
    JZTMenuCell *mecell = [JZTMenuCell cellWithTableView:tableView];
    mecell.textLabel.numberOfLines = 0;
    mecell.textLabel.font = [UIFont systemFontOfSize:13];
    mecell.textLabel.textColor = [UIColor colorWithHexString:@"999999"];
    
    if (indexPath.row == 0) {
        mecell.textLabel.text = self.model.URLString;
        if ([self.model requestParametersString].length) {
            mecell.textLabel.text = [NSString stringWithFormat:@"%@?%@",self.model.URLString,[self.model requestParametersString]];
        }
    }else{
        mecell.textLabel.text = [NSString stringWithFormat:@"响应数据:\n%@",[self.model responseString]];
    }
    
    return mecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JZTAPiDeatilCellDelegate
- (void)JZTAPiDeatilCellDidClickRequestHistory:(JZTAPiDeatilCell *)cell{
    
    NSArray *list = [[JZTRecordRequestList defaultInstance].apiList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"URLString == %@",self.model.URLString]];
    NSLog(@"%@",list);
    JZTHistoryRequestVC *nextVC = [[JZTHistoryRequestVC alloc]initWithList:list];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - getter @property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
@end
