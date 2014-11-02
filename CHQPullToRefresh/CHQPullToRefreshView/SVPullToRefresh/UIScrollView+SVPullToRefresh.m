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


//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    [self addPullToRefreshWithActionHandler:actionHandler WithCurrentTheme:CHQRefreshThemeEatBeans];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQRefreshTheme)theme {
    
    if(!self.pullToRefreshView) {
        CHQPullToRefreshView *view;
        CGFloat yOrigin;
        yOrigin = -CHQPullToRefreshViewHeight;
        switch (theme) {
            case CHQRefreshThemeArrow:
                view = [[CHQArrowRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeSpiral:
                view = [[CHQSpiralRefreshView alloc]initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeEatBeans:
                view = [[CHQEatBeansRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemePandulum:
                view = [[CHQPandulumRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeEllipsis:
                view = [[CHQEllipsisRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeBalloon:
                view = [[CHQBalloonRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            default:
                NSLog(@"theme not found!");
                return;
                break;
        }
        if(view)
        {
            view.pullToRefreshActionHandler = actionHandler;
            view.scrollView = self;
            [view addNotifications:view];
            [self insertSubview:view atIndex:0];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                view.originalTopInset = self.contentInset.top;
            } else {
                //set to 64 if exists navigation bar, or any you want
                view.originalTopInset = 64;
            }
//            view.originalBottomInset = self.contentInset.bottom;
            self.pullToRefreshView = view;
            self.showsPullToRefresh = YES;
        }
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler WithProgressImageName:(NSString *)progressImageName RefreshingImageName:(NSString *)refreshingImageName
{
    if(!self.pullToRefreshView) {
        CHQPullToRefreshView *view;
        CGFloat yOrigin;
        yOrigin = -CHQPullToRefreshViewHeight;
            UIImage *progressImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:progressImageName]];
            UIImage *refreshingImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:refreshingImageName]];
        view = [[CHQGIFRefreshView alloc] initWithProgressImage:progressImage RefreshingImage:refreshingImage WithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
            view.pullToRefreshActionHandler = actionHandler;
            view.scrollView = self;
        view.backgroundColor = [UIColor whiteColor];
            
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                view.originalTopInset = self.contentInset.top;
            } else {
                //set to 64 if exists navigation bar, or any you want
                view.originalTopInset = 64;
            }
            //            view.originalBottomInset = self.contentInset.bottom;
            self.pullToRefreshView = view;
            self.showsPullToRefresh = YES;
        
        [self addSubview:view];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
    }
}

- (void)changeCurrentRefreshThemeToTheme:(CHQRefreshTheme)theme
{
    if(self.pullToRefreshView)
    {
        CHQPullToRefreshView *previousView = self.pullToRefreshView;
        [previousView removeNotifications:previousView];
        [previousView removeFromSuperview];
        CHQPullToRefreshView *view;
        CGFloat yOrigin;
        yOrigin = -CHQPullToRefreshViewHeight;
        switch (theme) {
            case CHQRefreshThemeArrow:
                view = [[CHQArrowRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeSpiral:
                view = [[CHQSpiralRefreshView alloc]initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeEatBeans:
                view = [[CHQEatBeansRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemePandulum:
                view = [[CHQPandulumRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeEllipsis:
                view = [[CHQEllipsisRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            case CHQRefreshThemeBalloon:
                view = [[CHQBalloonRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, CHQPullToRefreshViewHeight)];
                break;
            default:
                NSLog(@"theme not found!");
                return;
                break;
        }
        if(view)
        {
            view.pullToRefreshActionHandler = previousView.pullToRefreshActionHandler;
            view.scrollView = self;
            [view addNotifications:view];
            [self addSubview:view];
            
            view.originalTopInset = self.contentInset.top;
            self.pullToRefreshView = view;
            self.showsPullToRefresh = YES;
        }
    }
    else
    {
        NSLog(@"You may need to call [aScrollView addPullToRefreshWithActionHandler:WithCurrentTheme:] first to add a refresh view before changing its theme.");
    }
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
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

@end