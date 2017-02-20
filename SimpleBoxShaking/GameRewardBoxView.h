//
//  GameRewardBoxView.h
//  Baby
//
//  Created by JCWL on 17/2/13.
//  Copyright © 2017年 ChatBaby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BoxClickBlock)(int count,int shell);

@interface GameRewardBoxView : UIView

/** 点击宝箱回调 */
@property (nonatomic, strong) BoxClickBlock boxClickBlock;

/**
 刷新界面

 @param time 时间戳
 @param count 剩余次数
 */
- (void)refreshUI:(int)time count:(int)count;

/**
 销毁定时器
 */
- (void)invalidateTimer;

@end
