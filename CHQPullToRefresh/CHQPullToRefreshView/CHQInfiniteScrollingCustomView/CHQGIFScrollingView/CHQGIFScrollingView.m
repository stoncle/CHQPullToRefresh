//
//  CHQGIFScrollingView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/29/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQGIFScrollingView.h"
@interface CHQGIFScrollingView()
@property (nonatomic,strong) UIImageView *imageViewLoading;
@property (nonatomic,strong) NSArray *pImgArrLoading;
@property (nonatomic, assign) NSInteger LoadingFrameRate;
@end

@implementation CHQGIFScrollingView

- (id)initWithRefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame
{
    NSArray *refreshingImages = refreshingImage.images;
    self = [super initWithFrame:frame];
    if(self) {
        self.pImgArrLoading = refreshingImages;
        //number of frame per second
        self.LoadingFrameRate = 30;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    self.contentMode = UIViewContentModeRedraw;
    self.state = CHQInfiniteScrollingStateStopped;
    self.backgroundColor = [UIColor clearColor];
    
    
    if(self.pImgArrLoading==nil)
    {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        self.activityIndicatorView.hidesWhenStopped = YES;
        self.activityIndicatorView.frame = self.bounds;
        NSLog(@"%f,%f",self.bounds.origin.x, self.bounds.origin.y);
        [self addSubview:self.activityIndicatorView];
    }
    else
    {
        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        self.imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        self.imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewLoading.animationImages = self.pImgArrLoading;
        self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)self.imageViewLoading.animationImages.count);
        self.imageViewLoading.alpha = 0;
        self.imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewLoading];
        NSLog(@"%f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    [self setViewConstraints];
    NSLog(@"%f, %f, %f, %f", self.imageViewLoading.frame.origin.x, self.imageViewLoading.frame.origin.y, self.imageViewLoading.frame.size.width, self.imageViewLoading.frame.size.height);
//    self.alpha = 0;
}

- (void)setViewConstraints
{
    _imageViewLoading.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *imageViewLoadingWidth = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.bounds.size.height];
    NSLayoutConstraint *imageViewLoadingHeight = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageViewLoading attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    NSLayoutConstraint *imageViewLoadingX = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-(self.bounds.size.height/2)];
    NSLayoutConstraint *imageViewLoadingY = [NSLayoutConstraint constraintWithItem:self.imageViewLoading attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [self addConstraint:imageViewLoadingX];
    [self addConstraint:imageViewLoadingY];
    [self addConstraint:imageViewLoadingWidth];
    [self addConstraint:imageViewLoadingHeight];
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset{
    if(contentOffset.y + self.scrollView.frame.size.height > self.frame.origin.y)
    {
        self.imageViewLoading.alpha = 1;
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
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
