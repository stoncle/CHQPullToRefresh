//
//  CHQPullToRefreshView.m
//  MyCollectionvView
//
//  Created by stoncle on 14-10-4.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//
#import "UIScrollView+SVPullToRefresh.h"
#import "CHQPullToRefreshView.h"
#import "CHQPullToRefreshConfigurator.h"

@interface CHQPullToRefreshView()
@property (nonatomic, assign) CGFloat PrevWidth;
@property (nonatomic) bool inSight;
//use for orientation change
@property (nonatomic) CGFloat refreshViewOffset;
@end

@implementation CHQPullToRefreshView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = CHQPullToRefreshStateStopped;
        self.wasTriggeredByUser = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
            if (self.isObserving) {
                [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [self.scrollView removeObserver:self forKeyPath:@"frame"];
                [self removeNotifications:self];
                self.isObserving = NO;
            }
    }
}

- (void)configureView
{
    
}

- (void)setConstraints
{
    
}

#pragma mark private methods
- (void)addNotifications:(CHQPullToRefreshView *)view
{
    if([view respondsToSelector:@selector(statusBarFrameOrOrientationChanged:)])
    {
        [[NSNotificationCenter defaultCenter]
         addObserver:view
         selector:@selector(statusBarFrameOrOrientationChanged:)
         name:UIApplicationDidChangeStatusBarOrientationNotification
         object:nil];
    }
}
- (void)removeNotifications:(CHQPullToRefreshView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:view name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
#pragma mark notificatios
- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            if(cNotEqualFloats( self.landscapeTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.originalTopInset = self.landscapeTopInset;
            if(self.customiseFrame)
            {
                if((!self.treatAsSubView && self.shouldScrollWithScrollView) || (self.appearsWhenReadyToFresh))
                {
                    CGRect newFrame = CGRectMake(self.landscapeFrame.origin.x, self.landscapeFrame.origin.y -self.scrollView.contentOffset.y - self.pullToRefreshViewHeight + self.refreshViewOffset, self.landscapeFrame.size.width, self.landscapeFrame.size.height);
                    [self setPullToRefreshViewFrame:newFrame Handler:nil];
                }
                else
                {
                    CGRect newFrame = self.landscapeFrame;
                    [self setPullToRefreshViewFrame:newFrame Handler:nil];
                }
            }
        }
        else
        {
            if(cNotEqualFloats( self.portraitTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.originalTopInset = self.portraitTopInset;
            if(self.customiseFrame)
            {
                if((!self.treatAsSubView && self.shouldScrollWithScrollView) || (self.appearsWhenReadyToFresh))
                {
                    CGRect newFrame = CGRectMake(self.portraitFrame.origin.x, self.portraitFrame.origin.y -self.scrollView.contentOffset.y - self.pullToRefreshViewHeight + self.refreshViewOffset, self.portraitFrame.size.width, self.portraitFrame.size.height);
                    [self setPullToRefreshViewFrame:newFrame Handler:nil];
                }
                else
                {
                    CGRect newFrame = self.portraitFrame;
                    [self setPullToRefreshViewFrame:newFrame Handler:nil];
                }
            }
        }
    });

    [self doSomethingWhenChangingOrientation];
}

- (void)doSomethingWhenChangingOrientation
{
    
}


#pragma mark - Scroll View

- (void)resetScrollViewContentInset:(void (^)(void))actionHandler{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets Handler:actionHandler];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.pullToRefreshViewHangingHeight);
    [self setScrollViewContentInset:currentInsets
                            Handler:nil];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset Handler:(void (^)(void))actionHandler{
    [UIView animateWithDuration:self.animateDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished){
                         if(actionHandler)
                         {
                             actionHandler();
                         }
                     }];
}

- (void)setPullToRefreshViewFrame:(CGRect)frame Handler:(void (^)(void))actionHandler{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         if(actionHandler)
                         {
                             actionHandler();
                         }
                     }];
}

- (void)setPullToRefreshViewAlpha:(CGFloat)alpha Handler:(void (^)(void))actionHandler{
    if(self.alpha == alpha)
    {
        return;
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = alpha;
                     }
                     completion:^(BOOL finished){
                         if(actionHandler)
                         {
                             actionHandler();
                         }
                     }];
}

- (void)doSomethingWhenLayoutSubviews
{
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.PrevWidth != PullToRefreshViewWidth && self.PrevWidth != 0)
    {
        [self configureView];
    }
    self.PrevWidth = PullToRefreshViewWidth;
    [self doSomethingWhenLayoutSubviews];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
    {
        if(self.superview != self.scrollView && self.shouldScrollWithScrollView)
        {
            [self changeFrameWithContentOffsetNew:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue] Old:[[change valueForKey:NSKeyValueChangeOldKey]CGPointValue]];
        }
        if([[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y >= -self.originalTopInset)
        {
            [self setPullToRefreshViewAlpha:0 Handler:nil];
            return;
        }
        [self setPullToRefreshViewAlpha:1 Handler:nil];
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
- (void)animatePullToRefreshViewInSight
{
    [UIView animateWithDuration:self.animateDuration animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.pullToRefreshViewHeight);
    }];
    self.refreshViewOffset = self.pullToRefreshViewHeight;
}
- (void)animatePullToRefreshViewOutSight
{
    [UIView animateWithDuration:self.animateDuration animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.pullToRefreshViewHeight);
    }];
    self.refreshViewOffset = 0;
}

- (void)doSomethingWhenScrolling:(CGPoint)contentOffset
{
    
}

- (void)changeFrameWithContentOffsetNew:(CGPoint)contentOffsetNew Old:(CGPoint)contentOffsetOld
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - (contentOffsetNew.y-contentOffsetOld.y), self.frame.size.width, self.frame.size.height);
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    [self doSomethingWhenScrolling:contentOffset];
    if(self.state != CHQPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        scrollOffsetThreshold = -self.pullToRefreshViewTriggerHeight - self.originalTopInset;
        if(!self.scrollView.isDragging && self.state == CHQPullToRefreshStateTriggered)
            self.state = CHQPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != CHQPullToRefreshStateStopped)
            self.state = CHQPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.pullToRefreshViewHangingHeight);
        contentInset = self.scrollView.contentInset;
        if(self.shouldAnimateWhenSettingContentInset)
        {
            self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
        }
    }
}




#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerPullToRefresh];
}

- (void)doSomethingWhenStartingAnimating
{
    
}

- (void)startAnimating{
    NSLog(@"refreshing...");
    [self doSomethingWhenStartingAnimating];
    
    if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.pullToRefreshViewHangingHeight) animated:YES];
        self.wasTriggeredByUser = NO;
    }
    else
        self.wasTriggeredByUser = YES;
    if(self.pullToRefreshActionHandler)
        self.pullToRefreshActionHandler();
    
}

- (void)doSomethingWhenStopingAnimating
{
    
}

- (void)stopAnimating {
    NSLog(@"refresh finished.");
    self.state = CHQPullToRefreshStateStopped;
    [self doSomethingWhenStopingAnimating];
    
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (void)setState:(CHQPullToRefreshState)newState {
    if(_state == newState)
        return;
    CHQPullToRefreshState prevState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self doSomethingWhenStateChanges];
    if(self.customiseFrame && self.appearsWhenReadyToFresh)
    {
        if((newState != CHQPullToRefreshStateTriggered && newState != CHQPullToRefreshStateLoading) && self.inSight)
        {
            [self animatePullToRefreshViewOutSight];
            self.inSight = NO;
        }
    }
    switch (newState) {
        case CHQPullToRefreshStateAll:
        case CHQPullToRefreshStateStopped:
            if(prevState == CHQPullToRefreshStateLoading)
            {
                if(self.shouldAnimateWhenSettingContentInset)
                {
                    [self resetScrollViewContentInset:^{
                        [self setPullToRefreshViewAlpha:0 Handler:nil];
                    }];
                }
            }
            break;
            
        case CHQPullToRefreshStateTriggered:
            if(self.customiseFrame && self.appearsWhenReadyToFresh && !self.inSight)
            {
                [self animatePullToRefreshViewInSight];
                self.inSight = YES;
            }
            NSLog(@"triggered.");
            break;
            
        case CHQPullToRefreshStateLoading:
            if(self.shouldAnimateWhenSettingContentInset)
            {
                [self setScrollViewContentInsetForLoading];
            }
            [self startAnimating];
            break;
    }
}

- (void)doSomethingWhenStateChanges
{
    
}

- (void)setConfigurator:(CHQPullToRefreshConfigurator *)configurator
{
    _configurator = configurator;
    self.originalTopInset = configurator.originalTopInset;
    self.portraitTopInset = configurator.portraitTopInset;
    self.landscapeTopInset = configurator.landscapeTopInset;
    self.pullToRefreshViewHeight = configurator.pullToRefreshViewHeight;
    self.pullToRefreshViewTriggerHeight = configurator.pullToRefreshViewTriggerHeight;
    self.pullToRefreshViewHangingHeight = configurator.pullToRefreshViewHangingHeight;
    self.backgroundColor = configurator.backgroundColor;
    self.shouldScrollWithScrollView = configurator.shouldScrollWithScrollView;
    self.animateDuration = configurator.animateDuration;
    self.treatAsSubView = configurator.treatAsSubView;
    self.customiseFrame = configurator.customiseFrame;
    self.portraitFrame = configurator.portraitFrame;
    self.landscapeFrame = configurator.landscapeFrame;
    self.appearsWhenReadyToFresh = configurator.appearsWhenReadyToFresh;
    self.shouldAnimateWhenSettingContentInset = configurator.shouldAnimateWhenSettingContentInset;
    self.belowScrollView = configurator.belowScrollView;
}



@end
