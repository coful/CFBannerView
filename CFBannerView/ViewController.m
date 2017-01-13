//
//  ViewController.m
//  CFBannerView
//
//  Created by coful on 17/1/13.
//  Copyright © 2017年 coful. All rights reserved.
//

#import "ViewController.h"
#import "CFBannerView.h"

#define kScreenSize [UIScreen mainScreen].bounds
#define kScreenWidth kScreenSize.size.width
#define kScreenHeight kScreenSize.size.height
#define bannerViewHeight 180

@interface ViewController ()<CFBannerViewDelegate>

@property (nonatomic,strong) CFBannerView *bannerView;

@property NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //幻灯片
    _bannerView = [[CFBannerView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, bannerViewHeight)];
    
    _bannerView.delegate = self;
    
    [_bannerView setTimeInterval:5];
    
    _dataArray = @[@[@"标题1",@"bg1"],@[@"标题2",@"bg2"],@[@"标题3",@"bg3"],@[@"标题4",@"bg4"],@[@"标题5",@"bg5"],@[@"标题6",@"bg6"]];
    
    [_bannerView setDataArray:_dataArray];
    
    [self.view addSubview:_bannerView];
    
}

#pragma mark 幻灯片回调
-(void)didSelectCurrentPage:(int)index{
    
    NSLog(@"回调显示：%@",_dataArray[index][0]);
}

-(void)didEndScrollingInPage:(int)index{
    
    NSLog(@"滚动完成：%d",index);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
