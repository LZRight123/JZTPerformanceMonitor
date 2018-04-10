//
//  JZTAPiDeatilCell.m
//  hyb
//
//  Created by 梁泽 on 2017/9/8.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTAPiDeatilCell.h"
#import "JZTRequestModel.h"
#import "JZTMenuLabel.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTAPiDeatilCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *networkStatusLabel;
@property (nonatomic, strong) UILabel *HTTPMethodLabel;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UILabel *requestParametersLabel;
@property (nonatomic, strong) UILabel *responseStringLabel;

@property (nonatomic, strong) UIButton *historyRequestBtn;
@end
#define kStatusViewW 10
@implementation JZTAPiDeatilCell

+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"JZTAPiDeatilCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[self class] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupUI];
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

//    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [self addGestureRecognizer:longPressGestureRecognizer];
    
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.urlLabel];
    [self.contentView addSubview:self.HTTPMethodLabel];
    [self.contentView addSubview:self.networkStatusLabel];
    [self.contentView addSubview:self.historyRequestBtn];
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.startLabel];
    [self.contentView addSubview:self.endLabel];
    [self.contentView addSubview:self.requestParametersLabel];
    [self.contentView addSubview:self.responseStringLabel];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImg.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(0);
    }];
    
    
    [self.HTTPMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLabel);
        make.top.equalTo(self.urlLabel.mas_bottom).offset(3);
    }];
    
    [self.historyRequestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HTTPMethodLabel.mas_right).offset(8);
        make.centerY.equalTo(self.HTTPMethodLabel);
    }];
    
    [self.networkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLabel);
        make.top.equalTo(self.HTTPMethodLabel.mas_bottom).offset(3);
    }];
    
    
    
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLabel);
        make.top.mas_equalTo(self.networkStatusLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(kStatusViewW, kStatusViewW));
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.left.equalTo(self.statusView.mas_right).offset(3);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.left.equalTo(self.durationLabel.mas_right).offset(6);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.left.equalTo(self.sizeLabel.mas_right).offset(6);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLabel);
        make.top.equalTo(self.statusView.mas_bottom).offset(8);
    }];
    
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLabel);
        make.top.equalTo(self.startLabel.mas_bottom).offset(1);
    }];
    
//    [self.requestParametersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(self.endLabel.mas_bottom).offset(1);
//        make.left.equalTo(self.contentView).offset(8);
//        make.height.mas_equalTo(0);
//    }];
    
    [self.responseStringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.endLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - setter
- (void)setModel:(JZTRequestModel *)model{
    _model = model;
    
    if ([model isImgSource]) {
        [self.iconImg setImageWithURL:[NSURL URLWithString:model.URLString] placeholder:[UIImage imageNamed:@"common_placeholder"]];
//        [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//            make.top.equalTo(self.iconImg.mas_bottom).offset(5);
//            make.left.equalTo(self.contentView).offset(8);
//        }];
    }else{
//        [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//            make.top.equalTo(self.contentView).offset(5);
//            make.left.equalTo(self.contentView).offset(8);
//        }];
    }
    
    self.networkStatusLabel.text = [NSString stringWithFormat:@"网络状态:%@",[model networkStatusString]];
    self.HTTPMethodLabel.text = [NSString stringWithFormat:@"HTTPMethod:%@",[model.request HTTPMethod]];
    
    NSInteger statusCode = model.statusCode;
    if (statusCode == 200) {
        if (model.duration > 10) {
            self.statusView.backgroundColor = [UIColor yellowColor];
        }else{
            self.statusView.backgroundColor = [UIColor greenColor];
        }
        self.statusLabel.text = @"success";
    }else if (statusCode == NSURLErrorCancelled){
        self.statusView.backgroundColor = [UIColor grayColor];
        self.statusLabel.text = @"Cancelled";
    }else {
        self.statusView.backgroundColor = [UIColor redColor];
        if (statusCode == NSURLErrorTimedOut) {
            self.statusLabel.text = @"TimedOut";
        }else {
            self.statusLabel.text = [NSString stringWithFormat:@"statusCode:%ld",statusCode];
        }
    }
    
    self.durationLabel.text = [NSString stringWithFormat:@"duration:%.4fs",[model duration]];
    self.sizeLabel.text = model.contentSize;
    self.startLabel.text = [NSString stringWithFormat:@"开始时间:%@",[model startTime]];
    self.endLabel.text = [NSString stringWithFormat:@"响应时间:%@",[model endTime]];
    
    if ([model isImgSource]) {
//        self.requestParametersLabel.text = nil;
//        self.responseStringLabel.text = nil;
//        self.urlLabel.text = model.URLString;
    }else{
//        self.requestParametersLabel.text = [NSString stringWithFormat:@"请求入参:\n%@",[model requestParametersString]];
//        if ([model requestParametersString].length) {
//            self.urlLabel.text = [NSString stringWithFormat:@"%@?%@",model.URLString,[model requestParametersString]];
//        }
//        self.responseStringLabel.text = [NSString stringWithFormat:@"响应数据:\n%@",[model responseString]];
    }
}
#pragma mark - event
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
       
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *copyURL = [[UIMenuItem alloc] initWithTitle:@"copy URL" action:@selector(copyURLAction:)];
        UIMenuItem *share = [[UIMenuItem alloc] initWithTitle:@"share" action:@selector(shareAction:)];
        UIMenuItem *copyResponse = [[UIMenuItem alloc] initWithTitle:@"copy response" action:@selector(copyResponseAction:)];
 
        //设定菜单显示的区域，显示再Rect的最上面居中
        [menu setTargetRect:self.frame inView:self.contentView];
        [menu setMenuItems:@[copyURL,share, copyResponse]];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)copyURLAction:(UIMenuController *)sender{
    [UIPasteboard generalPasteboard].string = self.urlLabel.text;
}

- (void)shareAction:(UIMenuController *)sender{
    if ([self.delegate respondsToSelector:@selector(JZTAPiDeatilCell:shareURL:response:)]) {
        [self.delegate JZTAPiDeatilCell:self shareURL:self.urlLabel.text response:self.model.responseString];
    }
}

- (void)copyResponseAction:(UIMenuController *)sender{
    [UIPasteboard generalPasteboard].string = self.model.responseString;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copyURLAction:) || action == @selector(shareAction:) || action == @selector(copyResponseAction:));
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)clickHistoryRequestBtn{
    if ([self.delegate respondsToSelector:@selector(JZTAPiDeatilCellDidClickRequestHistory:)]) {
        [self.delegate JZTAPiDeatilCellDidClickRequestHistory:self];
    }
}

#pragma mark - getter @property
- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
    }
    return _iconImg;
}

- (UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[JZTMenuLabel alloc]init];
        _urlLabel.font = [UIFont systemFontOfSize:13.7];
        _urlLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _urlLabel.numberOfLines = 0;
    }
    return _urlLabel;
}

- (UILabel *)networkStatusLabel{
    if (!_networkStatusLabel) {
        _networkStatusLabel = [[UILabel alloc]init];
        _networkStatusLabel.font = [UIFont systemFontOfSize:13];
        _networkStatusLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _networkStatusLabel;
}

- (UILabel *)HTTPMethodLabel{
    if (!_HTTPMethodLabel) {
        _HTTPMethodLabel = [[UILabel alloc]init];
        _HTTPMethodLabel.font = [UIFont systemFontOfSize:13];
        _HTTPMethodLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _HTTPMethodLabel;
}

- (UIView *)statusView{
    if (!_statusView) {
        _statusView = [[UIView alloc]init];
        _statusView.layer.cornerRadius = kStatusViewW/2.;
        _statusView.layer.masksToBounds = YES;
    }
    return _statusView;
}

- (UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]init];
        _durationLabel.font = [UIFont systemFontOfSize:13];
        _durationLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _durationLabel;
}

- (UILabel *)sizeLabel{
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc]init];
        _sizeLabel.font = [UIFont systemFontOfSize:13];
        _sizeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _sizeLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _statusLabel;
}

- (UILabel *)startLabel{
    if (!_startLabel) {
        _startLabel = [[UILabel alloc]init];
        _startLabel.font = [UIFont systemFontOfSize:13];
        _startLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _startLabel;
}

- (UILabel *)endLabel{
    if (!_endLabel) {
        _endLabel = [[UILabel alloc]init];
        _endLabel.font = [UIFont systemFontOfSize:13];
        _endLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _endLabel;
}

- (UILabel *)requestParametersLabel{
    if (!_requestParametersLabel) {
        _requestParametersLabel = [[UILabel alloc]init];
        _requestParametersLabel.numberOfLines = 0;
        _requestParametersLabel.font = [UIFont systemFontOfSize:13];

        _requestParametersLabel.textColor = [UIColor colorWithHexString:@"999999"];    }
    return _requestParametersLabel;
}

- (UILabel *)responseStringLabel{
    if (!_responseStringLabel) {
        _responseStringLabel = [[JZTMenuLabel alloc]init];
        _responseStringLabel.numberOfLines = 0;
        _responseStringLabel.font = [UIFont systemFontOfSize:13];
        _responseStringLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _responseStringLabel;
}

- (UIButton *)historyRequestBtn{
    if (!_historyRequestBtn) {
        _historyRequestBtn = [[UIButton alloc]init];
        _historyRequestBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _historyRequestBtn.layer.cornerRadius = 2;
        _historyRequestBtn.layer.borderWidth = .5;
        _historyRequestBtn.layer.borderColor = [UIColor colorWithHexString:@"777777"].CGColor;
        [_historyRequestBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [_historyRequestBtn setTitle:@"  history  " forState:UIControlStateNormal];
        [_historyRequestBtn addTarget:self action:@selector(clickHistoryRequestBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyRequestBtn;
}
@end
