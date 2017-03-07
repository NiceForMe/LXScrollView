//
//  ViewController.m
//  LXScrollView
//
//  Created by NiceForMe on 17/3/6.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "ViewController.h"
#import "LXScrollView.h"

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *labelArray;
@end

@implementation ViewController
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _imageArray;
}
- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithObjects:@"我得到的都是侥幸",@"我失去的都是人生",@"你听过千百首歌",@"真实的日子还是一个人过",@"让暴风雨都沉默", nil];
    }
    return _labelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LXScrollView *scroll = [[LXScrollView alloc]initLXScrollViewWithModel:PageControlAlignMentRight scrollViewFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) timeInterval:1.0 imageArray:self.imageArray labelArray:self.labelArray selectBlock:^(NSInteger selectIndex) {
        NSLog(@"%lu",selectIndex);
    }];
    scroll.shouldShowBackGroundView = YES;
    scroll.labelFontSize = 22;
    scroll.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    scroll.labelColor = [UIColor purpleColor];
    [self.view addSubview:scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
