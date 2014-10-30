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

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
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
        [self setViewConstraints];
        [self setState:CHQPullToRefreshStateStopped];
    }
    return self;
}

- (void)setViewConstraints
{
//    NSLog(@"%f, %f", _monActivityView.frame.size.width, _monActivityView.frame.size.height);
    _monActivityView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *monViewCenterX = [NSLayoutConstraint constraintWithItem:_monActivityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-_monActivityView.frame.size.width/2];
    NSLayoutConstraint *monViewCenterY = [NSLayoutConstraint constraintWithItem:_monActivityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [self addConstraint:monViewCenterX];
    [self addConstraint:monViewCenterY];
    
    
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    contentOffset.y += self.originalTopInset;
    float ratio = 0.0f;
        if(contentOffset.y >= 0.0f)
        {
            [_monActivityView changeCirCle:0 withZoomRatio:0];
            [_monActivityView changeCirCle:1 withZoomRatio:0];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= -20 && contentOffset.y < 0.0f)
        {
            ratio = (0.0f-contentOffset.y)/20.0f;
            [_monActivityView changeCirCle:0 withZoomRatio:ratio];
            [_monActivityView changeCirCle:1 withZoomRatio:0];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= -40 && contentOffset.y < -20.0f)
        {
            ratio = (-20.0f-contentOffset.y)/20.0f;
            [_monActivityView changeCirCle:0 withZoomRatio:1.0f];
            [_monActivityView changeCirCle:1 withZoomRatio:ratio];
            [_monActivityView changeCirCle:2 withZoomRatio:0];
        }
        else if(contentOffset.y >= -60 && contentOffset.y < -40.0f)
        {
            ratio = (-40.0f-contentOffset.y)/20.0f;
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

@end
