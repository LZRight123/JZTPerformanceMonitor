//
//  JZTAPiCell.m
//  hyb
//
//  Created by 梁泽 on 2017/9/8.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTAPiCell.h"
#import "JZTRequestModel.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface JZTAPiCell()
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, strong) UIView *bottomLineView;
@end

#define kStatusViewW 10.
@implementation JZTAPiCell

+ (__kindof UITableViewCell *)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"JZTAPiCell";
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
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.urlLabel];
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.sizeLabel];
    
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg);
        make.left.equalTo(self.iconImg.mas_right).offset(3);
        make.right.equalTo(self.contentView).offset(-4);
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right);
        make.top.mas_equalTo(self.urlLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(kStatusViewW, kStatusViewW));
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.left.equalTo(self.statusView.mas_right).offset(3);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView);
        make.left.equalTo(self.durationLabel.mas_right).offset(6);
    }];
    
}

#pragma mark - setter
- (void)setModel:(JZTRequestModel *)model{
    _model = model;
    
    if ([model isImgSource]) {
        [self.iconImg setImageWithURL:[NSURL URLWithString:model.URLString] placeholder:[UIImage imageNamed:@"common_placeholder"]];
        [self.iconImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
        }];
    }else{
        [self.iconImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    
    
    
    self.urlLabel.text = model.URLString;

    NSInteger statusCode = model.statusCode;
    if (statusCode == 200) {
        if (model.duration > 10) {
            self.statusView.backgroundColor = [UIColor yellowColor];
        }else{
            self.statusView.backgroundColor = [UIColor greenColor];
        }
    }else if (statusCode == NSURLErrorCancelled){
        self.statusView.backgroundColor = [UIColor grayColor];
    }else {
        self.statusView.backgroundColor = [UIColor redColor];
    }
    
    self.durationLabel.text = [NSString stringWithFormat:@"duration:%.4fs",[model duration]];
    self.sizeLabel.text = model.contentSize;
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
        _urlLabel = [[UILabel alloc]init];
        _urlLabel.font = [UIFont systemFontOfSize:13];
        _urlLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _urlLabel.numberOfLines = 2;
    }
    return _urlLabel;
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

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _bottomLineView;
}
@end
