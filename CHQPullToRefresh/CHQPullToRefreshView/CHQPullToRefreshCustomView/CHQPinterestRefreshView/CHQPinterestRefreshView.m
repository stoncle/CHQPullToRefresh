//
//  CHQPinterestRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 11/4/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQPinterestRefreshView.h"
#import "RHAnimator.h"
@interface CHQPinterestRefreshView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation CHQPinterestRefreshView
@synthesize activityView = _activityView;
@synthesize iconLayer = _iconLayer;
@synthesize circleLayer = _circleLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configureView
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circleLayer.position = CGPointMake(PullToRefreshViewWidth/2, CGRectGetMidY(self.bounds));
                         self.iconLayer.position = CGPointMake(PullToRefreshViewWidth/2, CGRectGetMidY(self.bounds));
                         self.activityView.center = CGPointMake(PullToRefreshViewWidth/2, CGRectGetMidY(self.bounds));
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)doSomethingWhenChangingOrientation
{
    
}




- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    CGFloat progress = -contentOffset.y / (self.originalTopInset + CHQPullToRefreshViewTriggerHeight);
    CGFloat deltaRotate = progress * 180;
    CGFloat angelDegree = (180.0 - deltaRotate);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.iconLayer.transform = CATransform3DMakeRotation((angelDegree) / 180.0 * M_PI, 0.0f, 0.0f, 1.0f);
    self.circleLayer.strokeEnd = progress;
    if (self.state != CHQPullToRefreshStateLoading) {
        self.iconLayer.opacity = progress;
        self.circleLayer.opacity = progress;
    }
    [CATransaction commit];
}

- (void)doSomethingWhenStartingAnimating
{
    [self.activityView startAnimating];
    self.iconLayer.opacity = 0;
    self.circleLayer.opacity = 0;
    CATransform3D fromMatrix = CATransform3DMakeScale(0.0, 0.0, 0.0);
    CATransform3D toMatrix = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    CAKeyframeAnimation *animation = [RHAnimator animationWithCATransform3DForKeyPath:@"transform"
                                                                       easingFunction:RHElasticEaseOut
                                                                           fromMatrix:fromMatrix
                                                                             toMatrix:toMatrix];
    animation.duration = 1.0f;
    animation.removedOnCompletion = NO;
    [self.activityView.layer addAnimation:animation forKey:@"transform"];
}

- (void)doSomethingWhenStopingAnimating
{
//        if (state == RHRefreshStatePulling) {
            self.iconLayer.opacity = 0;
            self.circleLayer.opacity = 0;
//        }
    
        [_activityView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark getters
- (UIActivityIndicatorView *)activityView
{
    if(!_activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 20.0f, 20.0f);
        _activityView.hidesWhenStopped = YES;
        _activityView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:_activityView];
    }
    return _activityView;
}
- (CALayer *)iconLayer
{
    if(!_iconLayer)
    {
        _iconLayer = [CALayer layer];
        _iconLayer.frame = CGRectMake(0, 0, 24.0f, 24.0f);
        _iconLayer.contentsGravity = kCAGravityCenter;
        _iconLayer.contents = (id)[UIImage imageNamed:@"pinterest_pin"].CGImage;
        _iconLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _iconLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            _iconLayer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        [[self layer] addSublayer:_iconLayer];
    }
    return _iconLayer;
}
- (CAShapeLayer *)circleLayer
{
    if(!_circleLayer)
    {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = CGRectMake(0, 0, 25.0f, 25.0f);
        _circleLayer.contentsGravity = kCAGravityCenter;
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_circleLayer.position
                                                                  radius:CGRectGetMidX(_circleLayer.bounds)
                                                              startAngle:0
                                                                endAngle:(360) / 180.0 * M_PI
                                                               clockwise:NO];
        _circleLayer.path = circlePath.CGPath;
        
        _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _circleLayer.fillColor = [UIColor whiteColor].CGColor;
        _circleLayer.strokeColor = [UIColor colorWithRed:0.79 green:0.12 blue:0.15 alpha:1.0].CGColor;
        _circleLayer.lineWidth =2.0f;
        _circleLayer.strokeEnd = 0.0f;
        [[self layer] addSublayer:_circleLayer];
    }
    return _circleLayer;
}

@end
