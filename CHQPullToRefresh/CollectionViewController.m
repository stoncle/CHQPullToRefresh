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
#import "UIScrollView+SpiralPullToRefresh.h"


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
//    NSLog(@"%@", _collectionView.infiniteScrollingView);
//    [_collectionView.infiniteScrollingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _data = [[NSMutableArray alloc]initWithCapacity:10];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_collectionView];
//    [_collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [_collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    __block UICollectionView *d = _collectionView;
    __block NSMutableArray *a = _data;
    [_collectionView jjaddPullToRefreshWithActionHandler:^{
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
			[d.pullToRefreshController didFinishRefresh];
        });
    }];
//    [_collectionView addPullToRefreshWithActionHandler:^{
//        NSLog(@"good");
//        int j = [a count];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        for(int i=0; i<10; i++)
//        {
//            [a addObject:@"hhh"];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j+i inSection:0];
//            [arr addObject:indexPath];
//        }
//        [d insertItemsAtIndexPaths:arr];
//        [d.pullToRefreshView stopAnimating];
//    } position:SVPullToRefreshPositionBottom];
//    JZRefreshControl *jz = [[JZRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    [_collectionView addInfiniteScrollingWithActionHandler:^{
//        // append data to data source, insert new cells at the end of table view
//        // call [tableView.infiniteScrollingView stopAnimating] when done
//        
//        NSLog(@"good");
//        int j = [a count];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        
//        for(int i=0; i<10; i++)
//        {
//            [a addObject:@"hhh"];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j+i inSection:0];
//            [arr addObject:indexPath];
//        }
//        [d insertItemsAtIndexPaths:arr];
//        [d.infiniteScrollingView stopAnimating];
//    }];
    [self addConstraints];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat height = scrollView.frame.size.height;
//    CGFloat contentYoffset = scrollView.contentOffset.y;
//    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
//    __block UICollectionView *d = _collectionView;
//    __block NSMutableArray *a = _data;
////    NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
//    if (distanceFromBottom < height) {
//        
//        NSLog(@"end of table");
//        int j = [a count];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        for(int i=0; i<10; i++)
//        {
//            [a addObject:@"hhh"];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j+i inSection:0];
//            [arr addObject:indexPath];
//        }
//        [d insertItemsAtIndexPaths:arr];
//        [d.pullToRefreshView stopAnimating];
//    }
//}

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

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect r = [UIScreen mainScreen].bounds;
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
