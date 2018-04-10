//
//  JZTLaunchTimeVC.m
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTLaunchTimeVC.h"
#import "JZTNavTitleView.h"
#import "JZTMenuCell.h"
#import "JZTLaunchTimeManager.h"
#import <Masonry/Masonry.h>
@interface JZTLaunchTimeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JZTLaunchTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"Launch time"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZTMenuCell *cell = [JZTMenuCell cellWithTableView:tableView];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [JZTLaunchTimeManager manager].description;
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
