//
//  ReuseLoopView.m
//  UIScrollView之无限滑动
//
//  Created by Z-zg on 16/5/17.
//  Copyright © 2016年 Z-zg. All rights reserved.
//

#import "ReuseLoopView.h"

#define ScWidth [UIScreen mainScreen].bounds.size.width
#define ScHeight [UIScreen mainScreen].bounds.size.height

//定义分页控件的高度
#define pageControlHeight 37

@interface ReuseLoopView (){
    
    //定义三个视图(1、2、3、1、2、3、1...)
    UIImageView *_rightView;
    UIImageView *_middleView;
    UIImageView *_leftView;
    //滑动控制器和分页控制器
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    //存储当前页面的当前页码
    NSInteger _currentPageNumber;
    
}

@property (nonatomic,weak)NSTimer *timer;

@end


@implementation ReuseLoopView

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
         [self startTimer];
        [self createUI:frame];
        
    }
    return self;
}

//创建UI布局
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
    
    
//----------------------------此方法添加的部分-----------------------------
    
    //初始化图像视图
    //右
    _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScWidth*2, 0, ScWidth, frame.size.height - pageControlHeight)];
    //中
    _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScWidth, frame.size.height - pageControlHeight)];
    //左
    _middleView = [[UIImageView alloc] initWithFrame:CGRectMake(ScWidth, 0, ScWidth, frame.size.height - pageControlHeight)];
    
    //添加到滑动视图上
    [_scrollView addSubview:_leftView];
    [_scrollView addSubview:_middleView];
    [_scrollView addSubview:_rightView];
    
}

#pragma mark -设置数据
-(void)setInitProperty{
    
    //设置分页控件的页数
    _pageControl.numberOfPages = _titleArray.count;
    //设置滑动区间
    _scrollView.contentSize = CGSizeMake(_titleArray.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    //设置偏移量
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    //设置当前页数
    _currentPageNumber = 0;
    
    //加载图片
    [self loadPageContent];
}


#pragma mark -加载图片
-(void)loadPageContent{
    
   //设置中间的图片
    _middleView.image = [UIImage imageNamed:_titleArray[_currentPageNumber]];
   //设置左边
    NSInteger leftImageIndex = (_currentPageNumber-1 +_titleArray.count) % _titleArray.count;
    _leftView.image = [UIImage imageNamed:_titleArray[leftImageIndex]];;
    //设置右边
    NSInteger rightImageIndex = (_currentPageNumber + 1)%_titleArray.count;
    _rightView.image = [UIImage imageNamed:_titleArray[rightImageIndex]];
    
    //设置分页控件的页数
    _pageControl.currentPage = _currentPageNumber;
   
}

#pragma mark -设置titleArray
-(void)setTitleArray:(NSArray *)titleArray{
    
    //注意图片少于三张
    
    if (![titleArray isKindOfClass:[NSArray class]] || titleArray.count < 3) {
        return;
    }
    
    _titleArray = titleArray;
    
    //加载页面内容
    [self setInitProperty];
    
}

#pragma mark -页面切换的代理方法的处理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //向左滑动
    if (_scrollView.contentOffset.x > _scrollView.bounds.size.width) {
        _currentPageNumber = (_currentPageNumber + 1) % _titleArray.count;
        
    }
    //向右滑动
    else if (_scrollView.contentOffset.x < _scrollView.bounds.size.width){
         _currentPageNumber = (_currentPageNumber - 1 + _titleArray.count) % _titleArray.count;
    }
    
    //重新加载数据
    [self loadPageContent];
    
    //设置偏移量
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
    
}


#pragma mark -定时器方法的实现
//设置定时器方法
-(void)startTimer{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

-(void)timerStart:(NSTimer *)timer{
    
      _currentPageNumber = (_currentPageNumber + 1) % _titleArray.count;
    //重新加载数据
    [self loadPageContent];
    
    //设置偏移量
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -滑动视图已经结束拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
#pragma mark -滑动视图将要开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}










@end
