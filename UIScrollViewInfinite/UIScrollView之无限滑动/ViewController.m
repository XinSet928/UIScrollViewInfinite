//
//  ViewController.m
//  UIScrollView之无限滑动
//
//  Created by Z-zg on 16/5/15.
//  Copyright © 2016年 Z-zg. All rights reserved.
//

#import "ViewController.h"
#import "LoopScrollView.h"
#import "ReuseLoopView.h"


#define ScWidth [UIScreen mainScreen].bounds.size.width
#define ScHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定义数组存放image
    NSArray *array = @[@"scene1",
                       @"scene2",
                       @"scene3",
                       @"scene4",
                       @"scene5"];//需要添加就直接在此处添加，其他不需要修改
    
    //-------------------
    
    
    
    //方法一
    //创建
    LoopScrollView *loopView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0, 0, ScWidth, 260)];
    //添加到self.view
    [self.view addSubview:loopView];
    //设置数组
    loopView.titleArray = array;
    
    /**
     *  复写initWithFrame方法
        titleArray的处理：  传入的titleArray = 1 2 3 4 5 ;  titleArray.count = 5;
                           处理后的_titleArray = 5 1 2 3 4 5 1 ; _titleArray.count = 7;
        创建视图时比较关键：如果司徒中的图片存在，存在就要清空
        清空后，左进一步处理：将_titleArray一个个创建视图
     
     -----------------------------------
     1) 复写initWithFrame方法；
     2) dataArray的处理：
       a) 传入的dataArray = 1 2 3 4 5;            dataArray.count = 5
       b) 处理后的_dataArray = 5 1 2 3 4 5 1;      _dataArray.count = 7;
       c) 创建视图时，比较关键：如果视图中的图片存在，存在就要清空；
       d) 清空后，做进一步处理：将_dataArra一个个创建视图；
     3) 分页控件的处理
       a) 分页控件的个数；
       b) 分页控件循环的效果：第0个和第5个要做特殊处理。
     
     */
    
    //方法二
    ReuseLoopView *reuseLoopView = [[ReuseLoopView alloc] initWithFrame:CGRectMake(0, 300, ScWidth, 260)];
    [self.view addSubview:reuseLoopView];
    reuseLoopView.titleArray = array;
    

    
    
    
}

@end
