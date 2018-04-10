//
//  JZTLineChartView.m
//  图形图像集合
//
//  Created by 梁泽 on 16/5/11.
//  Copyright © 2016年 right. All rights reserved.
//

#import "JZTLineChartView.h"
@interface JZTLineChartView()
@property (nonatomic,strong) CALayer *borderLayer;
@property (nonatomic,strong) CAShapeLayer *borderPathLayer;

@property (nonatomic,strong) CALayer *gridLayer;
@property (nonatomic,strong) CAShapeLayer *hGridPathLayer;
@property (nonatomic,strong) CAShapeLayer *vGridPathLayer;
@property (nonatomic,strong) CALayer *contentLayer;
@property (nonatomic,strong) CAShapeLayer *linePathLayer;
@property (nonatomic,strong) NSMutableArray *dotPathLayers;

@property (nonatomic,strong) UIView *yLabelsView;
@property (nonatomic,strong) UIView *xLabelsView;
@property (nonatomic,strong) UIView *lineTextView;
@property (nonatomic,assign) CGFloat xLabelMaxHeight;


@property (nonatomic,assign) NSInteger numberOfDots;
@property (nonatomic,assign) CGFloat topValue;

@property (nonatomic,strong) NSMutableArray *values;
@property (nonatomic,strong) NSMutableArray *xLabels;
@property (nonatomic,strong) NSMutableArray *lineTexts;
@end

@implementation JZTLineChartView
#define kFont [UIFont fontWithName:@"Helvetica" size:13.]
#define kLineTextFont [UIFont fontWithName:@"Helvetica" size:11.]

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit{
    _animationDuration = 1.;
    _incrementValue    = 1;
    
    _chartBorderColor = [UIColor blackColor];
    _borderLayer      = [CALayer layer];
    [self.layer addSublayer:_borderLayer];
    
    _hasHGrid   = YES;
    _hGridColor = [UIColor grayColor];
    _hasVGrid   = YES;
    _vGridColor = [UIColor blackColor];
    _gridLayer  = [CALayer layer];
    [self.layer addSublayer:_gridLayer];
    
    _contentLayer  = [CALayer layer];
    _values        = [NSMutableArray array];
    _dotPathLayers = [NSMutableArray array];
    _lineWidth     = 1.;
    _dotRadius     = 3;
    [self.layer addSublayer:_contentLayer];

    _hasYLabels  = YES;
    _yLabelsView = [[UIView alloc]init];
    _yLabelColor = [UIColor grayColor];
    _yLabelFont  = kFont;
    [self addSubview:_yLabelsView];
    
    _xLabels     = [NSMutableArray array];
    _xLabelFont  = kFont;
    _xLabelColor = [UIColor grayColor];
    _xLabelsView = [[UIView alloc]init];
    [self addSubview:_xLabelsView];

    _lineTexts = [NSMutableArray array];
    _lineTextFont = kLineTextFont;
    _lineTextView = [[UIView alloc]init];
    _lineTextColor = [UIColor lightGrayColor];
    [self addSubview:_lineTextView];
}

- (void) reloadData{
    if (_dataSource) {
        _numberOfDots = [self.dataSource numberOfDotsInLineChar:self];
        
        [_values removeAllObjects];
        [_xLabels removeAllObjects];
        [_lineTexts removeAllObjects];
        
        for (int i =0 ; i < _numberOfDots ; i++) {
            CGFloat value = [self.dataSource lineChart:self valueForLineChartAtIndex:i];
            [_values addObject:@(value)];
            if ([self.dataSource respondsToSelector:@selector(lineChart:xLabelForLineChartAtIndex:)]) {
                NSString *xLabel = [self.dataSource lineChart:self xLabelForLineChartAtIndex:i];
                [_xLabels addObject:xLabel];
            }
            if ([self.dataSource respondsToSelector:@selector(lineChart:lineTextForLineChartAtIndex:)]) {
                NSString *lineText = [self.dataSource lineChart:self lineTextForLineChartAtIndex:i];
                [_lineTexts addObject:lineText];
            }
        }
        
        NSInteger maxValue = [[_values valueForKeyPath:@"@max.self"] integerValue];
        _topValue = (_incrementValue - maxValue%_incrementValue) + maxValue;
        
        for (NSString *str in _xLabels) {
            NSDictionary *dic = @{
                                  NSFontAttributeName : _xLabelFont
                                  };
            CGSize size = [str sizeWithAttributes:dic];
            _xLabelMaxHeight = MAX(_xLabelMaxHeight,size.height);
        }
        
        //设置XY标签
        NSDictionary *dic = @{
                              NSFontAttributeName : _yLabelFont
                              };
        CGSize yLableSize = _hasYLabels?[@(_topValue).stringValue sizeWithAttributes:dic] : CGSizeZero;
        _yLabelsView.frame = CGRectMake(0, 0, _hasYLabels?(yLableSize.width + 5):0.0, CGRectGetHeight(self.frame));
        _xLabelsView.frame = CGRectMake(CGRectGetMaxX(_yLabelsView.frame) , CGRectGetHeight(self.frame) - _xLabelMaxHeight ,CGRectGetWidth(self.frame) -  CGRectGetMaxX(_yLabelsView.frame) ,_xLabelMaxHeight);
        
        //设置图层框架
        _borderLayer.frame = CGRectMake(CGRectGetWidth(_yLabelsView.frame), 0, CGRectGetWidth(self.frame)-CGRectGetWidth(_yLabelsView.frame), CGRectGetHeight(self.frame)- (_xLabelMaxHeight > 0 ?(_xLabelMaxHeight+5):0));
        _gridLayer.frame = _borderLayer.frame;
        _contentLayer.frame = _borderLayer.frame;
        _lineTextView.frame = _borderLayer.frame;
        
        [self setupBorder];
        [self drawBorder];
        [self setupLines];
        [self drawLines];
        [self setupDots];
        [self animationDotsAtIndex:0];
        
        [self removeGrids];
        if (self.hasHGrid) {
            [self setupHGrid];
            [self drawHGrid];
        }
        if (self.hasVGrid) {
            [self setupVGrid];
            [self drawVGrid];
        }
        [self setupYLabels];
        [self setupXLabels];
        [self setupLineTexts];
    }
}
#pragma mark - border
- (void) setupBorder{
    if (_borderPathLayer) {
        [_borderPathLayer removeFromSuperlayer];
        _borderPathLayer = nil;
    }
    
    CGPoint bottomLeft  = CGPointMake(CGRectGetMinX(_borderLayer.bounds), CGRectGetMinY(_borderLayer.bounds));
    CGPoint bottomRight = CGPointMake(CGRectGetMaxX(_borderLayer.bounds), CGRectGetMinY(_borderLayer.bounds));
    CGPoint topLeft     = CGPointMake(CGRectGetMinX(_borderLayer.bounds), CGRectGetMaxY(_borderLayer.bounds));
    CGPoint topRight    = CGPointMake(CGRectGetMaxX(_borderLayer.bounds), CGRectGetMaxY(_borderLayer.bounds));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    
    _borderPathLayer = [CAShapeLayer layer];
    _borderPathLayer.frame = _borderLayer.bounds;
    _borderPathLayer.strokeColor = _chartBorderColor.CGColor;
    _borderPathLayer.fillColor = nil;
    _borderPathLayer.lineWidth = 1.;
    _borderPathLayer.lineJoin = kCALineJoinBevel;
    _borderPathLayer.geometryFlipped = YES;
    _borderPathLayer.path = path.CGPath;
    [_borderLayer addSublayer:_borderPathLayer];
}
#pragma mark - grid
- (void) removeGrids{
    if (_hGridPathLayer) {
        [_hGridPathLayer removeFromSuperlayer];
        _hGridPathLayer = nil;
    }
    if (_vGridPathLayer) {
        [_vGridPathLayer removeFromSuperlayer];
        _vGridPathLayer = nil;
    }
}
- (void) setupHGrid{
    CGFloat gridUnit = _gridLayer.bounds.size.height / _topValue;// 网格单元
    CGFloat gridSeperation = gridUnit * (CGFloat)_incrementValue;//单元高度
    CGFloat yPos = gridSeperation;
    UIBezierPath *path = [UIBezierPath bezierPath];
    while (yPos + gridSeperation <= _gridLayer.bounds.size.height) {
        CGPoint left = CGPointMake(0, yPos);
        CGPoint right = CGPointMake(CGRectGetWidth(_gridLayer.frame), yPos);
        yPos += gridSeperation;
        [path moveToPoint:left];
        [path addLineToPoint:right];
    }
    
    _hGridPathLayer                 = [CAShapeLayer layer];
    _hGridPathLayer.frame           = _gridLayer.bounds;
    _hGridPathLayer.path            = path.CGPath;
    _hGridPathLayer.strokeColor     = _hGridColor.CGColor;
    _hGridPathLayer.fillColor       = nil;
    _hGridPathLayer.lineWidth       = 1;
    _hGridPathLayer.lineJoin        = kCALineJoinBevel;
    _hGridPathLayer.geometryFlipped = YES;
    [_gridLayer addSublayer:_hGridPathLayer];
}
- (void) setupVGrid{
    CGFloat xPos = CGRectGetWidth(_gridLayer.bounds)/(_numberOfDots - 1);
    UIBezierPath *path = [UIBezierPath bezierPath];
    while (xPos < _gridLayer.bounds.size.width) {
        CGPoint top = CGPointMake(xPos, CGRectGetHeight(_gridLayer.frame));
        CGPoint bottom = CGPointMake(xPos, 0);
        xPos += CGRectGetWidth(_gridLayer.bounds)/(_numberOfDots - 1);
        [path moveToPoint:top];
        [path addLineToPoint:bottom];
    }
    
    _vGridPathLayer                 = [CAShapeLayer layer];
    _vGridPathLayer.frame           = _gridLayer.bounds;
    _vGridPathLayer.path            = path.CGPath;
    _vGridPathLayer.strokeColor     = _hGridColor.CGColor;
    _vGridPathLayer.fillColor       = nil;
    _vGridPathLayer.lineWidth       = 1;
    _vGridPathLayer.lineJoin        = kCALineJoinBevel;
    _vGridPathLayer.geometryFlipped = YES;
    [_gridLayer addSublayer:_vGridPathLayer];
}

#pragma mark - lineAndDots
- (void) setupLines{
    if (_linePathLayer) {
        [_linePathLayer removeFromSuperlayer];
        _linePathLayer = nil;
    }
    
    // value的X轴心
    CGFloat xPos = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (int i = 0; i < _numberOfDots; i++) {
        CGFloat yPos = ([_values[i] floatValue]/_topValue)*CGRectGetHeight(_borderLayer.bounds);
        if (i == 0) {
            [path moveToPoint:CGPointMake(xPos, yPos)];
        }else{
            [path addLineToPoint:CGPointMake(xPos, yPos)];
        }
        xPos += CGRectGetWidth(_borderLayer.bounds)/(_numberOfDots - 1);
    }
    UIColor *color = [UIColor greenColor];
    if ([self.dataSource respondsToSelector:@selector(lineChartColorForLine:)]) {
        color = [self.dataSource lineChartColorForLine:self];
    }
    
    _linePathLayer                 = [CAShapeLayer layer];
    _linePathLayer.path            = path.CGPath;
    _linePathLayer.strokeColor     = color.CGColor;
    _linePathLayer.fillColor       = nil;
    _linePathLayer.frame           = _borderLayer.bounds;
    _linePathLayer.lineWidth       = _lineWidth;
    _linePathLayer.lineJoin        = kCALineJoinRound;
    _linePathLayer.geometryFlipped = YES;
    [_contentLayer addSublayer:_linePathLayer];
    
}
- (void) setupDots{
    for (CAShapeLayer *layer in _dotPathLayers) {
        if (layer) {
            [layer removeFromSuperlayer];
        }
    }
    [_dotPathLayers removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(lineChartShouldDot:)]) {
        if (![self.dataSource lineChartShouldDot:self]) {
            return;
        }
    }
    // value的X轴心
    CGFloat xPos = 0;
    for (int i = 0; i < _numberOfDots; i++) {
        CGFloat yPos = ([_values[i] floatValue]/_topValue)*CGRectGetHeight(_borderLayer.bounds);
        
  
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(xPos, yPos) radius:_dotRadius startAngle:0 endAngle:M_PI*2 clockwise:1];
        UIColor *color = [UIColor greenColor];
        if ([self.dataSource respondsToSelector:@selector(lineChart:colorForLineChartDotAtIndex:)]) {
            color = [self.dataSource lineChart:self colorForLineChartDotAtIndex:i];
        }
        
        CAShapeLayer *layer   = [CAShapeLayer layer];
        layer                 = [CAShapeLayer layer];
        layer.path            = path.CGPath;
        layer.strokeColor     = nil;
        layer.fillColor       = color.CGColor;
        layer.frame           = _borderLayer.bounds;
        layer.lineWidth       = 1;
        layer.lineJoin        = kCALineJoinRound;
        layer.geometryFlipped = YES;
        layer.hidden          = YES;
        [_contentLayer addSublayer:layer];
        [_dotPathLayers addObject:layer];
        
        xPos += CGRectGetWidth(_borderLayer.bounds)/(_numberOfDots - 1);
    }
}
#pragma mark - YLabels
- (void) setupYLabels{
    [_yLabelsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!self.hasYLabels) {
        return;
    }
    if (_yLabelsView.alpha > 0) {
        _yLabelsView.alpha = 0.0;
    }
    
    CGFloat gridUnit = CGRectGetHeight(_gridLayer.bounds)/_topValue;// 网格单元
    CGFloat gridSeperation = gridUnit * (CGFloat)_incrementValue;//单元高度
    NSDictionary *dic = @{
                          NSFontAttributeName : _yLabelFont
                          };
    CGSize size = [@(_topValue).stringValue sizeWithAttributes:dic];
    CGFloat yPos = 0.;
    NSInteger maxVal = _topValue;
    while (yPos < CGRectGetHeight(_gridLayer.bounds)) {
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.font = _yLabelFont;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = _yLabelColor;
        label.textAlignment  = NSTextAlignmentRight;
        label.text = @(maxVal).stringValue;
        label.center = CGPointMake(label.center.x, yPos);
        [_yLabelsView addSubview:label];
        
        maxVal -= _incrementValue;
        yPos += gridSeperation;
    }

}
#pragma mark - XLabels
- (void) setupXLabels{
    [_xLabelsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!_xLabels.count) {
        return;
    }
    
    if (_xLabelsView.alpha > 0) {
        _xLabelsView.alpha = 0.;
    }
    
    NSDictionary *dic = @{
                          NSFontAttributeName : _xLabelFont
                          };
    CGFloat xPos = 0;
    for (int i = 0; i < _numberOfDots; i++) {
        NSString *text = _xLabels[i];
        CGSize size           = [text sizeWithAttributes:dic];
        UILabel *label        = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        label.font            = _xLabelFont;
        label.backgroundColor = [UIColor clearColor];
        label.textColor       = _xLabelColor;
        label.textAlignment   = NSTextAlignmentCenter;
        label.center          = CGPointMake(xPos, label.center.y);
        label.text            = text;
//        label.transform = CGAffineTransformMakeRotation(degreesToRadians(-_xLabelRotaion));
//        switch (_xLabelType) {
//            case JZTBarXLabelTypeVerticle:
//                label.center = CGPointMake(xPos, size.width/2);
//                break;
//            case JZTBarXLabelTypeHorizontal:
//                label.center = CGPointMake(xPos, size.height/2);
//                break;
//            case JZTBarXLabelTypeAngled:{
//                CGFloat heightWithAngle = sin(degreesToRadians(_xLabelRotaion))*size.width;
//                label.center = CGPointMake(xPos - heightWithAngle/2 , heightWithAngle/2);
//            }
//                break;
//        }
        
        [_xLabelsView addSubview:label];
        xPos += CGRectGetWidth(_borderLayer.bounds)/(_numberOfDots - 1);
    }


}
#pragma mark - LineTexts
- (void) setupLineTexts{
    [_lineTextView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_lineTexts.count) {
        return;
    }
    if (_lineTextView.alpha > 0) {
        _lineTextView.alpha = 0;
    }
    
    // value的X轴心
    CGFloat xPos = 0;
    for (int i = 0; i < _numberOfDots; i++) {
        CGFloat yPos = CGRectGetHeight(_borderLayer.bounds) - ([_values[i] floatValue]/_topValue)*CGRectGetHeight(_borderLayer.bounds);
        NSDictionary *dic = @{
                              NSFontAttributeName : _lineTextFont
                              };
        NSString *text = _lineTexts[i];
        CGSize size = [text sizeWithAttributes:dic];
        UILabel *label        = [[UILabel alloc]initWithFrame:CGRectMake(xPos, yPos, size.width, size.height)];
        label.font            = _lineTextFont;
        label.textColor       = _lineTextColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment   = NSTextAlignmentCenter;
        label.text            = text;
        [_lineTextView addSubview:label];
        
        CGRect frame = label.frame;
        if (CGRectGetMaxX(frame) > CGRectGetWidth(_borderLayer.frame)) {
            frame.origin.x -= CGRectGetWidth(label.frame);
            label.frame = frame;
        }
        
        
        xPos += CGRectGetWidth(_borderLayer.bounds)/(_numberOfDots - 1);
    }

}
#pragma mark - 动画
- (void) drawBorder{
    if (_animationDuration == 0) {
        return;
    }
    [_borderPathLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _animationDuration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_borderPathLayer addAnimation:animation forKey:nil];
}
- (void) drawLines{
    if (_animationDuration == 0) {
        return;
    }
    [_linePathLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _animationDuration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_linePathLayer addAnimation:animation forKey:nil];
}
- (void) drawHGrid{
    if (_animationDuration == 0) {
        return;
    }
    [_hGridPathLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _animationDuration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_hGridPathLayer addAnimation:animation forKey:nil];
}
- (void) drawVGrid{
    if (_animationDuration == 0) {
        return;
    }
    [_vGridPathLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _animationDuration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_vGridPathLayer addAnimation:animation forKey:nil];
}
- (void) animationDotsAtIndex:(NSInteger)index{
    if (index >= _dotPathLayers.count) {
        [self drawAllLabels];
        return ;
    }
    [CATransaction begin];
    __weak typeof(self) weakSelf = self;
    [CATransaction setAnimationDuration:_animationDuration/_numberOfDots];
    [CATransaction setCompletionBlock:^{
        [weakSelf animationDotsAtIndex:index+1];
    }];
    [self dotAimationWithShapeLayer:self.dotPathLayers[index]];
    [CATransaction commit];
}

- (void) dotAimationWithShapeLayer:(CAShapeLayer*)layer{
    layer.hidden = NO;
    if (_animationDuration == 0) {
        return;
    }
    [layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:nil];
}

- (void) drawAllLabels{
    if (_xLabels.count || _hasYLabels || _lineTexts.count) {
        if (_animationDuration) {
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _xLabelsView.alpha = 1;
                _yLabelsView.alpha = 1;
                _lineTextView.alpha = 1;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(lineChartAnimationDidEnd:)]) {
                    [self.delegate lineChartAnimationDidEnd:self];
                }
            }];
        }else{
            _xLabelsView.alpha = 1;
            _yLabelsView.alpha = 1;
            _lineTextView.alpha = 1;
            if ([self.delegate respondsToSelector:@selector(lineChartAnimationDidEnd:)]) {
                [self.delegate lineChartAnimationDidEnd:self];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(lineChartAnimationDidEnd:)]) {
            [self.delegate lineChartAnimationDidEnd:self];
        }
    }
}
@end




