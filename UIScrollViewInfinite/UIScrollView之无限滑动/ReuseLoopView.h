//
//  ReuseLoopView.h
//  UIScrollView之无限滑动
//
//  Created by Z-zg on 16/5/17.
//  Copyright © 2016年 Z-zg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReuseLoopView : UIView <UIScrollViewDelegate>

//定义一个数组存放图片的名字
@property(nonatomic,strong)NSArray *titleArray;



@end
