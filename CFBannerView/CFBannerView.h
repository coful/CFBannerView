//
//  CFBannerView.h
//  CFBannerView
//
//  Created by coful on 17/1/13.
//  Copyright © 2017年 coful. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议委托代理
@protocol CFBannerViewDelegate <NSObject>

-(void)didSelectCurrentPage:(int)index;
-(void)didEndScrollingInPage:(int)index;

@end

@interface CFBannerView : UIView<UIScrollViewDelegate>

//Block
typedef void (^CFBannerViewBlock) (int);

@property (nonatomic, assign) CFBannerViewBlock block;

@property (nonatomic, weak) id<CFBannerViewDelegate> delegate;

- (void)setTimeInterval:(NSTimeInterval)defaultTimeInterval;

- (void)setDataArray:(NSArray *)dataArray;

@end
