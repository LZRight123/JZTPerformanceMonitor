//
//  JZTViewDrawTimeManager.m
//  hyb
//
//  Created by 梁泽 on 2017/8/22.
//  Copyright © 2017年 九州通. All rights reserved.
//

#import "JZTViewDrawTimeManager.h"

@interface JZTViewDrawTimeManager()
@property (nonatomic, assign) CFTimeInterval startDraw;
@property (nonatomic, assign) NSTimeInterval endDraw;
@property (nonatomic, strong, readwrite) UIView *tagView;
@property (nonatomic, strong, readwrite) UIView *rootView;
@property (nonatomic, copy  ) void(^drawCompletion)(NSTimeInterval interval) ;
@end

@implementation JZTViewDrawTimeManager
- (instancetype)init{
    if (self = [super init]) {
        _startDraw = CACurrentMediaTime();
    }
    return self;
}

//- (instancetype)initWithTageView:(UIView *)tagView inViewHierarchy:(UIView *)rootView drawCompletion:(void(^)(NSTimeInterval interval))completion{
//    if (self = [super init]) {
//        _tagView = tagView;
//        _rootView = rootView;
//        self.startDraw = CACurrentMediaTime();
//        self.drawCompletion = completion;
//        
//        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
//        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    }
//    return self;
//}
//
//- (void)tick:(CADisplayLink *)link{
//    if ([self.tagView isDescendantOfView:self.rootView]) {
//        [link invalidate];
//        self.endDraw = CACurrentMediaTime();
//        if (self.drawCompletion) {
//            self.drawCompletion(self.endDraw - self.startDraw);
//        }
//    }
//}

- (BOOL)findTagView:(UIView *)tagV inViewHierarchy:(UIView *)rootView{
    return [tagV isDescendantOfView:rootView];
}

//- (void)endPageRenderEvent:(UIView *)tagV{
//    self.endDraw = CACurrentMediaTime();
//}

- (NSTimeInterval)drawInterval{
    self.endDraw = CACurrentMediaTime();
    return self.endDraw - self.startDraw;
}

@end
