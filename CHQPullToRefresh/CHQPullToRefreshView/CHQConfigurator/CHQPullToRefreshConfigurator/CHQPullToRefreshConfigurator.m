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
#define kRefreshViewDefaultHeight 60
#define kRefreshViewDefaultHangingHeight 65
#define kRefreshViewDefaultTriggerHeight 60
#import "CHQPullToRefreshConfigurator.h"
float scrollViewWidth;
@interface CHQPullToRefreshConfigurator()

@property (nonatomic) bool hasNavigationBar;

@end
@implementation CHQPullToRefreshConfigurator

- (CHQPullToRefreshConfigurator *)initWithScrollView:(UIScrollView *)scrollView
{
    scrollViewWidth = scrollView.bounds.size.width;
    if([self findViewController:scrollView].navigationController.navigationBar)
    {
        self.hasNavigationBar = YES;
    }
    [self commitInit];
    return self;
}
- (void)commitInit
{
    if(self.hasNavigationBar)
    {
        _originalTopInset = 64;
        if(IS_IOS7)
        {
            if(IS_IPHONE)
            {
                self.portraitTopInset = 64.0;
                self.landscapeTopInset = 52.0;
            }
            else if(IS_IPAD)
            {
                self.portraitTopInset = 64.0;
                self.landscapeTopInset = 64.0;
            }
        }
        else if(IS_IOS8)
        {
            self.portraitTopInset = 64.0;
            self.originalTopInset = 64.0;
            if(IS_IPHONE)
            {
                if(IS_IPHONE6PLUS)
                    self.landscapeTopInset = 44.0;
                else
                {
                    self.landscapeTopInset = 32.0;
                }
            }
            else if(IS_IPAD)
            {
                self.landscapeTopInset = 64.0;
            }
        }
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            self.originalTopInset = self.landscapeTopInset;
        }
        else
        {
            self.originalTopInset = self.portraitTopInset;
        }
    }
    self.treatAsSubView = YES;
    self.shouldScrollWithScrollView = YES;
    self.backgroundColor = [UIColor clearColor];
    self.pullToRefreshViewHeight = kRefreshViewDefaultHeight;
    self.pullToRefreshViewTriggerHeight = kRefreshViewDefaultTriggerHeight;
    self.pullToRefreshViewHangingHeight = kRefreshViewDefaultHangingHeight;
    self.customiseFrame = NO;
    self.portraitFrame = CGRectMake(0, -self.pullToRefreshViewHeight, scrollViewWidth, self.pullToRefreshViewHeight);
    self.landscapeFrame = CGRectMake(0, -self.pullToRefreshViewHeight, scrollViewWidth, self.pullToRefreshViewHeight);
    self.progressImageName = @"run@2x.gif";
    self.refreshingImageName = @"run@2x.gif";
    self.animateDuration = 0.5;
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
- (void)setPortraitTopInset:(float)portraitTopInset
{
    _portraitTopInset = portraitTopInset;
    if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        self.originalTopInset = self.portraitTopInset;
    }
}
- (void)setLandscapeTopInset:(float)landscapeTopInset
{
    _landscapeTopInset = landscapeTopInset;
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        self.originalTopInset = self.landscapeTopInset;
    }
}

@end
