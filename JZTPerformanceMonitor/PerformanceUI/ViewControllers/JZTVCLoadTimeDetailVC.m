//
//  JZTVCLoadTimeDetailVC.m
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTVCLoadTimeDetailVC.h"
#import "JZTVCLoadTimeModel.h"
#import "JZTMenuCell.h"
#import "JZTNavTitleView.h"
#import "JZTHookViewDisplayTimeManager.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTVCLoadTimeDetailVC ()<UITableViewDataSource,UITableViewDelegate,JZTHookViewDisplayTimeManagerDelegate>
@property (nonatomic, strong) JZTVCLoadTimeModel *model;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JZTVCLoadTimeDetailVC
- (instancetype)initWithModel:(JZTVCLoadTimeModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [JZTHookViewDisplayTimeManager manager].delegate = self;
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"vc loadTime list"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - <JZTHookViewDisplayTimeManagerDelegate>
- (void)JZTHookViewDisplayTimeManagerDidResfresh:(id)manager{
    [self.tableView reloadData];
}
#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTMenuCell *cell = [JZTMenuCell cellWithTableView:tableView];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.model.description;
    return cell;
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
