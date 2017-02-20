//
//  GameRewardOnlineView.h
//  Baby
//
//  Created by JCWL on 17/2/10.
//  Copyright © 2017年 ChatBaby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RewardPopType) {
    mRewardOnline,
    mRewardHelp
};

@interface GameRewardOnlineView : UIView

/**
 刷新界面

 @param type 奖励类型
 @param shell 奖励贝壳数
 @param count 奖励剩余次数
 */
- (void)refreshUI:(RewardPopType)type shell:(int)shell count:(int)count;

/**
 显示奖励界面
 */
- (void)showPopView;

@end
