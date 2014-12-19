//
//  CHQEatBeansRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/11/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQEatBeansRefreshView.h"
#import "Pac.h"
#define kCHQEatBeansRefreshViewHeight 100
#define kPixelsPerSecond 150
#define kStartingNumberOfDots 10
#define kMinNumberOfDots 3
@interface CHQEatBeansRefreshView()
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL processingEnd;

@property (nonatomic, strong) Pac *pac;
@property (nonatomic, strong) UIView *dotsView;
@property (nonatomic, strong) NSMutableArray *dots;
@property (nonatomic, assign) CGFloat dotSpacing;
@end

@implementation CHQEatBeansRefreshView
@synthesize pac = _pac;
@synthesize dotsView = _dotsView;
@synthesize dots = _dots;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)configureView
{
    self.backgroundColor = [UIColor blueColor];
    self.dotSpacing = PullToRefreshViewWidth / kStartingNumberOfDots;
    [self reset];
}

- (void)doSomethingWhenChangingOrientation
{
    
}

- (void)refresh
{
    if (self.state == CHQPullToRefreshStateLoading)
    {
        CGFloat diff = self.lastTime == 0 ? 0 : self.displayLink.timestamp - self.lastTime;
        [self refreshingWithDelta:diff];
        self.lastTime = self.displayLink.timestamp;
    }
}

- (void)reset
{
    self.pac.center = CGPointMake(-(self.pac.frame.size.width / 2), self.frame.size.height / 2);
    [self.pac reset];
    [self.dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *dot = (UIImageView*)obj;
        dot.hidden = NO;
        CGFloat x = [self xPositionDotAtIndex:idx withPercentage:1];
        dot.center = CGPointMake(x, dot.center.y);
        dot.transform = CGAffineTransformMakeScale(1, 1);
    }];
    self.dotsView.transform = CGAffineTransformMakeRotation(0);
    self.dotSpacing = PullToRefreshViewWidth / kStartingNumberOfDots;
}

- (void)refreshingWithDelta:(CGFloat)delta
{
    self.dotSpacing = self.bounds.size.width / kStartingNumberOfDots;
    [self.pac tick:delta];
//    NSLog(@"%f, %f", self.pac.center.x, self.pac.center.y);
    if (self.pac.center.x < self.frame.size.width / 2)
    {
        for (UIImageView *dot in self.dots)
        {
            if (self.pac.center.x >= dot.center.x)
                dot.hidden = YES;
        }
        
        CGFloat x = self.pac.frame.origin.x + (kPixelsPerSecond * delta);
        
        CGRect frame = self.pac.frame;
        frame.origin.x = x;
        self.pac.frame = frame;
//        NSLog(@"%f, %f", self.pac.center.x, self.pac.center.y);
    }
    else
    {
        self.pac.center = CGPointMake(self.frame.size.width / 2, self.pac.center.y);
        
        for (UIImageView *dot in self.dots)
        {
            if (!dot.hidden)
            {
                if (dot.center.x <= self.pac.center.x)
                    dot.center = CGPointMake(self.dotsView.frame.size.width + (self.dotSpacing / 2), dot.center.y);
                
                dot.center = CGPointMake(dot.center.x - (kPixelsPerSecond * delta), dot.center.y);
            }
        }
    }
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    CGFloat offset = contentOffset.y;
    CGFloat percent = CGFLOAT_MAX;
    if (offset == 0)
        percent = offset;
    else if (offset < 0)
        percent = MIN(ABS(offset) / (self.frame.size.height+self.originalTopInset), 1);
    if (percent < CGFLOAT_MAX)
    {
        [self.dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *dot = (UIImageView*)obj;
            CGFloat x = ((self.dotSpacing * (idx + 1) - (self.dotSpacing / 2)) * percent) + ((1 - percent) * (self.frame.size.width / 2));
            dot.center = CGPointMake(x, dot.center.y);
            dot.transform = CGAffineTransformMakeScale(percent, percent);
        }];
        self.dotsView.transform = CGAffineTransformMakeScale(percent, percent);
    }
}

- (CGFloat)xPositionDotAtIndex:(NSUInteger)index withPercentage:(CGFloat)percentage
{
    return ((self.dotSpacing * (index + 1) - (self.dotSpacing / 2)) * percentage) + ((1 - percentage) * (self.frame.size.width / 2));
}

- (void)doSomethingWhenStartingAnimating
{
    self.displayLink.paused = NO;
}

- (void)doSomethingWhenStopingAnimating
{
    if (!self.processingEnd)
    {
        self.processingEnd = YES;
        self.lastTime = 0;
        [self reset];
        self.processingEnd = NO;
        self.displayLink.paused = YES;
    }
}

#pragma mark getters
- (Pac *)pac
{
    if(!_pac)
    {
        _pac = [[Pac alloc] init];
        _pac.center = CGPointMake(-(_pac.frame.size.width / 2), PullToRefreshViewHeight / 2);
        [self addSubview:_pac];
    }
    return _pac;
}
- (UIView *)dotsView
{
    if(!_dotsView)
    {
        _dotsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PullToRefreshViewWidth, PullToRefreshViewHeight)];
        _dotsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_dotsView];
    }
    return _dotsView;
}
- (NSMutableArray *)dots
{
    if(!_dots)
    {
        _dots = [[NSMutableArray alloc] initWithCapacity:kStartingNumberOfDots];
        for (int i = 0; i < kStartingNumberOfDots; ++i)
        {
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
            [_dots addObject:iv];
            iv.center = CGPointMake(PullToRefreshViewWidth / 2, PullToRefreshViewHeight / 2);
            [self.dotsView addSubview:iv];
        }
    }
    return _dots;
}


@end
