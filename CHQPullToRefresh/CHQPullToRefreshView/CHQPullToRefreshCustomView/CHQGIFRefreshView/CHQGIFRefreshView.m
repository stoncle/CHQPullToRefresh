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
        self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
        self.contentMode = UIViewContentModeRedraw;
        //number of frame per second
        self.LoadingFrameRate = 30;
    }
    return self;
}

- (void)configureView
{
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
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
        //Animation
//        NSLog(@"%lu", (unsigned long)self.pImgArrProgress.count);
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
//    NSLog(@"%@", self.scrollView);
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
#pragma mark getters
- (UIImageView *)imageViewLoading
{
    if(!_imageViewLoading)
    {
        if(![self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]])
        {
            NSLog(@"loading image not a gif image.");
        }
//        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        _imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        _imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageViewLoading.frame = self.bounds;
        _imageViewLoading.animationImages = self.pImgArrLoading;
        _imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)_imageViewLoading.animationImages.count);
        _imageViewLoading.alpha = 0;
        _imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageViewLoading];
    }
    return _imageViewLoading;
}
- (UIImageView *)imageViewProgress
{
    if(!_imageViewProgress)
    {
        if(![_pImgArrProgress.lastObject isKindOfClass:[UIImage class]])
        {
            NSLog(@"progress image not an gif image.");
        }
//        NSAssert([_pImgArrProgress.lastObject isKindOfClass:[UIImage class]], @"pImgArrProgress Array has object that is not image");
        _imageViewProgress = [[UIImageView alloc] initWithImage:[self.pImgArrProgress lastObject]];
        _imageViewProgress.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        _imageViewProgress.frame = self.bounds;
//        NSLog(@"%f, %f", _imageViewProgress.frame.size.width, _imageViewProgress.frame.size.height);
        _imageViewProgress.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageViewProgress];
    }
    return _imageViewProgress;
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
