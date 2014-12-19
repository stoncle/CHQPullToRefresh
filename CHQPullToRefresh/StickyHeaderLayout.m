//
//  StickyHeaderLayout.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 12/17/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "StickyHeaderLayout.h"

@implementation StickyHeaderLayout

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *itemAttributes in attributes) {
        if (itemAttributes.representedElementKind==UICollectionElementKindSectionHeader) {
            CGRect frame = itemAttributes.frame;
            if(self.collectionView.contentOffset.y < 0)
            {
                frame.origin.y = self.collectionView.contentOffset.y;
            }
            itemAttributes.frame = frame;
            itemAttributes.zIndex = 1024;
        }
    }
    return attributes;
}

@end
