//
//  CHQEllipsisRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/30/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQEllipsisRefreshView.h"
#import "MONActivityIndicatorView.h"
#define ThemeColor [UIColor hexStringToColor:@"#FFFFFF"]
#define EllipsisNumber 3

@interface CHQEllipsisRefreshView()<MONActivityIndicatorViewDelegate>
@property (strong, nonatomic) MONActivityIndicatorView *monActivityView;
@property (nonatomic) BOOL easyInCircleExisted;
@end

@implementation CHQEllipsisRefreshView
@synthesize monActivityView = _monActivityView;

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self setViewConstraints];
    }
    return self;
}

- (void)setViewConstraints
{
//    NSLog(@"%f, %f", _monActivityView.frame.size.width, _monActivityView.frame.size.height);
    _monActivityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *monViewCenterX = [NSLayoutConstraint constraintWithItem:self.monActivityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-self.monActivityView.frame.size.width/2];
    NSLayoutConstraint *monViewCenterY = [NSLayoutConstraint constraintWithItem:self.monActivityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [self addConstraint:monViewCenterX];
    [self addConstraint:monViewCenterY];
}
- (void)configureView
{
    
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    contentOffset.y += self.originalTopInset;
    float ratio = 0.0f;
    float r1 = -self.pullToRefreshViewTriggerHeight/3;
    float r2 = -(2*self.pullToRefreshViewTriggerHeight)/3;
    float r3 = -self.pullToRefreshViewTriggerHeight;
    float delta = self.pullToRefreshViewTriggerHeight/3;
        if(contentOffset.y >= 0.0f)
        {
            [_monActivityView changeCirCle:0 withZoomRatio:0];
            [_monActivityView changeCirCle:1 withZoomRatio:0];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= r1 && contentOffset.y < 0.0f)
        {
            ratio = (0.0f-contentOffset.y)/delta;
            [_monActivityView changeCirCle:0 withZoomRatio:ratio];
            [_monActivityView changeCirCle:1 withZoomRatio:0];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= r2 && contentOffset.y < r1)
        {
            ratio = (r1-contentOffset.y)/delta;
            [_monActivityView changeCirCle:0 withZoomRatio:1.0f];
            [_monActivityView changeCirCle:1 withZoomRatio:ratio];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= r3 && contentOffset.y < r2)
        {
            ratio = (r2-contentOffset.y)/delta;
            [_monActivityView changeCirCle:0 withZoomRatio:1.0f];
            [_monActivityView changeCirCle:1 withZoomRatio:1.0f];
            [_monActivityView changeCirCle:2 withZoomRatio:ratio];
        }
    
}

- (void)doSomethingWhenStartingAnimating
{
    [_monActivityView removeEasyInAnimation];
    
    // Display loading activity
    _monActivityView.numberOfCircles = EllipsisNumber;
    if(EllipsisNumber > 3)
    {
        float rate = 5-(EllipsisNumber-4)*0.5;
        rate = rate < 2.4 ? 2.4 : rate;
        _monActivityView.frame = CGRectMake(_monActivityView.frame.origin.x - _monActivityView.frame.size.width/2.4 + 15, _monActivityView.frame.origin.y, _monActivityView.frame.size.width, _monActivityView.frame.size.height);
    }
    [_monActivityView startAnimating];
}

- (void)doSomethingWhenStopingAnimating
{
    [_monActivityView stopAnimating];
    [_monActivityView addCirCle:3];
}

- (void)doSomethingWhenChangingOrientation
{
    
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor blackColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark getters
- (MONActivityIndicatorView *)monActivityView
{
    if(!_monActivityView)
    {
        _monActivityView = [[MONActivityIndicatorView alloc] init];
        _monActivityView.radius = 6;
        _monActivityView.delegate = self;
        _monActivityView.internalSpacing = 4;
        _monActivityView.duration = 0.6;
        NSLog(@"%f, %f", self.center.x, self.center.y/2);
        _monActivityView.numberOfCircles = 3;
        [_monActivityView addCirCle:3];
        [self addSubview:_monActivityView];
    }
    return _monActivityView;
}

@end
