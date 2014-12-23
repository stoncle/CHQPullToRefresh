//
//  CHQSpiralRefreshView.m
//  MyCollectionvView
//
//  Created by stoncle on 14-10-4.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import "CHQSpiralRefreshView.h"

#define SpiralPullToRefreshViewHeight 180
#define SpiralPullToRefreshViewParticleSize 7

#define SpiralPullToRefreshViewAnimationAngle (360.0 / 10.0)
#define kSpiralNormalColor [UIColor darkGrayColor]
#define kSpiralTransteringColor [UIColor lightGrayColor]
#define kSpiralTriggeredColor [UIColor redColor]
#define kBackgroundColor [UIColor whiteColor]
#define kSpiralFinishColor [UIColor darkGrayColor]

@interface CHQSpiralRefreshView()
{
    BOOL isRefreshing;
    NSTimer *animationTimer;
    float lastOffset;
    int animationStep;
}
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) UIView *bottomRightView;
@property (nonatomic, strong) UIView *bottomCenterView;
@property (nonatomic, strong) UIView *middleLeftView;
@property (nonatomic, strong) UIView *middleRightView;
@property (nonatomic, strong) UIView *middleCenterView;
@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UIView *topRightView;
@property (nonatomic, strong) UIView *topCenterView;
@end

@implementation CHQSpiralRefreshView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kBackgroundColor;
        self.clipsToBounds = YES;
        [self commonInit];
        _particles = @[self.bottomLeftView, self.bottomCenterView, self.bottomRightView,
                       self.middleLeftView, self.middleCenterView, self.middleRightView,
                       self.topLeftView, self.topCenterView, self.topRightView];
        [self configureView];
    }
    return self;
}

- (void)commonInit
{
    self.bottomLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.bottomLeftView.backgroundColor = kSpiralNormalColor;
    self.bottomLeftView.center = CGPointMake(10, self.frame.size.height - self.bottomLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
    [self addSubview: self.bottomLeftView];
    
    self.bottomRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.bottomRightView.backgroundColor = kSpiralNormalColor;
    self.bottomRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - self.bottomRightView.frame.size.height - SpiralPullToRefreshViewParticleSize);
    [self addSubview: self.bottomRightView];
    
    self.bottomCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.bottomCenterView.backgroundColor = kSpiralNormalColor;
    self.bottomCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - self.bottomCenterView.frame.size.height);
    [self addSubview: self.bottomCenterView];

    self.middleLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.middleLeftView.backgroundColor = kSpiralNormalColor;
    self.middleLeftView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - self.middleLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
    [self addSubview: self.middleLeftView];
    
    self.middleRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.middleRightView.backgroundColor = kSpiralNormalColor;
    self.middleRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - self.middleRightView.frame.size.height - SpiralPullToRefreshViewParticleSize);
    [self addSubview: self.middleRightView];
    
    self.middleCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.middleCenterView.backgroundColor = kSpiralNormalColor;
    self.middleCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - self.middleCenterView.frame.size.height);
    [self addSubview: self.middleCenterView];
    
    self.topLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.topLeftView.backgroundColor = kSpiralNormalColor;
    self.topLeftView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - self.topLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
    [self addSubview: self.topLeftView];
    
    self.topRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.topRightView.backgroundColor = kSpiralNormalColor;
    self.topRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - self.topRightView.frame.size.height - 5);
    [self addSubview: self.topRightView];
    
    self.topCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
    self.topCenterView.backgroundColor = kSpiralNormalColor;
    self.topCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - self.topCenterView.frame.size.height);
    [self addSubview: self.topCenterView];
}

- (void)configureView
{
    [self resetViewForCurrentOrientation];
}

- (void)doSomethingWhenLayoutSubviews
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self resetViewForCurrentOrientation];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)resetViewForCurrentOrientation
{
    self.bottomLeftView.center = CGPointMake((PullToRefreshViewWidth / 2) - self.bottomLeftView.frame.size.width - 1, self.frame.size.height - 30 + self.bottomLeftView.frame.size.height + 1);
    self.bottomRightView.center = CGPointMake((PullToRefreshViewWidth / 2) - self.bottomRightView.frame.size.width - 1, self.frame.size.height - 30 - self.bottomRightView.frame.size.height - 1);
    self.topRightView.center = CGPointMake((PullToRefreshViewWidth / 2) + self.topRightView.frame.size.width + 1, self.frame.size.height - 30 - self.topRightView.frame.size.height - 1);
    self.topLeftView.center = CGPointMake((PullToRefreshViewWidth / 2) + self.topLeftView.frame.size.width + 1, self.frame.size.height - 30 + self.topLeftView.frame.size.height + 1);
    
    self.middleLeftView.center = CGPointMake((PullToRefreshViewWidth / 2) - self.middleLeftView.frame.size.width - 1, self.frame.size.height - 30);
    self.middleRightView.center = CGPointMake((PullToRefreshViewWidth / 2) + self.middleRightView.frame.size.width + 1, self.frame.size.height - 30);
    self.middleCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - 30);
    self.topCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - 30 - self.topCenterView.frame.size.height - 1);
    self.bottomCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - 30 + self.bottomCenterView.frame.size.height + 1);
}

- (void)doSomethingWhenStateChanges
{
    switch (self.state) {
        case CHQPullToRefreshStateAll:
        case CHQPullToRefreshStateStopped:
            [self changeSpiralColor:kSpiralNormalColor];
            break;
            
        case CHQPullToRefreshStateTriggered:
            [self changeSpiralColor:kSpiralTriggeredColor];
            break;
            
        case CHQPullToRefreshStateLoading:
            
            break;
    }
}

- (void)doSomethingWhenChangingOrientation
{
    
}

- (void)changeSpiralColor:(UIColor *)aimColor
{
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        particleView.backgroundColor = aimColor;
    }
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffsety
{
    float contentOffset = contentOffsety.y;
    contentOffset = -contentOffset / 2;
    
    if (isRefreshing || (!self.scrollView.isDragging && self.state == CHQPullToRefreshStateLoading)) {
        return;
    }
    
    if (contentOffset < -10) {
        contentOffset = -10;
    }
    
    if (contentOffset > self.pullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2) {
        contentOffset = self.pullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2;
    }
    
    if (contentOffset == self.pullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self resetViewForCurrentOrientation];
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        
        for (int i=0; i<self.particles.count; i++) {
            
            float angle = - (i * SpiralPullToRefreshViewAnimationAngle + contentOffset + (-self.originalTopInset) / 2 + 100) * M_PI / 180;
            float radius = 130 - ((contentOffset + (-self.originalTopInset) / 2) * 4);
            
            UIView *particleView = self.particles [i];
            
            particleView.center = CGPointMake((PullToRefreshViewWidth / 2) + radius * cos (angle), self.frame.size.height - ((self.pullToRefreshViewHangingHeight / 2) + radius * sin(angle)));
        }
        lastOffset = (contentOffset + (-self.originalTopInset) / 2)* 2;
    }
    
    [self setNeedsDisplay];
}

- (void)setWaitingAnimation:(SpiralPullToRefreshWaitAnimation)waitingAnimation {
    _waitingAnimation = waitingAnimation;
    
    switch (waitingAnimation) {
        case SpiralPullToRefreshWaitAnimationCircular:
        case SpiralPullToRefreshWaitAnimationLinear: {
            _particles = @[self.bottomRightView, self.topCenterView, self.topRightView,
                           self.middleLeftView, self.middleCenterView, self.middleRightView,
                           _bottomLeftView, self.bottomCenterView, self.topLeftView];
        }
            break;
            
        default:
            break;
    }
}

- (void)doAnimationStepForRandomWaitingAnimation {
    int idx = arc4random() % self.particles.count;
    
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        particleView.backgroundColor = (i == idx) ? kSpiralTriggeredColor : kSpiralNormalColor;
    }
}

- (void)doAnimationStepForLinearWaitingAnimation {
    int startIdx = 0;
    int prevIdx = 0;
    
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        if (particleView.backgroundColor == kSpiralNormalColor) {
            startIdx = i;
            break;;
        }
    }
    
    prevIdx = startIdx;
    startIdx = (startIdx + 1) % self.particles.count;
    
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        if (i == prevIdx) {
            particleView.backgroundColor = kSpiralTransteringColor;
        } else if (i == startIdx) {
            particleView.backgroundColor = kSpiralTriggeredColor;
        } else {
            particleView.backgroundColor = kSpiralNormalColor;
        }
    }
}

- (void)doAnimationStepForCircularWaitingAnimation {
    int path[] = {0, 1, 2, 5, 8, 7, 6, 3};
    
    int startIdx = 0;
    int prevIdx = 0;
    
    animationStep++;
    
    prevIdx = path[animationStep % (self.particles.count - 1)];
    startIdx = path[(animationStep + 1) % (self.particles.count - 1)];
    
    if (prevIdx == startIdx) {
        startIdx = prevIdx;
    }
    
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        if (i == prevIdx) {
            particleView.backgroundColor = kSpiralTransteringColor;
        } else if (i == startIdx) {
            particleView.backgroundColor = kSpiralTriggeredColor;
        } else {
            particleView.backgroundColor = kSpiralNormalColor;
        }
    }
}

- (void)onAnimationTimer {
    if (isRefreshing) {
        switch (self.waitingAnimation) {
            case SpiralPullToRefreshWaitAnimationRandom: {
                [self doAnimationStepForRandomWaitingAnimation];
            }
                break;
            case SpiralPullToRefreshWaitAnimationLinear: {
                [self doAnimationStepForLinearWaitingAnimation];
            }
                break;
            case SpiralPullToRefreshWaitAnimationCircular: {
                [self doAnimationStepForCircularWaitingAnimation];
            }
                break;
            default:
                break;
        }
    } else {
        if (lastOffset < 30) {
            [animationTimer invalidate];
            animationTimer = nil;
            self.state = CHQPullToRefreshStateStopped;
            if (!self.wasTriggeredByUser) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0) animated:YES];
            }
            return;
        }
        lastOffset -= 2;
    }
}

- (void)doSomethingWhenStartingAnimating
{
    [animationTimer invalidate];
    animationTimer = nil;
    
    isRefreshing = YES;
    animationStep = 0;
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onAnimationTimer) userInfo:nil repeats:YES];
}

- (void)doSomethingWhenStopingAnimating
{
    if (isRefreshing == NO) {
        return;
    }
    isRefreshing = NO;
    NSArray *particles = @[self.bottomLeftView, self.bottomCenterView, self.bottomRightView,
                           self.middleLeftView, self.middleCenterView, self.middleRightView,
                           self.topLeftView, self.topCenterView, self.topRightView];
    for (int i=0; i<particles.count; i++) {
        UIView *particleView = particles [i];
        particleView.backgroundColor = kSpiralFinishColor;
    }
    [self setNeedsDisplay];
    [animationTimer invalidate];
    animationTimer = nil;
}

@end
