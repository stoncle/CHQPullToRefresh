//
//  CHQSpiralRefreshView.h
//  MyCollectionvView
//
//  Created by stoncle on 14-10-4.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHQPullToRefreshView.h"
typedef enum {
    SpiralPullToRefreshWaitAnimationRandom = 0,
    SpiralPullToRefreshWaitAnimationLinear,
    SpiralPullToRefreshWaitAnimationCircular
} SpiralPullToRefreshWaitAnimation;

@interface CHQSpiralRefreshView : CHQPullToRefreshView
@property (nonatomic, assign) SpiralPullToRefreshWaitAnimation waitingAnimation;
@property (nonatomic, strong) NSArray *particles;
@end
