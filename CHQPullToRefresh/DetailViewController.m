//
//  DetailViewController.m
//  CHQPullToRefresh
//
//  Created by 陈鸿强 on 10/22/14.
//  Copyright (c) 2014 陈鸿强. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    [imgView setBackgroundColor:[UIColor blackColor]];
    UIImage *img = [UIImage imageNamed:@"pac-bottom"];
    [imgView setImage:img];
    [self.view addSubview:imgView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
