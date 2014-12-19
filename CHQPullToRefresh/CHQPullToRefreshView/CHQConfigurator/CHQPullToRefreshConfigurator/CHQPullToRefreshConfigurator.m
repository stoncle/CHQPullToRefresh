//
//  CHQPullToRefreshConfigurator.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 12/8/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import "CHQPullToRefreshConfigurator.h"

@implementation CHQPullToRefreshConfigurator
@synthesize originalTopInset = _originalTopInset;
@synthesize portraitTopInset = _portraitTopInset;
@synthesize landscapeTopInset = _landscapeTopInset;
@synthesize frame = _frame;
@synthesize backgroundColor =_backgroundColor;
@synthesize pullToRefreshViewHeight = _pullToRefreshViewHeight;
@synthesize pullToRefreshViewTriggerHeight = _pullToRefreshViewTriggerHeight;
@synthesize pullToRefreshViewHangingHeight = _pullToRefreshViewHangingHeight;
@synthesize theme = _theme;
@synthesize progressImageName = _progressImageName;
@synthesize refreshingImageName = _refreshingImageName;

- (CHQPullToRefreshConfigurator *)initWithScrollView:(UIScrollView *)scrollView
{
    self.scrollView = scrollView;
    if([self findViewController:scrollView].navigationController.navigationBar)
    {
        _originalTopInset = 64;
        if(IS_IOS7)
        {
            if(IS_IPHONE)
            {
                _portraitTopInset = 64.0;
                _landscapeTopInset = 52.0;
            }
            else if(IS_IPAD)
            {
                _portraitTopInset = 64.0;
                _landscapeTopInset = 64.0;
            }
        }
        else if(IS_IOS8)
        {
            _portraitTopInset = 64.0;
            _originalTopInset = 64.0;
            if(IS_IPHONE)
            {
                if(IS_IPHONE6PLUS)
                    _landscapeTopInset = 44.0;
                else
                {
                    _landscapeTopInset = 32.0;
                }
            }
            else if(IS_IPAD)
            {
                _landscapeTopInset = 64.0;
            }
        }
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            _originalTopInset = _landscapeTopInset;
        }
        else
        {
            _originalTopInset = _portraitTopInset;
        }
    }
    return self;
}

#pragma mark getters
- (float)originalTopInset
{
    return _originalTopInset;
}
- (float)portraitTopInset
{
    return _portraitTopInset;
}
- (float)landscapeTopInset
{
    return _landscapeTopInset;
}
- (CGRect)frame
{
    if(CGRectEqualToRect(_frame, CGRectZero))
    {
        _frame = CGRectMake(0, -self.pullToRefreshViewHeight, self.scrollView.bounds.size.width, self.pullToRefreshViewHeight);
    }
    return _frame;
}
- (UIColor *)backgroundColor
{
    if(!_backgroundColor)
    {
        _backgroundColor = [UIColor clearColor];
    }
    return _backgroundColor;
}
- (float)pullToRefreshViewHeight
{
    if(_pullToRefreshViewHeight <= 0)
    {
        _pullToRefreshViewHeight = 60;
    }
    return _pullToRefreshViewHeight;
}
- (float)pullToRefreshViewTriggerHeight
{
    if(_pullToRefreshViewTriggerHeight <= 0)
    {
        _pullToRefreshViewTriggerHeight = 65;
    }
    return _pullToRefreshViewTriggerHeight;
}
- (float)pullToRefreshViewHangingHeight
{
    if(_pullToRefreshViewHangingHeight <= 0)
    {
        _pullToRefreshViewHangingHeight = 60;
    }
    return _pullToRefreshViewHangingHeight;
}
- (int)theme
{
    return _theme;
}
- (NSString *)progressImageName
{
    if(!_progressImageName)
    {
        return @"run@2x.gif";
    }
    return _progressImageName;
}
- (NSString *)refreshingImageName
{
    if(!_refreshingImageName)
    {
        return @"run@2x.gif";
    }
    return _refreshingImageName;
}

#pragma mark setters
- (void)setOriginalTopInset:(float)originalTopInset
{
    _originalTopInset = originalTopInset;
}
- (void)setPortraitTopInset:(float)portraitTopInset
{
    _portraitTopInset = portraitTopInset;
    if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        _originalTopInset = _portraitTopInset;
    }
}
- (void)setLandscapeTopInset:(float)landscapeTopInset
{
    _landscapeTopInset = landscapeTopInset;
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        _originalTopInset = _landscapeTopInset;
    }
}
- (void)setFrame:(CGRect)frame
{
    _frame = frame;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
}
- (void)setPullToRefreshViewHeight:(float)pullToRefreshViewHeight
{
    _pullToRefreshViewHeight = pullToRefreshViewHeight;
}
- (void)setPullToRefreshViewTriggerHeight:(float)pullToRefreshViewTriggerHeight
{
    _pullToRefreshViewTriggerHeight = pullToRefreshViewTriggerHeight;
}
- (void)setPullToRefreshViewHangingHeight:(float)pullToRefreshViewHangingHeight
{
    _pullToRefreshViewHangingHeight = pullToRefreshViewHangingHeight;
}
- (void)setTheme:(int)theme
{
    _theme = theme;
}
- (void)setProgressImageName:(NSString *)progressImageName
{
    _progressImageName = progressImageName;
}
- (void)setRefreshingImageName:(NSString *)refreshingImageName
{
    _refreshingImageName = refreshingImageName;
}

#pragma private methods
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
