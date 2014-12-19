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

// public properties
@synthesize arrowColor, textColor, activityIndicatorViewColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter;

@synthesize arrow = _arrow;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;


- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.textColor = [UIColor darkGrayColor];
        self.showsDateLabel = NO;
        
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Pull to refresh...",),
                       NSLocalizedString(@"Release to refresh...",),
                       NSLocalizedString(@"Loading...",),
                       nil];
        
        self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    return self;
}

- (void)configureView
{
    NSLog(@"%f", PullToRefreshViewWidth);
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

#pragma mark - Getters

- (CHQPullToRefreshArrow *)arrow {
    if(!_arrow) {
        _arrow = [[CHQPullToRefreshArrow alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrow];
    }
    return _arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = textColor;
        [self addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)dateLabel {
    return self.showsDateLabel ? self.subtitleLabel : nil;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIColor *)arrowColor {
    return self.arrow.arrowColor; // pass through
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (UIColor *)activityIndicatorViewColor {
    return self.activityIndicatorView.color;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setArrowColor:(UIColor *)newArrowColor {
    self.arrow.arrowColor = newArrowColor; // pass through
    [self.arrow setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(CHQPullToRefreshState)state {
    if(!title)
        title = @"";
    
    if(state == CHQPullToRefreshStateAll)
        [self.titles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[title, title, title]];
    else
        [self.titles replaceObjectAtIndex:state withObject:title];
    
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle forState:(CHQPullToRefreshState)state {
    if(!subtitle)
        subtitle = @"";
    
    if(state == CHQPullToRefreshStateAll)
        [self.subtitles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[subtitle, subtitle, subtitle]];
    else
        [self.subtitles replaceObjectAtIndex:state withObject:subtitle];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
    self.subtitleLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewColor:(UIColor *)color {
    self.activityIndicatorView.color = color;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.showsDateLabel = YES;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter {
    dateFormatter = newDateFormatter;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
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

