//
//  STCollectionViewController.m
//  MyCollectionvView
//
//  Created by stoncle on 14-9-29.
//  Copyright (c) 2014年 stoncle. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeader.h"
#define kCellIdentifier @"collectionViewCell"
#define kHeaderIdentifier @"collectionHeader"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"


@interface CollectionViewController ()
{
     UICollectionView *_collectionView;
}
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation CollectionViewController

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
//    THSpringyFlowLayout *springFlowLayout = [[THSpringyFlowLayout alloc]init];
//    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:springFlowLayout];
//    ASHSpringyCollectionViewFlowLayout *springFlowLayout = [[ASHSpringyCollectionViewFlowLayout alloc]init];
//    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:springFlowLayout];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:collectionLayout];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [_collectionView registerClass:[CollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
}

- (void)viewDidLoad
{
    
    _collectionView.alwaysBounceVertical = YES;
    _data = [[NSMutableArray alloc]initWithCapacity:10];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_collectionView];
    __block UICollectionView *d = _collectionView;
    __block NSMutableArray *a = _data;
    [_collectionView addPullToRefreshWithActionHandler:^{
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        if(a.count > 10)
        {
            for(int i=0; i<10; i++)
            {
                [a removeObjectAtIndex:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [arr addObject:indexPath];
            }
        }
        [d deleteItemsAtIndexPaths:arr];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [d.pullToRefreshView stopAnimating];
        });
    }WithCurrentTheme:CHQRefreshThemeSpiral];
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
        
//        NSLog(@"good");
        int j = [a count];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for(int i=0; i<20; i++)
        {
            [a addObject:@"hhh"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j+i inSection:0];
            [arr addObject:indexPath];
        }
        [d performBatchUpdates:^{
            [d insertItemsAtIndexPaths:arr];
        } completion:^(BOOL finished) {}];
        
        
        srand((unsigned)time(0));
        int i = rand() % 3;
        [d changeCurrentRefreshThemeToTheme:i];
        [d.infiniteScrollingView stopAnimating];
    }];
    [self addConstraints];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addConstraints
{
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionViewHeader *header = nil;
    if([kind isEqual:UICollectionElementKindSectionHeader]){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        header.label.text = @"123";
        header.label.textColor = [UIColor blackColor];
    }
    return header;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat duration = .3;
    static NSUInteger xOffset = 0;
    static NSUInteger yOffset = 300;
    if(collectionView.visibleCells.count <12 && ![collectionView.visibleCells containsObject:cell])
    {
        cell.frame = CGRectMake(cell.frame.origin.x - xOffset, cell.frame.origin.y+yOffset, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:duration
                         animations:^{
                             cell.frame = CGRectMake(cell.frame.origin.x + xOffset, cell.frame.origin.y - yOffset, cell.frame.size.width, cell.frame.size.height);
                         } completion:^(BOOL finished) {
                         }];
    }
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect r = [UIScreen mainScreen].applicationFrame;
//    NSLog(@"%f", r.size.width/3.05);
	return CGSizeMake(r.size.width/3.05, r.size.width/3*1.15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGRect r = [UIScreen mainScreen].applicationFrame;
    return CGSizeMake(r.size.width, r.size.height/4);
}


@end
