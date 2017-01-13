//
//  CFBannerView.m
//  CFBannerView
//
//  Created by coful on 17/1/13.
//  Copyright © 2017年 coful. All rights reserved.
//

#import "CFBannerView.h"

@interface CFBannerView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) int totalNum;
@property (nonatomic) int currentImageIndex;//当前图片索引

@property (nonatomic) NSTimeInterval defaultTimeInterval;//间隔时间，单位：秒


@end

@implementation CFBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3,0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;//设置代理UIscrollViewDelegate
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示竖向滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//是否显示横向滚动条
        _scrollView.pagingEnabled = YES;//是否设置分页
        
        [self addSubview:_scrollView];
        
        [self addImageViews];
        
        /*
         ***容器，装载
         */
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-30, CGRectGetWidth(self.frame), 30)];
        containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:containerView];
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
        //        _alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        //        _alphaView.alpha = 0.7;
        [containerView addSubview:_alphaView];
        
        //分页控制
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-10, 30)];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//貌似不起作用呢
        _pageControl.currentPage = 0; //初始页码为0
        
        [containerView addSubview:_pageControl];
        //图片张数
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(containerView.frame)-20, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [containerView addSubview:_titleLabel];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        
        [self addGestureRecognizer:imageTap];
    }
    return self;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    _defaultTimeInterval = timeInterval;
    if(_defaultTimeInterval != 0){
        //            NSLog(@"初始化定时器");
        _timer = [NSTimer scheduledTimerWithTimeInterval:_defaultTimeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (_timer != nil && _defaultTimeInterval != 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_totalNum<=0){
        return;
    }
    
    //重新加载图片
    [self reloadImage];
    
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame), 0) animated:NO];
    
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    
    _titleLabel.text = _dataArray[_currentImageIndex][0];
    
    if (_timer == nil && _defaultTimeInterval != 0) {
        //        NSLog(@"再初始化定时器");
        _timer = [NSTimer scheduledTimerWithTimeInterval:_defaultTimeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    if ( [_delegate respondsToSelector:@selector(didEndScrollingInPage:)] ) {
        [_delegate didEndScrollingInPage:_currentImageIndex];
    }else{
        NSLog(@"并没有实现此方法");
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)timerAction{
    //     NSLog(@"timerAction 定时循环显示下一张图片");
    //定时循环显示下一张图片
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame)*2, 0) animated:YES];
}


-(void)imageTapAction:(UITapGestureRecognizer *)sender{
    //    NSLog(@"%d",_currentImageIndex);
    
    if(_totalNum>0){
        //        _block(_currentImageIndex);
        
        if ( [_delegate respondsToSelector:@selector(didSelectCurrentPage:)] ) {
            [_delegate didSelectCurrentPage:_currentImageIndex];
        }else{
            NSLog(@"并没有实现此方法");
        }
        
    }
    
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    _leftImageView.contentMode=UIViewContentModeScaleToFill;
    [_scrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    _centerImageView.contentMode=UIViewContentModeScaleToFill;
    [_scrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    _rightImageView.contentMode=UIViewContentModeScaleToFill;
    [_scrollView addSubview:_rightImageView];
    
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame), 0) animated:NO];
}

#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    
    [self setImageFor:_leftImageView withIndex:_totalNum-1];
    
    //    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[0][1]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    _centerImageView.image = [UIImage imageNamed:_dataArray[0][1]];
    
    [self setImageFor:_rightImageView withIndex:1];
    
    _currentImageIndex=0;
    //设置当前页
    _pageControl.currentPage=_currentImageIndex;
    
    _titleLabel.text = _dataArray[0][0];
}

- (void)setDataArray:(NSArray *)dataArray{
    _totalNum = (int)[dataArray count];
    _dataArray = dataArray;
    //设置总页数
    _pageControl.numberOfPages=_totalNum;
    CGFloat pageControlWidth = _totalNum * 18;
    _pageControl.frame = CGRectMake(CGRectGetWidth(self.frame)-pageControlWidth, 0, pageControlWidth, 30);
    _titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame)-pageControlWidth, 30);
    _alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _alphaView.alpha = 0.7;
    [self setDefaultImage];
}

-(void)setImageFor:(UIImageView *)imageView withIndex:(int)index{
    if(index<_dataArray.count){
        
        //    [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[index][1]] placeholderImage:[UIImage imageNamed:@"default"]];
        
        imageView.image = [UIImage imageNamed:_dataArray[index][1]];
        
    }
}

#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    
    if (offset.x>CGRectGetWidth(_scrollView.frame)) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_totalNum;
    }else if(offset.x<CGRectGetWidth(_scrollView.frame)){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_totalNum-1)%_totalNum;
    }
    
    [self setImageFor:_centerImageView withIndex:_currentImageIndex];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_totalNum-1)%_totalNum;
    rightImageIndex=(_currentImageIndex+1)%_totalNum;
    
    [self setImageFor:_leftImageView withIndex:leftImageIndex];
    [self setImageFor:_rightImageView withIndex:rightImageIndex];
}


@end
