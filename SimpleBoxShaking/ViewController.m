//
//  ViewController.m
//  SimpleBoxShaking
//
//  Created by JCWL on 17/2/20.
//  Copyright © 2017年 JCWL. All rights reserved.
//

#import "ViewController.h"
#import "GameRewardOnlineView.h"
#import "GameRewardBoxView.h"

@interface ViewController ()
{
    GameRewardOnlineView *p_viewReward;
    GameRewardBoxView *p_viewBox;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    p_viewBox = [[GameRewardBoxView alloc] initWithFrame:CGRectMake(kScreenWidth - AdaptedWidthValue(74), AdaptedHeightValue(124), AdaptedWidthValue(50), AdaptedWidthValue(56))];
    [self.view addSubview:p_viewBox];
    __weak typeof(self)weakSelf = self;
    p_viewBox.boxClickBlock = ^(int count,int shell) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showRansomOrOnlineView:mRewardOnline shell:200 count:1];
    };
    
    [self createRewardView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createRewardView
{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    viewBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [viewBg setUserInteractionEnabled:YES];
    [self.view addSubview:viewBg];
    viewBg.hidden = YES;
    
    p_viewReward = [[GameRewardOnlineView alloc] initWithFrame:CGRectMake(AdaptedWidthValue(50), AdaptedHeightValue(-308), AdaptedWidthValue(274), AdaptedHeightValue(308))];
    [viewBg addSubview:p_viewReward];
}

//显示救济金或在线奖励
- (void)showRansomOrOnlineView:(RewardPopType)type shell:(int)shell count:(int)count
{
    p_viewReward.superview.hidden = NO;
    [p_viewReward refreshUI:type shell:shell count:count];
    [p_viewReward showPopView];
}

@end
