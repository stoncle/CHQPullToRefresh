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
#define kStartingNumberOfDots 5
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)];
    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.dotsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.dotsView];
        
        self.pac = [[Pac alloc] init];
        self.pac.center = CGPointMake(-(self.pac.frame.size.width / 2), frame.size.height / 2);
        [self addSubview:self.pac];
//        NSLog(@"%@", NSStringFromCGRect(self.pac.frame));
        
        self.dots = [[NSMutableArray alloc] initWithCapacity:kStartingNumberOfDots];
        for (int i = 0; i < kStartingNumberOfDots; ++i)
        {
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
            [self.dots addObject:iv];
            iv.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
            [self.dotsView addSubview:iv];
        }
        
        self.dotSpacing = frame.size.width / kStartingNumberOfDots;
        [self reset];
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dotsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dotsView)]];
    return self;
}

- (void)refresh
{
//    self.dotSpacing = self.bounds.size.width / kStartingNumberOfDots;
    if (self.state == CHQPullToRefreshStateLoading)
    {
        CGFloat diff = self.lastTime == 0 ? 0 : self.displayLink.timestamp - self.lastTime;
        [self refreshingWithDelta:diff];
        self.lastTime = self.displayLink.timestamp;
    }
}

- (void)layoutSubviews
{
    self.dotSpacing = self.bounds.size.width / kStartingNumberOfDots;
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
    self.dotSpacing = self.bounds.size.width / kStartingNumberOfDots;
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

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != CHQPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        scrollOffsetThreshold = self.frame.origin.y - CHQPullToRefreshViewHangingHeight;
        if(!self.scrollView.isDragging && self.state == CHQPullToRefreshStateTriggered)
            self.state = CHQPullToRefreshStateLoading;
        else if(((contentOffset.y < -CHQPullToRefreshViewTriggerHeight)) && self.scrollView.isDragging && self.state == CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateTriggered;
        else if(contentOffset.y >= -CHQPullToRefreshViewTriggerHeight && self.state != CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateStopped;
    }
    else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, CHQPullToRefreshViewHangingHeight);
        contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        
        [self contentOffsetChanged: oldOffset.y];
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    } else {
        if ([keyPath isEqualToString:@"frame"]) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
    }
}

- (void) contentOffsetChanged:(float)contentOffset
{
    CGFloat offset = self.scrollView.contentOffset.y;
    CGFloat percent = CGFLOAT_MAX;
    if (offset == 0)
        percent = offset;
    else if (offset < 0)
        percent = MIN(ABS(offset) / self.frame.size.height, 1);
    
    if (percent < CGFLOAT_MAX)
    {
        [self.dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *dot = (UIImageView*)obj;
            CGFloat x = ((self.dotSpacing * (idx + 1) - (self.dotSpacing / 2)) * percent) + ((1 - percent) * (self.frame.size.width / 2));
            dot.center = CGPointMake(x, dot.center.y);
            dot.transform = CGAffineTransformMakeScale(percent, percent);
        }];
        self.dotsView.transform = CGAffineTransformMakeRotation(M_PI * ((1 - percent) * 90) / 180.0);

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


@end
