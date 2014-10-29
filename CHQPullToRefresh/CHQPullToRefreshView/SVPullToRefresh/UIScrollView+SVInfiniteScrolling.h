//
// UIScrollView+SVInfiniteScrolling.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <UIKit/UIKit.h>
#import "CHQInfiniteScrollingView.h"
#import "CHQGIFScrollingView.h"


@interface UIScrollView (SVInfiniteScrolling)

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler WithLoadingImageName:(NSString *)loadingImageName;
- (void)triggerInfiniteScrolling;

@property (nonatomic, strong, readonly) CHQInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end



