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

- (CHQPullToRefreshConfigurator *)initWithScrollView:(UIScrollView *)scrollView
{
    _originalTopInset = 60;
    if([self findViewController:scrollView].navigationController.navigationBar)
    {
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
