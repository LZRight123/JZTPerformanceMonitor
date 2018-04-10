//
//  JZTAPiListVC.m
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#import "JZTAllImageRequestVC.h"
#import "JZTRecordRequestList.h"
#import "JZTAPiCell.h"
#import "JZTApiDetailVC.h"
#import "JZTNavTitleView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTAllImageRequestVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JZTRequestModel *> *apiList;
@end

@implementation JZTAllImageRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"all image list"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"look big image list" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLookBigImage) forControlEvents:UIControlEventTouchUpInside];
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
            NSArray *allApi = [JZTRecordRequestList defaultInstance].apiList;
            NSMutableArray *tempArr = [NSMutableArray array];
            for (JZTRequestModel *obj in allApi) {
                if ([obj isImgSource]) {
                    [tempArr addObject:obj];
                }
            }
            NSArray *extractedExpr = [tempArr sortedArrayUsingComparator:^NSComparisonResult(JZTRequestModel *obj1, JZTRequestModel *obj2) {
                return obj1.mutableData.length < obj2.mutableData.length;
            }];
            self.apiList = extractedExpr;
            
            [self.tableView reloadData];
        });
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)clickLookBigImage{
    NSMutableArray *tempArr = [NSMutableArray array];

    for (JZTRequestModel *obj in self.apiList) {
        if ((obj.mutableData.length / 1024.) >= 100) {
            [tempArr addObject:[NSString stringWithFormat:@"%@  %@", obj.URLString, obj.contentSize]];
        }
    }
    NSArray *arr = [tempArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSArray *arr2 = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString *obj2) {
        
        double size1 = [[[obj1 componentsSeparatedByString:@"size:"].lastObject  componentsSeparatedByString:@"k"].firstObject doubleValue];
        double size2 = [[[obj2 componentsSeparatedByString:@"size:"].lastObject  componentsSeparatedByString:@"k"].firstObject doubleValue];
        
        return size1 < size2;
    }];
    NSLog(@"%@",arr2);
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

