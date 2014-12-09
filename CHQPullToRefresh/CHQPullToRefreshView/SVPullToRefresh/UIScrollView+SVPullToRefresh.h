//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>
#import "CHQPullToRefreshView.h"
#import "CHQPullToRefreshConfigurator.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )



@class SVPullToRefreshView;
typedef NS_ENUM(NSUInteger, CHQRefreshTheme)
{
    CHQRefreshThemeArrow = 0,
    CHQRefreshThemeSpiral,
    CHQRefreshThemeEatBeans,
    CHQRefreshThemePandulum,
    CHQRefreshThemeEllipsis,
    CHQRefreshThemeBalloon,
    CHQRefreshThemePinterest,
    
    CHQRefreshThemeDefault = CHQRefreshThemeArrow
};

@interface UIScrollView (SVPullToRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme WithConfigurator:(CHQPullToRefreshConfigurator *)configurator;
- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName WithConfigurator:(CHQPullToRefreshConfigurator *)configurator;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) CHQPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end
