//
//  STCollectionViewHeader.m
//  MyCollectionvView
//
//  Created by stoncle on 14-9-29.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import "CollectionViewHeader.h"

@interface CollectionViewHeader()
{
    
}

@end

@implementation CollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self headerViewInitialize];
        
    }
    return self;
}
- (void)headerViewInitialize
{
    self.contentView = [[UIView alloc]initWithFrame:self.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.contentView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.contentView];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 100, 20)];
    self.label.text = @"jjj";
    
    
    [self.contentView addSubview:_label];
    [self setContraints];
}
- (void)setContraints
{
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSLayoutConstraint *labelX = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.contentView addConstraint:labelX];
    NSLayoutConstraint *labelY = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.contentView addConstraint:labelY];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
