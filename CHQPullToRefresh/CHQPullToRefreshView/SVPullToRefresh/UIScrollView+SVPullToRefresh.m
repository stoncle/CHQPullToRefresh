//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "CHQSpiralRefreshView.h"
#import "CHQArrowRefreshView.h"
#import "CHQEatBeansRefreshView.h"
#import "CHQGIFRefreshView.h"
#import "CHQPandulumRefreshView.h"
#import "CHQEllipsisRefreshView.h"
#import "CHQBalloonRefreshView.h"
#import "CHQPinterestRefreshView.h"
#import <objc/runtime.h>




//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    [self addPullToRefreshWithActionHandler:actionHandler WithCurrentTheme:CHQRefreshThemeDefault];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme
{
    CHQPullToRefreshConfigurator *configurator = [[CHQPullToRefreshConfigurator alloc]initWithScrollView:self];
    [self addPullToRefreshWithActionHandler:actionHandler WithCurrentTheme:theme WithConfigurator:configurator];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme WithConfigurator:(CHQPullToRefreshConfigurator *)configurator{
    
    if(!self.pullToRefreshView) {
        CHQPullToRefreshView *view;
        NSLog(@"%f,%f,%f,%f", configurator.frame.origin.x, configurator.frame.origin.y,configurator.frame.size.width, configurator.frame.size.height);
        switch (theme) {
            case CHQRefreshThemeArrow:
                view = [[CHQArrowRefreshView alloc] initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemeSpiral:
                view = [[CHQSpiralRefreshView alloc]initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemeEatBeans:
                view = [[CHQEatBeansRefreshView alloc] initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemePandulum:
                view = [[CHQPandulumRefreshView alloc] initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemeEllipsis:
                view = [[CHQEllipsisRefreshView alloc] initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemeBalloon:
                view = [[CHQBalloonRefreshView alloc] initWithFrame:configurator.frame];
                break;
            case CHQRefreshThemePinterest:
                view = [[CHQPinterestRefreshView alloc] initWithFrame:configurator.frame];
                break;
            default:
                NSLog(@"theme not found!");
                return;
        }
        if(view)
        {
            view.configurator = configurator;
            view.pullToRefreshActionHandler = actionHandler;
            view.scrollView = self;
            
            [view addNotifications:view];
            [self.superview insertSubview:view belowSubview:self];
            view.originalTopInset = configurator.originalTopInset;
            view.portraitTopInset = configurator.portraitTopInset;
            view.landscapeTopInset = configurator.landscapeTopInset;
            view.pullToRefreshViewHeight = configurator.pullToRefreshViewHeight;
            view.pullToRefreshViewTriggerHeight = configurator.pullToRefreshViewTriggerHeight;
            view.pullToRefreshViewHangingHeight = configurator.pullToRefreshViewHangingHeight;
            view.backgroundColor = configurator.backgroundColor;
            view.originalBottomInset = self.contentInset.bottom;
            //since the following code acts differently in different ways the navigation bar added(by code or by storyboard, decided to note this)
//            self.contentInset = UIEdgeInsetsMake(view.originalTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
            self.pullToRefreshView = view;
            self.showsPullToRefresh = YES;
        }
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName
{
    CHQPullToRefreshConfigurator *configurator = [[CHQPullToRefreshConfigurator alloc]initWithScrollView:self];
    [self addPullToRefreshWithActionHandler:actionHandler WithProgressImageName:progressImageName RefreshingImageName:refreshingImageName WithConfigurator:configurator];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName WithConfigurator:(CHQPullToRefreshConfigurator *)configurator
{
    if(!self.pullToRefreshView) {
        CHQPullToRefreshView *view;
            UIImage *progressImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:progressImageName]];
            UIImage *refreshingImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:refreshingImageName]];
        view = [[CHQGIFRefreshView alloc] initWithProgressImage:progressImage RefreshingImage:refreshingImage WithFrame:configurator.frame];
            view.pullToRefreshActionHandler = actionHandler;
            view.scrollView = self;
        view.backgroundColor = [UIColor whiteColor];
        view.configurator = configurator;
        view.originalTopInset = configurator.originalTopInset;
        view.portraitTopInset = configurator.portraitTopInset;
        view.landscapeTopInset = configurator.landscapeTopInset;
        view.pullToRefreshViewHeight = configurator.pullToRefreshViewHeight;
        view.pullToRefreshViewTriggerHeight = configurator.pullToRefreshViewTriggerHeight;
        view.pullToRefreshViewHangingHeight = configurator.pullToRefreshViewHangingHeight;
        view.backgroundColor = configurator.backgroundColor;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
//        self.contentInset = UIEdgeInsetsMake(view.originalTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
//        [self addSubview:view];
        [self.superview insertSubview:view belowSubview:self];

//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
    }
}

- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme
{
    if(self.pullToRefreshView)
    {
        CHQPullToRefreshView *previousView = self.pullToRefreshView;
        [previousView removeNotifications:previousView];
        CGRect frame = previousView.frame;
        NSLog(@"%@", previousView.superview);
        [previousView removeFromSuperview];
        
        CHQPullToRefreshView *view;
        switch (theme) {
            case CHQRefreshThemeArrow:
                view = [[CHQArrowRefreshView alloc] initWithFrame:frame];
                break;
            case CHQRefreshThemeSpiral:
                view = [[CHQSpiralRefreshView alloc]initWithFrame:frame];
                break;
            case CHQRefreshThemeEatBeans:
                view = [[CHQEatBeansRefreshView alloc] initWithFrame:frame];
                break;
            case CHQRefreshThemePandulum:
                view = [[CHQPandulumRefreshView alloc] initWithFrame:frame];
                break;
            case CHQRefreshThemeEllipsis:
                view = [[CHQEllipsisRefreshView alloc] initWithFrame:frame];
                break;
            case CHQRefreshThemeBalloon:
                view = [[CHQBalloonRefreshView alloc] initWithFrame:frame];
                break;
            case CHQRefreshThemePinterest:
                view = [[CHQPinterestRefreshView alloc] initWithFrame:frame];
                break;
            default:
                NSLog(@"theme not found!");
                return;
                break;
        }
        if(view)
        {
            view.configurator = previousView.configurator;
            view.pullToRefreshActionHandler = previousView.pullToRefreshActionHandler;
            view.scrollView = self;
            [view addNotifications:view];
            [self.superview insertSubview:view belowSubview:self];
//
//            [self addSubview:view];
            self.pullToRefreshView = view;
            view.originalTopInset = view.configurator.originalTopInset;
            view.portraitTopInset = view.configurator.portraitTopInset;
            view.landscapeTopInset = view.configurator.landscapeTopInset;
            view.pullToRefreshViewHeight = view.configurator.pullToRefreshViewHeight;
            view.pullToRefreshViewTriggerHeight = view.configurator.pullToRefreshViewTriggerHeight;
            view.pullToRefreshViewHangingHeight = view.configurator.pullToRefreshViewHangingHeight;
            view.backgroundColor = view.configurator.backgroundColor;
//            self.contentInset = UIEdgeInsetsMake(view.originalTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
            self.showsPullToRefresh = YES;
        }
    }
    else
    {
        NSLog(@"You may need to call [aScrollView addPullToRefreshWithActionHandler:WithCurrentTheme:] first to add a refresh view before changing its theme.");
    }
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = CHQPullToRefreshStateTriggered;
    self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top - 60);
    [self.pullToRefreshView startAnimating];
}

- (void)setPullToRefreshView:(CHQPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}

- (CHQPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
//            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset :nil];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
            
//            CGFloat yOrigin = 0;
//            yOrigin = -SVPullToRefreshViewHeight;
//            
//            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

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
