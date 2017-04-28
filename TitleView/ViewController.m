//
//  ViewController.m
//  TitleView
//
//  Created by Milton on 16/12/30.
//  Copyright © 2016年 YueShi. All rights reserved.
//

#import "ViewController.h"
#import "YSTitlesView.h"

@interface ViewController ()

@property (nonatomic, strong)NSArray *titleArr;

@property (nonatomic, strong)YSTitlesView *titleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArr = @[@"一",@"二",@"三"];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    scrollView.contentSize = CGSizeMake(kScreen_Width * 3, 0);
    
    scrollView.bounces = NO;
    
    scrollView.pagingEnabled = YES;
    
    for (NSInteger i = 0; i < _titleArr.count ; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width * i, 0, kScreen_Width, kScreen_Height)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        [scrollView addSubview:view];
    }
    [self.view addSubview:scrollView];
    
    
    YSTitlesView *titleView = [[YSTitlesView alloc]initWithFrame:CGRectMake(100, 50, kScreen_Width - 200, 40) titles:_titleArr observerTarget:scrollView normalColor:[UIColor grayColor] selectedColor:[UIColor blueColor]];
    
    [self.view addSubview:titleView];
    
    
}


@end
