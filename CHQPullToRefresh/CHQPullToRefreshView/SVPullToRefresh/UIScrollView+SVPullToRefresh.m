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
#import <objc/runtime.h>

#pragma mark - UIScrollView (SVPullToRefresh)

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    CHQPullToRefreshConfigurator *configurator = [[CHQPullToRefreshConfigurator alloc]initWithScrollView:self];
    [self addPullToRefreshWithActionHandler:actionHandler WithConfigurator:configurator];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithConfigurator:(CHQPullToRefreshConfigurator *)configurator
{
    CHQPullToRefreshView *view;
    CHQPullToRefreshView *previousView;
    CGRect frame = CGRectZero;
    UIImage *progressImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configurator.progressImageName]];
    UIImage *refreshingImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:configurator.refreshingImageName]];
    if(!self.pullToRefreshView) {
        if(configurator.customiseFrame)
        {
            CGRect portraitFrame = configurator.portraitFrame;
            CGRect landscapeFrame = configurator.landscapeFrame;
            if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
            {
                frame = landscapeFrame;
            }
            else
            {
                frame = portraitFrame;
            }
        }
        else
        {
            frame = CGRectMake(0, -configurator.pullToRefreshViewHeight, self.bounds.size.width, configurator.pullToRefreshViewHeight);
        }
    }
    else
    {
        previousView = self.pullToRefreshView;
        [previousView removeNotifications:previousView];
        frame = previousView.frame;
        [previousView removeFromSuperview];
    }
    switch (configurator.theme) {
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
        case CHQRefreshThemeGif:
            if(progressImage && refreshingImage)
            {
                view = [[CHQGIFRefreshView alloc] initWithProgressImage:progressImage RefreshingImage:refreshingImage WithFrame:frame];
            }
            else
            {
                NSLog(@"incorrect gif image");
                return;
            }
            break;
        default:
            NSLog(@"theme not found!");
            return;
    }
    if(view)
    {
        view.scrollView = self;
        view.configurator = configurator;
        view.pullToRefreshActionHandler = actionHandler;
        [view addNotifications:view];
        view.originalBottomInset = self.contentInset.bottom;
        if(view.treatAsSubView)
        {
            [self addSubview:view];
        }
        else
        {
            if(view.belowScrollView)
            {
                [self.superview insertSubview:view belowSubview:self];
            }
            else
            {
                [self.superview insertSubview:view aboveSubview:self];
            }
        }
        
        //since the following code acts differently in different ways the navigation bar added(by code or by storyboard, decided to note this)
        //            self.contentInset = UIEdgeInsetsMake(view.originalTopInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
        self.contentInset = UIEdgeInsetsMake(view.originalTopInset, self.contentInset.left, view.originalBottomInset, self.contentInset.right);
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
        
    }
}

- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme
{
    if(self.pullToRefreshView)
    {
        CHQPullToRefreshView *previousView = self.pullToRefreshView;
        [previousView removeNotifications:previousView];
        CGRect frame;
        frame = previousView.frame;
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
            self.pullToRefreshView = view;
            if(view.treatAsSubView)
            {
                [self addSubview:view];
            }
            else
            {
                if(view.belowScrollView)
                {
                    [self.superview insertSubview:view belowSubview:self];
                }
                else
                {
                    [self.superview insertSubview:view aboveSubview:self];
                }
            }
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
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset :nil];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
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
