//
//  LoopScrollView.m
//  UIScrollView之无限滑动
//
//  Created by Z-zg on 16/5/15.
//  Copyright © 2016年 Z-zg. All rights reserved.
//

#import "LoopScrollView.h"

#define ScWidth [UIScreen mainScreen].bounds.size.width
#define ScHeight [UIScreen mainScreen].bounds.size.height

//定义分页控件的高度
#define pageControlHeight 37

@interface LoopScrollView (){
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@end

@implementation LoopScrollView

//1.复写init方法
-(instancetype)init{
    //注意init这里的frame创建和initWithFrame不一样
    //定义一个frame的全局变量
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

//2.复写initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self createUI:frame];
    }
    return self;
}

#pragma mark -创建UI布局
-(void)createUI:(CGRect)frame{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScWidth, frame.size.height - pageControlHeight)];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.delegate = self;
    //设置允许分页效果
    _scrollView.pagingEnabled = YES;
    //隐藏滑动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //添加
    [self addSubview:_scrollView];
    
    //创建分页效果
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-pageControlHeight, ScWidth, pageControlHeight)];
    _pageControl.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_pageControl];
  
}

//创建滑动视图的效果
//复写titleArray  ------如果为空，或者不是图片名
#pragma mark -复写titleArray
-(void)setTitleArray:(NSArray *)titleArray{
    //如果不符合条件或者内容为空那么就直接返回
    if (![titleArray isKindOfClass:[NSArray class]] || titleArray.count==0) {
        return;
    }
    
    //使用NSMutable接收传过来的titleArray
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:titleArray];
    //将最后一张图片插入两次，目的是带最后一张图片的时候直接跳转到第一张
    [mutArray insertObject:[titleArray lastObject] atIndex:0];
    //同时将第一张图片特添加进去
    [mutArray addObject:[titleArray firstObject]];
    //将新生成的数组给_titleArray = 5 1 2 3 4 5 1
    _titleArray = mutArray;
    
    //开始创建视图
    [self createScrollContentView];
    
    
}


-(void)createScrollContentView{
    //获取滑动视图的子视图
    NSArray *subViews = _scrollView.subviews;
    //如果子视图存在，就要删除，然后重新绘制
    [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    //上一步可以用forin语句来实现
//    for (id obj in subViews) {
//        [obj removeFromSuperview];
//    }
    
    //通过枚举来绘制新的视图
    [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //创建一个UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*ScWidth, 0, ScWidth, _scrollView.frame.size.height)];
        //添加图像
        imageView.image = [UIImage imageNamed:obj];
        //将滑动视图添加到滑动视图
        [_scrollView addSubview:imageView];
    }];
    
    //分页控件的效果
    _pageControl.numberOfPages = _titleArray.count-2;
    //设置分页大小
    _scrollView.contentSize = CGSizeMake(_titleArray.count*ScWidth, _scrollView.frame.size.height);
    //偏移量
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
  
}

#pragma mark -实现代理方法
//实现代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //获取当前的分页效果
    NSInteger currentPage = scrollView.contentOffset.x/ScWidth ;
    
    //获取当前分页
    _pageControl.currentPage = currentPage - 1;
    //如果
    if (currentPage == 0) {
        //设置滑动视图的偏移量
        scrollView.contentOffset = CGPointMake((_titleArray.count-2)*ScWidth, 0);
        
        //设置分页的指示位置
        _pageControl.currentPage = _titleArray.count - 2 - 1;
        
    }else if (currentPage == _titleArray.count-1){//第五个的处理
        //偏移量设置
        scrollView.contentOffset = CGPointMake(ScWidth, 0);
        
        //设置分页指示器
        _pageControl.currentPage = 0;
    }
}

@end
