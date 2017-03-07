//
//  LXScrollView.m
//  LXScrollView
//
//  Created by NiceForMe on 17/3/6.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import "LXScrollView.h"
#import "Masonry.h"

#define NormalMargin 10

static NSString *identifier = @"identifier";

@interface LXScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *labelArray;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSTimeInterval timerInterval;
@property (nonatomic,strong) UIView *backGroundView;
@end

@implementation LXScrollView
#pragma mark - init
- (instancetype)initLXScrollViewWithModel:(LXScrollViewModel)scrollViewModel scrollViewFrame:(CGRect)scrollViewFrame timeInterval:(NSTimeInterval)timerInterval imageArray:(NSMutableArray *)imageArray labelArray:(NSMutableArray *)labelArray selectBlock:(LXScrollViewSelectBlock)selectBlock
{
    if (self = [super init]) {
        self.selectBlock = selectBlock;
        self.timerInterval = timerInterval;
        self.frame = scrollViewFrame;
        self.scrollViewModel = scrollViewModel;
        self.backgroundColor = [UIColor redColor];
        self.imageArray = imageArray;
        self.labelArray = labelArray;
        [self addSubview:self.collectionView];
        [self initPageControl];
        [self addTimer];
    }
    return self;
}
#pragma mark - lazy load
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = self.frame.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.autoresizesSubviews = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView reloadData];
    }
    return _collectionView;
}
#pragma mark - addTimer and removeTimer
- (void)addTimer
{
    if (self.timer == nil) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextPage
{
    NSInteger currentIndex = (self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2) / self.collectionView.frame.size.width;
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex == self.imageArray.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2) / self.collectionView.frame.size.width;
    self.pageControl.currentPage = itemIndex % self.imageArray.count;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
#pragma mark - initPageControl
- (void)initPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = self.imageArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    if (self.scrollViewModel == PageControlAlignMentRight) {
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(NormalMargin);
            make.bottom.equalTo(self.mas_bottom).with.offset(NormalMargin);
            make.width.mas_offset(@100);
            make.height.mas_offset(@50);
        }];
    }else if (self.scrollViewModel == PageControlAlignMentLeft){
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(NormalMargin);
            make.bottom.equalTo(self.mas_bottom).with.offset(NormalMargin);
            make.width.mas_offset(@100);
            make.height.mas_offset(@50);
        }];
    }else{
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(NormalMargin);
            make.width.mas_offset(@100);
            make.height.mas_offset(@50);
        }];
    }

}
#pragma mark - collectionview datasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //imgView
    UIImageView *imgView = [[UIImageView alloc]init];
    self.imgView = imgView;
    NSString *imgName = self.imageArray[indexPath.row];
    self.imgView.image = [UIImage imageNamed:imgName];
    self.imgView.frame = cell.contentView.frame;
    [cell.contentView addSubview:self.imgView];
    //backGroundview
    self.backGroundView = [[UIView alloc]init];
    if (self.backgoundViewColor == nil) {
        self.backGroundView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backGroundView.backgroundColor = self.backgoundViewColor;
    }
    if (self.shouldShowBackGroundView == YES) {
        [cell.contentView addSubview:self.backGroundView];
        CGFloat height = [self getHeight];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(0);
            make.right.equalTo(cell.contentView.mas_right).with.offset(0);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(height + NormalMargin);
        }];
    }
    //label
    UILabel *label = [[UILabel alloc]init];
    label.textColor = self.labelColor;
    if (self.labelFontSize == 0) {
        label.font = [UIFont systemFontOfSize:17];
    }else{
        label.font = [UIFont systemFontOfSize:_labelFontSize];
    }
    self.label = label;
    self.label.text = self.labelArray[indexPath.row];
    if (self.scrollViewModel == PageControlAlignMentRight) {
        self.label.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(NormalMargin);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(NormalMargin);
            make.height.mas_equalTo(@50);
            make.width.mas_equalTo(@(self.frame.size.width - 2 * NormalMargin - self.pageControl.frame.size.width));
        }];
    }else if (self.scrollViewModel == PageControlAlignMentLeft){
        self.label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(NormalMargin);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(NormalMargin);
            make.height.mas_equalTo(@50);
            make.width.mas_equalTo(@(self.frame.size.width - 2 * NormalMargin - self.pageControl.frame.size.width));
        }];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}
#pragma mark - getHeight
- (CGFloat)getHeight
{
    CGFloat fontSize;
    if (self.labelFontSize == 0) {
        fontSize = 17;
    }else{
        fontSize = self.labelFontSize;
    }
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size = [@"你好" sizeWithAttributes:attrs];
    return size.height;
}
@end
