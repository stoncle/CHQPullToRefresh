//
//  CHQBalloonRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 11/2/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQBalloonRefreshView.h"

#define BalloonPullToRefreshViewTriggerAreaHeight 101
#define BalloonPullToRefreshViewParticleSize 0.5
#define BalloonPullToRefreshViewAnimationRadius 35.0
#define BalloonPullToRefreshViewParticlesCount 8
#define BalloonPullToRefreshViewAnimationAngle (360.0 / self.particlesCount)

@interface CHQBalloonRefreshView ()

@property (nonatomic, strong) NSArray *particles;

@end

@implementation CHQBalloonRefreshView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self configureView];
    }
    return self;
}
- (void)configureView
{
    
}

- (void)commonInit
{
    self.backgroundColor = [UIColor colorWithRed:0.65f green:0.83f blue:0.93f alpha:1.00f];
    self.clipsToBounds = YES;
    self.particlesCount = BalloonPullToRefreshViewParticlesCount;
}

- (void) setParticlesCount:(int)particlesCount {
    
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        [particleView removeFromSuperview];
    }
    _particlesCount = particlesCount;
    NSMutableArray *particles = [NSMutableArray new];
    NSArray *images = @[@"circle_blue", @"circle_red", @"circle_green", @"circle_orange", @"circle_purple", @"circle_seagreen"];
    for (int i=0; i<self.particlesCount; i++) {
        UIImageView *particleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: images[i % images.count]]];
        particleView.alpha = 0.5;
        particleView.backgroundColor = [UIColor clearColor];
        particleView.frame = CGRectMake(0, 0, BalloonPullToRefreshViewParticleSize, BalloonPullToRefreshViewParticleSize);
        [self addSubview: particleView];
        [particles addObject: particleView];
    }
    _particles = particles;
}

- (void)doSpinAnimationStepForWaitingAnimation {
    animationStep ++;
    for (int i=0; i<self.particles.count; i++) {
        float angle = - (i * BalloonPullToRefreshViewAnimationAngle + animationStep * 5) * M_PI / 180;
        float radius = BalloonPullToRefreshViewAnimationRadius;
        UIView *particleView = self.particles [i];
        particleView.center = CGPointMake((PullToRefreshViewWidth / 2) + radius * cos (angle), self.frame.size.height - ((BalloonPullToRefreshViewTriggerAreaHeight / 2) + radius * sin(angle)));
    }
}

- (void)doFadeAnimationStepForWaitingAnimation {
    int prevAnimationStep = animationStep;
    animationStep = (animationStep + 1) % self.particles.count;
    [self animateAlphaForView:self.particles[prevAnimationStep] newAlpha:0.3];
    [self animateAlphaForView:self.particles[animationStep] newAlpha:0.8];
}

- (void)onAnimationTimer {
    if (isRefreshing) {
        if (self.waitingAnimation == BalloonPullToRefreshWaitAnimationSpin) {
            [self doSpinAnimationStepForWaitingAnimation];
        } else {
            [self doFadeAnimationStepForWaitingAnimation];
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

- (void)animateAlphaForView: (UIView *)viewToAnimate newAlpha: (float)newAlpha {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         viewToAnimate.alpha = newAlpha;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)doSomethingWhenStartingAnimating
{
    [animationTimer invalidate];
    animationTimer = nil;
    isRefreshing = YES;
    animationStep = 0;
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (int i=0; i<self.particles.count; i++) {
                             float angle = - (i * BalloonPullToRefreshViewAnimationAngle) * M_PI / 180;
                             float radius = BalloonPullToRefreshViewAnimationRadius;
                             UIView *particleView = self.particles [i];
                             particleView.center = CGPointMake((PullToRefreshViewWidth / 2) + radius * cos (angle), self.frame.size.height - ((BalloonPullToRefreshViewTriggerAreaHeight / 2) + radius * sin(angle)));
                         }
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             float timeInterval = 0.02;
                             if (self.waitingAnimation == BalloonPullToRefreshWaitAnimationFade) {
                                 timeInterval = 0.2;
                             }
                             animationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onAnimationTimer) userInfo:nil repeats:YES];
                         }
                     }];
}

- (void)doSomethingWhenStopingAnimating
{
    if (isRefreshing == NO) {
        return;
    }
    isRefreshing = NO;
    [animationTimer invalidate];
    animationTimer = nil;
    for (int i=0; i<self.particles.count; i++) {
        UIView *particleView = self.particles [i];
        
        particleView.alpha = 0.5;
    }
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onAnimationTimer) userInfo:nil repeats:YES];
}

- (void)doSomethingWhenChangingOrientation
{
    
}

- (void) doSomethingWhenScrolling:(CGPoint)contentOffsety {
    float contentOffset = contentOffsety.y;
    contentOffset = -contentOffset / 2;
    
    if (isRefreshing) {
        return;
    }
    
    if (contentOffset < -10) {
        contentOffset = -10;
    }
    
    if (contentOffset > BalloonPullToRefreshViewTriggerAreaHeight / 2) {
        contentOffset = BalloonPullToRefreshViewTriggerAreaHeight / 2;
    }
    
    lastOffset = contentOffset * 2;
    
    float ratio = (contentOffset / 2);
    
    if (contentOffset == BalloonPullToRefreshViewTriggerAreaHeight / 2) {
        for (int i=0; i<self.particles.count; i++) {
            UIView *particleView = self.particles [i];
            particleView.center = CGPointMake(PullToRefreshViewWidth / 2, self.frame.size.height - contentOffset);
        }
    } else {
        for (int i=0; i<self.particles.count; i++) {
            
            float angle = - (i * BalloonPullToRefreshViewAnimationAngle + contentOffset) * M_PI / 180;
            float radius = 200 - (contentOffset * 4);
            
            UIView *particleView = self.particles [i];
            
            particleView.frame = CGRectMake(0, 0, BalloonPullToRefreshViewParticleSize + ratio, BalloonPullToRefreshViewParticleSize + ratio);
            particleView.center = CGPointMake((PullToRefreshViewWidth / 2) + radius * cos (angle), self.frame.size.height - ((BalloonPullToRefreshViewTriggerAreaHeight / 2) + radius * sin(angle)));
        }
    }
    
    [self setNeedsDisplay];
}

@end