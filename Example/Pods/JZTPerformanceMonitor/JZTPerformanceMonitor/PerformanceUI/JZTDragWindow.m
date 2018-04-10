//
//  JZTDragWindow.m
//  hyb
//
//  Created by 梁泽 on 2017/9/7.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTDragWindow.h"
#import "JZTMonitorNavigationVC.h"
#import "NSBundle+PerformanceMonitor.h"
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define PADDING 5
#define kSize 44.

@interface JZTDragWindow()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) CGRect lastFrame;

@property (nonatomic, strong) UIViewController *rootVC;
@end

@implementation JZTDragWindow
- (void)test{
    UITableViewController *vc = [[UITableViewController alloc]init];
    vc.view.backgroundColor = [UIColor blueColor];
    vc.view.userInteractionEnabled = NO;
    self.rootViewController = vc;
}


+ (instancetype)window{
    static JZTDragWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[self alloc]init];
    });
    return window;
}
- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(PADDING, 80, kSize, kSize);
    self.windowLevel = UIWindowLevelAlert + 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.dragEnable = YES;
    self.adsorbEnable = YES;
    
    [self addGestureRecognizer:self.tapGesture];
    [self addSubview:self.imageView];
    self.imageView.frame = self.bounds;
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
}

- (void)didClick:(UITapGestureRecognizer *)sender{
    if (self.state != JZTDragWindowStateSmall) {
        return;
    }
    
    CGPoint center = sender.view.center;
    if (CGRectContainsPoint(self.screen.bounds, center)) {
        self.state = JZTDragWindowStateMedium;
    }
}

- (void)setState:(JZTDragWindowState)state{
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case JZTDragWindowStateSmall:{
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = self.lastFrame;
            } completion:^(BOOL finished) {
                self.rootViewController = nil;
                self.layer.borderColor = [UIColor clearColor].CGColor;
            }];
        }
            break;
        case JZTDragWindowStateMedium:{
            self.rootViewController = [JZTMonitorNavigationVC create];
            self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            
            self.lastFrame = self.frame;
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(0, 0, ScreenWidth*3/4., ScreenHeight/2);
                self.center = CGPointMake(ScreenWidth/2., ScreenHeight/2);
            } completion:^(BOOL finished) {
                self.rootViewController.view.frame = self.bounds;
            }];
        }
            break;
    }
}

- (void)setupShadow{
    self.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 3;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;

}
#pragma mark - getter @property
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[NSBundle jzt_drugImage]];
        UIImage *img = [NSBundle jzt_drugImage];
        NSLog(@"%@",img);
    }
    return _imageView;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick:)];
        _tapGesture.cancelsTouchesInView = NO;
    }
    return _tapGesture;
}

- (UIViewController *)rootVC{
    if (!_rootVC) {
        _rootVC = [JZTMonitorNavigationVC create];
    }
    return _rootVC;
}
#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isDragEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - self.beginPoint.x;
    float offsetY = nowPoint.y - self.beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state != JZTDragWindowStateSmall) {
        return;
    }
    
    if (self.isAdsorbEnable) {
        float marginLeft = self.frame.origin.x;
        float marginRight = ScreenWidth - self.frame.origin.x - kSize;
        float marginTop = self.frame.origin.y;
        float marginBottom = ScreenHeight - self.frame.origin.y - kSize;
        [UIView animateWithDuration:0.125 animations:^(void){
            if (marginTop<60) {
                self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?ScreenWidth -kSize - PADDING:self.frame.origin.x,
                                        PADDING,
                                        kSize,
                                        kSize);
            }
            else if (marginBottom<60) {
                self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?ScreenWidth -kSize-PADDING:self.frame.origin.x,
                                        ScreenHeight - kSize -PADDING,
                                        kSize,
                                        kSize);
                
            }
            else {
                self.frame = CGRectMake(marginLeft<marginRight?PADDING:ScreenWidth - kSize-PADDING,
                                        self.frame.origin.y,
                                        kSize,
                                        kSize);
            }
        }];
    }
}

@end

