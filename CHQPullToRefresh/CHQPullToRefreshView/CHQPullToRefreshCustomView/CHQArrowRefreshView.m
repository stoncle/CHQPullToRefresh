//
//  CHQArrowRefreshView.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/6/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "CHQArrowRefreshView.h"
#import "UIScrollView+SVPullToRefresh.h"



@interface CHQPullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end
@interface CHQArrowRefreshView ()

@property (nonatomic, strong) CHQPullToRefreshArrow *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsDateLabel;

- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end

@implementation CHQArrowRefreshView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self commonInit];
        [self configureView];
    }
    return self;
}

- (void)commonInit
{
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.textColor = [UIColor darkGrayColor];
    self.showsDateLabel = NO;
    
    self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Pull to refresh...",),
                   NSLocalizedString(@"Release to refresh...",),
                   NSLocalizedString(@"Loading...",),
                   nil];
    
    self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    
    self.arrow = [[CHQPullToRefreshArrow alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
    self.arrow.backgroundColor = [UIColor clearColor];
    [self addSubview:self.arrow];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:self.activityIndicatorView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
    self.titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = self.textColor;
    [self addSubview:self.titleLabel];
}

- (void)configureView
{
    CGFloat leftViewWidth = MAX(self.arrow.bounds.size.width,self.activityIndicatorView.bounds.size.width);
    
    CGFloat margin = 10;
    CGFloat marginY = 2;
    CGFloat labelMaxWidth = PullToRefreshViewWidth - margin - leftViewWidth;
    
    
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:CGSizeMake(labelMaxWidth,self.titleLabel.font.lineHeight)
                                            lineBreakMode:self.titleLabel.lineBreakMode];
    
    
    CGSize subtitleSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                              constrainedToSize:CGSizeMake(labelMaxWidth,self.subtitleLabel.font.lineHeight)
                                                  lineBreakMode:self.subtitleLabel.lineBreakMode];
    
    CGFloat maxLabelWidth = MAX(titleSize.width,subtitleSize.width);
    
    CGFloat totalMaxWidth;
    if (maxLabelWidth) {
        totalMaxWidth = leftViewWidth + margin + maxLabelWidth;
    } else {
        totalMaxWidth = leftViewWidth + maxLabelWidth;
    }
    
    CGFloat labelX = (PullToRefreshViewWidth / 2) - (totalMaxWidth / 2) + leftViewWidth + margin;
    
    if(subtitleSize.height > 0){
        CGFloat totalHeight = titleSize.height + subtitleSize.height + marginY;
        CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
        
        CGFloat titleY = minY;
        self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, PullToRefreshViewWidth-labelX, titleSize.height));
        self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, PullToRefreshViewWidth-labelX, subtitleSize.height));
    }else{
        CGFloat totalHeight = titleSize.height;
        CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
        
        CGFloat titleY = minY;
        self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, PullToRefreshViewWidth-labelX, titleSize.height));
        self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, PullToRefreshViewWidth-labelX, subtitleSize.height));
    }
    
    CGFloat arrowX = (PullToRefreshViewWidth / 2) - (totalMaxWidth / 2) + (leftViewWidth - self.arrow.bounds.size.width) / 2;
    self.arrow.frame = CGRectMake(arrowX,
                                  (self.bounds.size.height / 2) - (self.arrow.bounds.size.height / 2),
                                  self.arrow.bounds.size.width,
                                  self.arrow.bounds.size.height);
    self.activityIndicatorView.center = self.arrow.center;
}

- (void)setLabelContent
{
    self.titleLabel.text = [self.titles objectAtIndex:self.state];
    
    NSString *subtitle = [self.subtitles objectAtIndex:self.state];
    self.subtitleLabel.text = subtitle.length > 0 ? subtitle : nil;
    switch (self.state) {
        case CHQPullToRefreshStateAll:
        case CHQPullToRefreshStateStopped:
            self.arrow.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self rotateArrow:0 hide:NO];
            break;
            
        case CHQPullToRefreshStateTriggered:
            [self rotateArrow:(float)M_PI hide:NO];
            break;
            
        case CHQPullToRefreshStateLoading:
            [self.activityIndicatorView startAnimating];
            [self rotateArrow:0 hide:YES];
            break;
    }
}

- (void)doSomethingWhenLayoutSubviews
{
    
}

- (void)doSomethingWhenChangingOrientation
{
    [self configureView];
}

- (void)doSomethingWhenStateChanges
{
    [self setLabelContent];
}

#pragma mark -

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}

@end


#pragma mark - CHQPullToRefreshArrow

@implementation CHQPullToRefreshArrow
@synthesize arrowColor;

- (UIColor *)arrowColor {
    if (arrowColor) return arrowColor;
    return [UIColor grayColor]; // default Color
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // the rects above the arrow
    CGContextAddRect(c, CGRectMake(5, 0, 12, 4)); // to-do: use dynamic points
    CGContextAddRect(c, CGRectMake(5, 6, 12, 4)); // currently fixed size: 22 x 48pt
    CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
    
    // the arrow
    CGContextMoveToPoint(c, 0, 34);
    CGContextAddLineToPoint(c, 11, 48);
    CGContextAddLineToPoint(c, 22, 34);
    CGContextAddLineToPoint(c, 0, 34);
    CGContextClosePath(c);
    
    CGContextSaveGState(c);
    CGContextClip(c);
    
    // Gradient Declaration
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat alphaGradientLocations[] = {0, 0.8f};
    
    CGGradientRef alphaGradient = nil;
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 5){
        NSArray* alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)alphaGradientColors, alphaGradientLocations);
    }else{
        const CGFloat * components = CGColorGetComponents([self.arrowColor CGColor]);
        size_t numComponents = CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        switch(numComponents){
            case 2:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
            case 4:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,alphaGradientLocations,2);
    }
    
    
    CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    
    CGContextRestoreGState(c);
    
    CGGradientRelease(alphaGradient);
    CGColorSpaceRelease(colorSpace);
}
@end

