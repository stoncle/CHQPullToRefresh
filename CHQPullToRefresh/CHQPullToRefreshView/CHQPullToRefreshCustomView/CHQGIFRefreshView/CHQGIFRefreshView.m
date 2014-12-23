//
//  CHQGIFRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/25/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQGIFRefreshView.h"
@interface CHQGIFRefreshView()
@property (nonatomic,strong) UIImageView *imageViewProgress;
@property (nonatomic,strong) UIImageView *imageViewLoading;

@property (nonatomic,strong) NSArray *pImgArrProgress;
@property (nonatomic,strong) NSArray *pImgArrLoading;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;  //Loading Indicator
@property (nonatomic, assign) NSInteger LoadingFrameRate;
@property (nonatomic, assign) double progress;
@end

@implementation CHQGIFRefreshView
@synthesize imageViewProgress = _imageViewProgress;
@synthesize imageViewLoading = _imageViewLoading;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithProgressImage:(UIImage *)progressImage RefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame
{
    NSArray *progressImages = progressImage.images;
    NSArray *refreshingImages = refreshingImage.images;
    self = [super initWithFrame:frame];
    if(self) {
        self.pImgArrProgress = progressImages;
        self.pImgArrLoading = refreshingImages;
        [self commonInit];
        [self configureView];
    }
    return self;
}

- (void)commonInit
{
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    self.contentMode = UIViewContentModeRedraw;
    //number of frame per second
    self.LoadingFrameRate = 60;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    
    if(![self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]])
    {
        NSLog(@"loading image not a gif image.");
    }
    self.imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
    self.imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageViewLoading.frame = self.bounds;
    self.imageViewLoading.animationImages = self.pImgArrLoading;
    self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)_imageViewLoading.animationImages.count);
    self.imageViewLoading.alpha = 0;
    self.imageViewLoading.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewLoading];
    
    if(![_pImgArrProgress.lastObject isKindOfClass:[UIImage class]])
    {
        NSLog(@"progress image not an gif image.");
    }
    self.imageViewProgress = [[UIImageView alloc] initWithImage:[self.pImgArrProgress lastObject]];
    self.imageViewProgress.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.imageViewProgress.frame = self.bounds;
    self.imageViewProgress.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageViewProgress];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.frame = self.bounds;
    [self addSubview:self.activityIndicatorView];
}

- (void)configureView
{
    
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    CGFloat yOffset = contentOffset.y;
    CGFloat scrollOffsetThreshold = 0;
    scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
    self.progress = -yOffset / (self.originalTopInset + self.pullToRefreshViewTriggerHeight);
}

#pragma mark - property
- (void)setProgress:(double)progress
{
    static double prevProgress;
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    if(self.showAlphaTransition)
    {
        self.alpha = 1.0 * progress;
    }
    else
    {
        CGFloat alphaValue = 1.0 * progress *5;
        if(alphaValue > 1.0)
            alphaValue = 1.0f;
        self.alpha = alphaValue;
    }
    if (progress >= 0 && progress <=1.0) {
        NSInteger index = (NSInteger)roundf((self.pImgArrProgress.count ) * progress);
        if(index ==0)
        {
            self.imageViewProgress.image = nil;
        }
        else
        {
            self.imageViewProgress.image = [self.pImgArrProgress objectAtIndex:index-1];
        }
    }
    _progress = progress;
    prevProgress = progress;
}

- (void)setIsVariableSize:(BOOL)isVariableSize
{
    _isVariableSize = isVariableSize;
    if(!_isVariableSize)
    {
        [self setFrameSizeByProgressImage];
    }
}

- (void)setFrameSizeByProgressImage
{
    UIImage *image1 = self.pImgArrProgress.lastObject;
    if(image1)
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
}
- (void)setFrameSizeByLoadingImage
{
    UIImage *image1 = self.pImgArrLoading.lastObject;
    if(image1)
    {
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
    }
}

- (void)doSomethingWhenStartingAnimating
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imageViewProgress.alpha = 0.0;
        if(self.isVariableSize)
        {
            [self setFrameSizeByLoadingImage];
        }
        if(self.pImgArrLoading.count>0)
        {
            self.imageViewLoading.alpha = 1.0;
        }
        else
        {
            self.activityIndicatorView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    
    if(self.pImgArrLoading.count>0)
    {
        [self.imageViewLoading startAnimating];
    }
    else
    {
        [self.activityIndicatorView startAnimating];
    }
}
- (void)doSomethingWhenStopingAnimating
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        if(self.pImgArrLoading.count>0)
        {
            
        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
    } completion:^(BOOL finished) {
        
        if(self.pImgArrLoading.count>0)
        {
            [self.imageViewLoading stopAnimating];
            self.imageViewLoading.alpha = 0.0;
        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0;
        }
        
        [self resetScrollViewContentInset:^{
            self.imageViewProgress.alpha = 1.0;
            if(self.isVariableSize)
                [self setFrameSizeByProgressImage];
        }];
    }];
}
- (void)doSomethingWhenChangingOrientation
{
    
}

@end
