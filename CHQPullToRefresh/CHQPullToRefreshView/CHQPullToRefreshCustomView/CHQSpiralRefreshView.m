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
@synthesize waitingAnimation = _waitingAnimation;
@synthesize particles = _particles;
@synthesize bottomLeftView = _bottomLeftView;
@synthesize bottomRightView = _bottomRightView;
@synthesize bottomCenterView = _bottomCenterView;
@synthesize middleCenterView = _middleCenterView;
@synthesize middleLeftView = _middleLeftView;
@synthesize middleRightView = _middleRightView;
@synthesize topCenterView = _topCenterView;
@synthesize topRightView = _topRightView;
@synthesize topLeftView = _topLeftView;

//init your customize view
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // default styling values
        self.backgroundColor = kBackgroundColor;
        self.clipsToBounds = YES;
        _particles = @[_bottomLeftView, _bottomCenterView, _bottomRightView,
                       _middleLeftView, _middleCenterView, _middleRightView,
                       _topLeftView, _topCenterView, _topRightView];
    }
    return self;
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
    
    if (contentOffset > CHQPullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2) {
        contentOffset = CHQPullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2;
    }
    
    if (contentOffset == CHQPullToRefreshViewTriggerHeight / 2 + (self.originalTopInset) / 2) {
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
            
            particleView.center = CGPointMake((PullToRefreshViewWidth / 2) + radius * cos (angle), self.frame.size.height - ((CHQPullToRefreshViewHangingHeight / 2) + radius * sin(angle)));
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
            _particles = @[_bottomRightView, _topCenterView, _topRightView,
                           _middleLeftView, _middleCenterView, _middleRightView,
                           _bottomLeftView, _bottomCenterView, _topLeftView];
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
    NSArray *particles = @[_bottomLeftView, _bottomCenterView, _bottomRightView,
                           _middleLeftView, _middleCenterView, _middleRightView,
                           _topLeftView, _topCenterView, _topRightView];
    for (int i=0; i<particles.count; i++) {
        UIView *particleView = particles [i];
        particleView.backgroundColor = kSpiralFinishColor;
    }
    [self setNeedsDisplay];
    [animationTimer invalidate];
    animationTimer = nil;
}

#pragma mark getters
- (UIView *)bottomLeftView
{
    if(!_bottomLeftView)
    {
        _bottomLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _bottomLeftView.backgroundColor = kSpiralNormalColor;
        _bottomLeftView.center = CGPointMake(10, self.frame.size.height - _bottomLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
        
        [self addSubview: _bottomLeftView];
    }
    return _bottomLeftView;
}
- (UIView *)bottomRightView
{
    if(!_bottomRightView)
    {
        _bottomRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _bottomRightView.backgroundColor = kSpiralNormalColor;
        _bottomRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - _bottomRightView.frame.size.height - SpiralPullToRefreshViewParticleSize);
        
        [self addSubview: _bottomRightView];
    }
    return _bottomRightView;
}
- (UIView *)bottomCenterView
{
    if(!_bottomCenterView)
    {
        _bottomCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _bottomCenterView.backgroundColor = kSpiralNormalColor;
        _bottomCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - _bottomCenterView.frame.size.height);
        
        [self addSubview: _bottomCenterView];
    }
    return _bottomCenterView;
}
- (UIView *)middleLeftView
{
    if(!_middleLeftView)
    {
        _middleLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _middleLeftView.backgroundColor = kSpiralNormalColor;
        _middleLeftView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - _middleLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
        
        [self addSubview: _middleLeftView];
    }
    return _middleLeftView;
}
- (UIView *)middleRightView
{
    if(!_middleRightView)
    {
        _middleRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _middleRightView.backgroundColor = kSpiralNormalColor;
        _middleRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - _middleRightView.frame.size.height - SpiralPullToRefreshViewParticleSize);
        
        [self addSubview: _middleRightView];
    }
    return _middleRightView;
}
- (UIView *)middleCenterView
{
    if(!_middleCenterView)
    {
        _middleCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _middleCenterView.backgroundColor = kSpiralNormalColor;
        _middleCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - _middleCenterView.frame.size.height);
        
        [self addSubview: _middleCenterView];
    }
    return _middleCenterView;
}
- (UIView *)topLeftView
{
    if(!_topLeftView)
    {
        _topLeftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _topLeftView.backgroundColor = kSpiralNormalColor;
        _topLeftView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - _topLeftView.frame.size.height - SpiralPullToRefreshViewParticleSize);
        
        [self addSubview: _topLeftView];
    }
    return _topLeftView;
}
- (UIView *)topRightView
{
    if(!_topRightView)
    {
        _topRightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _topRightView.backgroundColor = kSpiralNormalColor;
        _topRightView.center = CGPointMake(PullToRefreshViewWidth - 10, self.frame.size.height - _topRightView.frame.size.height - 5);
        
        [self addSubview: _topRightView];
    }
    return _topRightView;
}
- (UIView *)topCenterView
{
    if(!_topCenterView)
    {
        _topCenterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SpiralPullToRefreshViewParticleSize, SpiralPullToRefreshViewParticleSize)];
        _topCenterView.backgroundColor = kSpiralNormalColor;
        _topCenterView.center = CGPointMake((PullToRefreshViewWidth / 2), self.frame.size.height - _topCenterView.frame.size.height);
        
        [self addSubview: _topCenterView];
    }
    return _topCenterView;
}

@end
