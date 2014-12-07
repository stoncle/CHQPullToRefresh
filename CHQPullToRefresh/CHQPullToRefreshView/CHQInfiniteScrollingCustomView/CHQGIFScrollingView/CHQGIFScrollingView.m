//
//  CHQGIFScrollingView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/29/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQGIFScrollingView.h"
@interface CHQGIFScrollingView()
@property (nonatomic, strong) UIImageView *imageViewLoading;
@property (nonatomic, strong) UILabel *labelLoading;
@property (nonatomic, strong) NSArray *pImgArrLoading;
@property (nonatomic, assign) NSInteger LoadingFrameRate;
@end

@implementation CHQGIFScrollingView
@synthesize imageViewLoading = _imageViewLoading;
@synthesize labelLoading = _labelLoading;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithRefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame
{
    NSArray *refreshingImages = refreshingImage.images;
    self = [super initWithFrame:frame];
    if(self) {
        self.pImgArrLoading = refreshingImages;
        //number of frame per second
        self.LoadingFrameRate = 30;
        self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        [self setViewConstraints];
    }
    return self;
}

- (void)configureView
{
    
}

- (void)setViewConstraints
{
    self.imageViewLoading.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelLoading.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *imageViewLoadingWidth = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.bounds.size.height];
    NSLayoutConstraint *imageViewLoadingHeight = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageViewLoading attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    NSLayoutConstraint *imageViewLoadingX = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-(self.bounds.size.height/2)];
    NSLayoutConstraint *imageViewLoadingY = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    NSLayoutConstraint *labelLoadingX = [NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    NSLayoutConstraint *labelLoadingY = [NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    NSLayoutConstraint *labelHeight = [NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.bounds.size.height];
    NSLayoutConstraint *labelMarginScreenRight = [NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:10];
    [self addConstraint:imageViewLoadingX];
    [self addConstraint:imageViewLoadingY];
    [self addConstraint:imageViewLoadingWidth];
    [self addConstraint:imageViewLoadingHeight];
    
    [self addConstraint:labelLoadingX];
    [self addConstraint:labelLoadingY];
    [self addConstraint:labelHeight];
    [self addConstraint:labelMarginScreenRight];
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset{
    if(contentOffset.y + self.scrollView.frame.size.height > self.frame.origin.y)
    {
        self.imageViewLoading.alpha = 1;
        self.labelLoading.alpha = 1;
        [self.imageViewLoading startAnimating];
    }
    else
    {
        [self.imageViewLoading stopAnimating];
    }
}

- (void)doSomethingWhenStartingAnimating
{
    
}
- (void)doSomethingWhenStopingAnimating
{
    self.imageViewLoading.alpha = 0;
    self.labelLoading.alpha = 0;
}

#pragma mark getters
- (UIImageView *)imageViewLoading
{
    if(!_imageViewLoading)
    {
        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        _imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        _imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewLoading.animationImages = self.pImgArrLoading;
        _imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)_imageViewLoading.animationImages.count);
        _imageViewLoading.alpha = 0;
        _imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageViewLoading];
    }
    return _imageViewLoading;
}
- (UILabel *)labelLoading
{
    if(!_labelLoading)
    {
        _labelLoading = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelLoading.text = @"loading...";
        [self addSubview:_labelLoading];
    }
    return _labelLoading;
}
- (UIActivityIndicatorView *)activityIndicatorView
{
    if(!_activityIndicatorView)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = self.bounds;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
