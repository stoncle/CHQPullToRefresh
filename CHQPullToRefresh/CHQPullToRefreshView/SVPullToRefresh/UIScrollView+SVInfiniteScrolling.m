//
// UIScrollView+SVInfiniteScrolling.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CHQEllipsisScrollingView.h"


#import <objc/runtime.h>

static char UIScrollViewInfiniteScrollingView;
UIEdgeInsets scrollViewOriginalContentInsets;

@implementation UIScrollView (SVInfiniteScrolling)

@dynamic infiniteScrollingView;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    [self addInfiniteScrollingWithActionHandler:actionHandler WithCurrentTheme:CHQInfiniteScrollingThemeDefault];
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithCurrentTheme:(CHQInfiniteScrollingTheme)theme
{
    if(!self.infiniteScrollingView) {
        CHQInfiniteScrollingView *view;
        switch(theme)
        {
            case CHQInfiniteScrollingThemeEllipsis:
                view = [[CHQEllipsisScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, CHQInfiniteScrollingViewHeight)];
                break;
            default:
                NSLog(@"theme not found!");
                return;
        }
        if(view)
        {
            view.infiniteScrollingHandler = actionHandler;
            view.scrollView = self;
            [self addSubview:view];
            view.originalBottomInset = self.contentInset.bottom;
        }
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithLoadingImageName:(NSString *)loadingImageName
{
    if(!self.infiniteScrollingView) {
        UIImage *refreshingImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:loadingImageName]];
        CHQGIFScrollingView *view = [[CHQGIFScrollingView alloc] initWithRefreshingImage:refreshingImage WithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, CHQInfiniteScrollingViewHeight)];
        view.infiniteScrollingHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, view.originalBottomInset, self.contentInset.right);
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
}

- (void)changeCurrentInfiniteScrollingThemeToTheme:(CHQInfiniteScrollingTheme)theme
{
    if(!self.infiniteScrollingView) {
        CHQInfiniteScrollingView *prevView = self.infiniteScrollingView;
        [prevView removeFromSuperview];
        CHQInfiniteScrollingView *view;
        switch(theme)
        {
            case CHQInfiniteScrollingThemeEllipsis:
                view = [[CHQEllipsisScrollingView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, CHQInfiniteScrollingViewHeight)];
                break;
            default:
                NSLog(@"theme not found!");
                return;
        }
        if(view)
        {
            view.infiniteScrollingHandler = prevView.infiniteScrollingHandler;
            view.scrollView = self;
            [self addSubview:view];
            view.originalBottomInset = self.contentInset.bottom;
        }
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
    else
    {
        NSLog(@"You may need to call [aScrollView addPullToRefreshWithActionHandler:WithCurrentTheme:] first to add a refresh view before changing its theme.");
    }
}

- (void)triggerInfiniteScrolling {
    self.infiniteScrollingView.state = CHQInfiniteScrollingStateLoading;
}

- (void)setInfiniteScrollingView:(CHQInfiniteScrollingView *)infiniteScrollingView {
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             infiniteScrollingView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrollingView"];
}

- (CHQInfiniteScrollingView *)infiniteScrollingView {
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling {
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
    
    if(!showsInfiniteScrolling) {
      if (self.infiniteScrollingView.isObserving) {
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
        [self.infiniteScrollingView resetScrollViewContentInset];
        self.infiniteScrollingView.isObserving = NO;
      }
    }
    else {
      if (!self.infiniteScrollingView.isObserving) {
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self.infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
        self.infiniteScrollingView.isObserving = YES;
          
        [self.infiniteScrollingView setNeedsLayout];
        self.infiniteScrollingView.frame = CGRectMake(0, self.contentSize.height, self.infiniteScrollingView.bounds.size.width, CHQInfiniteScrollingViewHeight);
      }
    }
}

- (BOOL)showsInfiniteScrolling {
    return !self.infiniteScrollingView.hidden;
}

@end

