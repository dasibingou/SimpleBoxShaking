//
//  GameRewardBoxView.m
//  Baby
//
//  Created by JCWL on 17/2/13.
//  Copyright © 2017年 ChatBaby. All rights reserved.
//

#import "GameRewardBoxView.h"
#import <POP/POP.h>

static const int kTimeoutMinute = 1;
static const int kTimeoutTotal = kTimeoutMinute*60;

@interface GameRewardBoxView ()
{
    BOOL p_canTake;         //能否点击宝箱
    NSTimer *p_boxTime;     //倒计时定时器
    int p_boxAnimCount;     //宝箱摇摆一次所需时间
    int p_countdownTime;    //倒计时时间
}

@property (nonatomic, strong) UIImageView *p_imgBox;        //宝箱图片
@property (nonatomic, strong) UILabel *p_lblTime;           //倒计时标签

@end

@implementation GameRewardBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boxClick)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.p_imgBox];
        [self addSubview:self.p_lblTime];
        
        [self makeConstraintSubviews];
        [self refreshUI:([[NSDate date] timeIntervalSince1970] - 60) count:2];
        
    }
    return self;
}

#pragma mark - lazy load
- (UIImageView *)p_imgBox
{
    if (!_p_imgBox) {
        _p_imgBox = [UIImageView new];
        _p_imgBox.image = [UIImage imageNamed:@"game_reward_box"];
        _p_imgBox.alpha = 0.6;
    }
    return _p_imgBox;
}

- (UILabel *)p_lblTime
{
    if (!_p_lblTime) {
        _p_lblTime = [UILabel new];
        _p_lblTime.layer.masksToBounds = YES;
        _p_lblTime.layer.cornerRadius = 5.0;
        _p_lblTime.backgroundColor = kUIColorFromRGB(0x30B0FB);
        _p_lblTime.textAlignment = NSTextAlignmentCenter;
        _p_lblTime.textColor = [UIColor whiteColor];
        _p_lblTime.font = kUHSystemFontWithSize(30);
        _p_lblTime.text = @"可领取";
    }
    return _p_lblTime;
}

#pragma mark - 私有方法
- (void)makeConstraintSubviews
{
    self.p_imgBox.frame = CGRectMake(0, 0, AdaptedWidthValue(50), AdaptedHeightValue(50));
    self.p_lblTime.frame = CGRectMake(AdaptedWidthValue(2.5), AdaptedHeightValue(38), AdaptedWidthValue(45), AdaptedHeightValue(18));
}

- (void)startBoxAnimation
{
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.toValue = @(-(10 / 180.0 * M_PI));
    rotationAnimation.duration = 0.1;
    [rotationAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        POPBasicAnimation *rotationAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation1.toValue = @(10 / 180.0 * M_PI);
        rotationAnimation1.duration = 0.2;
        [rotationAnimation1 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            POPSpringAnimation *rotationAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotationAnimation2.toValue = @(0);
            rotationAnimation2.springBounciness = 20;
            [rotationAnimation2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                 [self.p_imgBox.layer pop_removeAllAnimations];
            }];
            [self.p_imgBox.layer pop_addAnimation:rotationAnimation2 forKey:@"rotationAnimation2"];
        }];
        [self.p_imgBox.layer pop_addAnimation:rotationAnimation1 forKey:@"rotationAnimation1"];
    }];
    [self.p_imgBox.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setTimeoutText
{
    int minute = (int)p_countdownTime/60;
    int second = p_countdownTime - minute*60;
    NSString *minuteStr;
    NSString *secondStr;
    if (minute<10) {
        minuteStr = [NSString stringWithFormat:@"0%d",minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%d",minute];
    }
    if (second<10) {
        secondStr = [NSString stringWithFormat:@"0%d",second];
    } else {
        secondStr = [NSString stringWithFormat:@"%d",second];
    }
    self.p_lblTime.text = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
}

//获取当前VC
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 公有方法
- (void)refreshUI:(int)time count:(int)count
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeout = (int)now - time;
    if (timeout >= 0 && count > 0) {
        if (timeout < 10) {
            //10s以内视作重新倒计时
            p_countdownTime = kTimeoutTotal;
        } else {
            int days = (int)(timeout/(3600*24));
            int hours = (int)((timeout-days*24*3600)/3600);
            int minute = (int)(timeout-days*24*3600-hours*3600)/60;
//            int second = timeout-days*24*3600-hours*3600-minute*60;
            if (days > 0 || hours > 0 || minute >= kTimeoutMinute) {
                p_countdownTime = 0;
            } else {
                p_countdownTime = kTimeoutTotal - timeout;
            }
        }
        [self setTimeoutText];
        //启动定时器
        p_boxTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recycleBoxAnimation) userInfo:nil repeats:YES];
    } else {
        //没次数了隐藏视图
        self.hidden = YES;
    }
}

//销毁定时器
- (void)invalidateTimer
{
    if (p_boxTime) {
        [p_boxTime invalidate];
        p_boxTime = nil;
    }
}

#pragma mark - UI交互
- (void)boxClick
{
    if (p_canTake) {
        p_canTake = NO;
        int count = 2;
        int shell = 300;
        if (self.boxClickBlock) {
            self.boxClickBlock(count,shell);
        }
        [self.p_imgBox pop_removeAllAnimations];
        
        if (count == 0) {
            self.hidden = YES;
        } else {
            self.p_imgBox.alpha = 0.6;
            p_countdownTime = kTimeoutTotal;
        }
    }
}

#pragma mark - 定时器方法
- (void)recycleBoxAnimation
{
    //宝箱摇摆动画
    if (p_canTake) {
        p_boxAnimCount++;
        if (p_boxAnimCount >= 2) {
            [self startBoxAnimation];
            p_boxAnimCount = 0;
        }
    }
    //宝箱倒计时
    if (p_countdownTime >= 0) {
        if (p_countdownTime == 0) {
            p_canTake = YES;
            self.p_lblTime.text = @"可领取";
            self.p_imgBox.alpha = 1.0;
        } else {
            [self setTimeoutText];
        }
    }
    p_countdownTime--;
}

@end
