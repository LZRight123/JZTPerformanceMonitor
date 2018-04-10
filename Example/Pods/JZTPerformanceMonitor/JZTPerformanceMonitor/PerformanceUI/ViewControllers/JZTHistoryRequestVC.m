//
//  JZTHistoryRequestVC.m
//  hyb
//
//  Created by 梁泽 on 2017/11/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTHistoryRequestVC.h"
#import "JZTRequestModel.h"

#import "JZTNavTitleView.h"
#import "JZTLineChartView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTHistoryRequestVC ()<JZTLineChartViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<JZTRequestModel *> *requestList;
@end

@implementation JZTHistoryRequestVC
- (instancetype)initWithList:(NSArray *)list{
    if (self = [super init]) {
        _requestList = list;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[JZTNavTitleView alloc]initWithTitle:@"history request time"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    NSArray<JZTRequestModel *> *tempArr = [self.requestList sortedArrayUsingComparator:^NSComparisonResult(JZTRequestModel *obj1, JZTRequestModel *obj2) {
        return obj1.duration > obj2.duration;
    }];
    CGFloat result = 0;
    for (JZTRequestModel *obj in tempArr) {
        result += obj.duration;
    }
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.scrollView.mas_top);
    }];
    label.text = [NSString stringWithFormat:@"max:%.2f  min:%.2f  average:%.2f", tempArr.lastObject.duration, tempArr.firstObject.duration, result/tempArr.count];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat chartWidth = 20 * 2 + (self.requestList.count + 1) * 50;
        JZTLineChartView *chartView = [[JZTLineChartView alloc]initWithFrame:CGRectMake(10, 10,chartWidth-20, CGRectGetHeight(self.scrollView.frame) - 10)];
        chartView.dataSource = self;
        chartView.delegate = self;
        chartView.hasHGrid = NO;
        [self.scrollView addSubview:chartView];
        self.scrollView.contentSize = CGSizeMake(chartWidth, self.view.bounds.size.height-100);
        [chartView reloadData];
    });
}


- (UIColor *)randomColor{
    CGFloat r = (arc4random() % 255 / 255.0 );
    CGFloat g = (arc4random() % 128 / 255.0 );
    CGFloat b = (arc4random() % 128 / 255.0 );
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (NSInteger)numberOfDotsInLineChar:(JZTLineChartView*)lineChartView{
    return self.requestList.count;
}
- (CGFloat)lineChart:(JZTLineChartView*)lineChartView valueForLineChartAtIndex:(NSInteger)index{
    return [self.requestList[index] duration];
}
- (NSString *)lineChart:(JZTLineChartView*)lineChartView xLabelForLineChartAtIndex:(NSInteger)index{
    return [[self.requestList[index] startDate] stringWithFormat:@"hh:mm:ss"];
}
- (NSString*)lineChart:(JZTLineChartView*)lineChartView lineTextForLineChartAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%.2f",[self.requestList[index] duration]];
}
- (UIColor *)lineChart:(JZTLineChartView*)lineChartView colorForLineChartDotAtIndex:(NSInteger)index{
    UIColor *color = [self randomColor];
    
    JZTRequestModel *model = self.requestList[index];
    NSInteger statusCode = model.statusCode;
    if (statusCode == 200) {
        if (model.duration > 10) {
            color = [UIColor yellowColor];
        }else{
            color = [UIColor greenColor];
        }
    }else if (statusCode == NSURLErrorCancelled){
        color = [UIColor grayColor];
    }else {
        color = [UIColor redColor];
    }
    return color;
}
- (UIColor *)lineChartColorForLine:(JZTLineChartView*)lineChartView{
    return [self randomColor];
}
- (BOOL)lineChartShouldDot:(JZTLineChartView*)lineChartView{
    return YES;
}

@end
