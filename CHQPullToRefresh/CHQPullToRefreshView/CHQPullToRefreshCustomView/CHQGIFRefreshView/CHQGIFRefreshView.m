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

- (id)initWithProgressImage:(UIImage *)progressImage RefreshingImage:(UIImage *)refreshingImage WithFrame:(CGRect)frame
{
    NSArray *progressImages = progressImage.images;
    NSArray *refreshingImages = refreshingImage.images;
    UIImage *image1 = progressImages.firstObject;
//    self = [super initWithFrame:CGRectMake(0, -image1.size.height, frame.size.width, image1.size.height)];
    self = [super initWithFrame:frame];
    if(self) {
        self.pImgArrProgress = progressImages;
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
    self.state = CHQPullToRefreshStateStopped;
    self.backgroundColor = [UIColor clearColor];
    
    NSAssert([self.pImgArrProgress.lastObject isKindOfClass:[UIImage class]], @"pImgArrProgress Array has object that is not image");
    self.imageViewProgress = [[UIImageView alloc] initWithImage:[self.pImgArrProgress lastObject]];
    self.imageViewProgress.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.imageViewProgress.frame = self.bounds;
    NSLog(@"%f, %f", self.imageViewProgress.frame.size.width, self.imageViewProgress.frame.size.height);
    self.imageViewProgress.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewProgress];
    
    if(self.pImgArrLoading==nil)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = self.bounds;
        [self addSubview:_activityIndicatorView];
    }
    else
    {
        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        self.imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        self.imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageViewLoading.frame = self.bounds;
        self.imageViewLoading.animationImages = self.pImgArrLoading;
        self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)self.imageViewLoading.animationImages.count);
        self.imageViewLoading.alpha = 0;
        self.imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewLoading];
    }
    self.alpha = 0;
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    CGFloat yOffset = contentOffset.y;
    CGFloat scrollOffsetThreshold = 0;
    scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
//    self.progress = ((yOffset+ self.originalTopInset + 10)/(scrollOffsetThreshold));
    self.progress = -yOffset / (self.originalTopInset + CHQPullToRefreshViewTriggerHeight);
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
//    else if([keyPath isEqualToString:@"contentSize"])
//    {
//        [self setNeedsLayout];
//        [self setNeedsDisplay];
//    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setFrameSizeByProgressImage];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
