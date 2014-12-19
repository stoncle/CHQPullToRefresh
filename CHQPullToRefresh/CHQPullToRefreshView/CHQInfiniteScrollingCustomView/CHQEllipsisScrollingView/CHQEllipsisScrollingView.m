//
//  CHQEllipsisScrollingView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 12/7/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQEllipsisScrollingView.h"
#import "MONActivityIndicatorView1.h"
#define ThemeColor [UIColor hexStringToColor:@"#FFFFFF"]
#define EllipsisNumber 3
@interface CHQEllipsisScrollingView()<MONActivityIndicatorViewDelegate>
@property (strong, nonatomic) MONActivityIndicatorView1 *monActivityView;
@property (nonatomic) BOOL easyInCircleExisted;
@end



@implementation CHQEllipsisScrollingView

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
    if(contentOffset.y + self.scrollView.frame.size.height > self.frame.origin.y)
    {
        [self.monActivityView startAnimating];
    }
    else
    {
        [self.monActivityView stopAnimating];
    }
}

- (void)doSomethingWhenStartingAnimating
{
    self.monActivityView.alpha  = 1;
}

- (void)doSomethingWhenStopingAnimating
{
    self.monActivityView.alpha = 0.5;
    [self.monActivityView stopAnimating];
    [self.monActivityView addCirCle:3];
}

- (void)doSomethingWhenChangingOrientation
{
    
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView1 *)activityIndicatorView
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
- (MONActivityIndicatorView1 *)monActivityView
{
    if(!_monActivityView)
    {
        _monActivityView = [[MONActivityIndicatorView1 alloc] init];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

