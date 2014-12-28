//
//  StickyHeaderLayout.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 12/17/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "StickyHeaderLayout.h"
#import "SVPullToRefresh.h"
@interface StickyHeaderLayout()
@property NSDictionary *layoutInfo;

- (CGRect)cellFrameAtIndexPath:(NSIndexPath *)indexPath;

@property NSInteger totalRowNum;
@end

@implementation StickyHeaderLayout

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.numberOfColumn=3;
    self.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    self.height=312;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.headerHeight = self.collectionView.bounds.size.height/4;
    self.totalRowNum=0;
    
    NSInteger sectionNum=[self.collectionView numberOfSections];
    
    NSMutableDictionary *cellLayoutInfo=[NSMutableDictionary dictionary];
    NSMutableDictionary *supplementaryLayoutInfo = [NSMutableDictionary dictionary];
    for (NSInteger section=0; section < sectionNum; section++) {
        NSInteger itemNum=[self.collectionView numberOfItemsInSection:section];
        
        self.totalRowNum += (itemNum + 2) / self.numberOfColumn;
        
        for (NSInteger item=0; item < itemNum; item++) {
            
            NSIndexPath *itemPath=[NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttribute=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemPath];
            
            itemAttribute.frame=[self cellFrameAtIndexPath:itemPath];
            
            [cellLayoutInfo setObject:itemAttribute forKey:itemPath];
        }
    }
    NSIndexPath *headerPath=[NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *headerAttribute=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerPath];
    headerAttribute.frame = [self supplementaryFrameAtIndexPath:headerPath];
    [supplementaryLayoutInfo setObject:headerAttribute forKey:headerPath];
    self.layoutInfo = [NSDictionary dictionaryWithObjectsAndKeys:cellLayoutInfo, @"cellLayout", supplementaryLayoutInfo, @"supplementaryLayout", nil];
}

- (CGSize)collectionViewContentSize
{
    CGFloat lineSpacing=5;
    
    CGFloat width=self.collectionView.bounds.size.width;
    CGFloat height=self.totalRowNum * (self.height + lineSpacing);
    CGSize size = CGSizeMake(width, height + self.headerHeight);
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *rectLayoutAttributes=[NSMutableArray array];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *layoutType, NSDictionary *typeLayoutInfo, BOOL *stop) {
        [typeLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
            
            if(CGRectIntersectsRect(rect, attribute.frame)){
                [rectLayoutAttributes addObject:attribute];
            }
        }];
    }];
    for (UICollectionViewLayoutAttributes *itemAttributes in rectLayoutAttributes) {
        if (itemAttributes.representedElementKind==UICollectionElementKindSectionHeader) {
            CGRect frame = itemAttributes.frame;
            if(self.collectionView.contentOffset.y < -self.collectionView.pullToRefreshView.originalTopInset)
            {
                frame.origin.y = self.collectionView.contentOffset.y + self.collectionView.pullToRefreshView.originalTopInset;
            }
            itemAttributes.frame = frame;
            itemAttributes.zIndex = 1024;
        }
    }
    return rectLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellLayout=[self.layoutInfo objectForKey:@"cellLayout"];
    UICollectionViewLayoutAttributes *attribute=[cellLayout objectForKey:indexPath];
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *supplementaryLayout=[self.layoutInfo objectForKey:@"supplementaryLayout"];
    UICollectionViewLayoutAttributes *attribute=[supplementaryLayout objectForKey:indexPath];
    return attribute;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
//{
//    NSIndexPath *firstVisibleIndexPath=[self visibleIndexPathFirst];
//    
//    UICollectionViewLayoutAttributes *firstVisibleAttributes=[self layoutAttributesForItemAtIndexPath:firstVisibleIndexPath];
//    CGFloat offsetY=firstVisibleAttributes.frame.origin.y;
//    
//    CGPoint targetPoint=CGPointMake(0, offsetY);
//    return targetPoint;
//}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *originAttribute = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    UICollectionViewLayoutAttributes *attribute=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    attribute.frame=originAttribute.frame;
    attribute.size = CGSizeZero;
//    attribute.transform = CGAffineTransformMakeScale(0, 0);
    return attribute;
}
#pragma mark - Private

- (CGRect)cellFrameAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat interItemSpacing;
    CGFloat lineSpacing;
    
    CGFloat width;
    CGFloat height;
    interItemSpacing=lineSpacing=5;
    
    width = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.numberOfColumn - 1) * interItemSpacing) / self.numberOfColumn;
    
    height = self.height;
    
    NSInteger column=indexPath.row % self.numberOfColumn;
    NSInteger row=indexPath.row / self.numberOfColumn;
    CGFloat originX = self.sectionInset.left + column * (width + interItemSpacing);
    CGFloat originY = row * (height + lineSpacing) + self.headerHeight;
    
    CGRect rect = CGRectMake(originX, originY, width, height);
    return rect;
}
- (CGRect)supplementaryFrameAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = CGRectMake(0, 0, self.collectionView.bounds.size.width, self.headerHeight);
    return rect;
}

- (NSIndexPath *)visibleIndexPathFirst
{
    NSArray *visibleIndexPaths=[self.collectionView indexPathsForVisibleItems];
    
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    NSArray *sortedVisibleIndexPaths=[visibleIndexPaths sortedArrayUsingDescriptors:@[sortDescriptor]];
    if(sortedVisibleIndexPaths.count > 0)
    {
        NSIndexPath *fisrtIndexPaht=[sortedVisibleIndexPaths objectAtIndex:0];
        return fisrtIndexPaht;
    }
    return nil;
}

- (void)setNumberOfColumn:(NSInteger)numberOfColumn
{
    _numberOfColumn=numberOfColumn;
    
    [self invalidateLayout];
}

- (void)setHeight:(CGFloat)height
{
    _height=height;
    
    [self invalidateLayout];
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    [self invalidateLayout];
}
@end
