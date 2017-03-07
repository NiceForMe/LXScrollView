//
//  LXScrollView.h
//  LXScrollView
//
//  Created by NiceForMe on 17/3/6.
//  Copyright © 2017年 BHEC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXScrollViewSelectBlock)(NSInteger selectIndex);
typedef NS_ENUM(NSUInteger,LXScrollViewModel){
    PageControlAlignMentCenter,//pageControl位于中间，没有label
    PageControlAlignMentRight,//pageControl位于右边，label在左
    PageControlAlignMentLeft//pageControl位于左边，label在右
};

@interface LXScrollView : UIView
/**
 *	@author 李潇
 *  pageControl
 */
@property (nonatomic,strong) UIPageControl *pageControl;
/**
 *	@author 李潇
 *  labelColor 默认为blackColor
 */
@property (nonatomic,strong) UIColor *labelColor;
/**
 *	@author 李潇
 *  labelFontSize 默认为17
 */
@property (nonatomic,assign) CGFloat labelFontSize;
/**
 *	@author 李潇
 *  shouldShowBackGroundView 是否显示背景图，默认为NO
 */
@property (nonatomic,assign) BOOL shouldShowBackGroundView;
/**
 *	@author 李潇
 *  backgoundViewColor 默认为lightGrayColor
 */
@property (nonatomic,strong) UIColor *backgoundViewColor;
/**
 *	@author 李潇
 *  selectBlock
 */
@property (nonatomic,copy) LXScrollViewSelectBlock selectBlock;
/**
 *	@author 李潇
 *  scrollViewModel 默认pageControl居中，没有label
 */
@property (nonatomic,assign) LXScrollViewModel scrollViewModel;
/**
 *  The only created method for init.
 *
 *  @param scrollViewModel     The model for the scrollView
 *  @param scrollViewFrame     Set the frame for scrollView
 *  @param timerInterval       Set timeInterval fot scrollView
 *  @param imageArray          the datasource for images
 *  @param labelArray          the datasource for label
 *  @param selectBlock         return select index

 *  @return The LXScrollView object.
 */
- (instancetype)initLXScrollViewWithModel:(LXScrollViewModel)scrollViewModel scrollViewFrame:(CGRect)scrollViewFrame timeInterval:(NSTimeInterval)timerInterval imageArray:(NSMutableArray *)imageArray labelArray:(NSMutableArray *)labelArray selectBlock:(LXScrollViewSelectBlock)selectBlock;
@end

