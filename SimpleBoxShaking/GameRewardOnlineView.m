//
//  GameRewardOnlineView.m
//  Baby
//
//  Created by JCWL on 17/2/10.
//  Copyright © 2017年 ChatBaby. All rights reserved.
//

#import "GameRewardOnlineView.h"
#import <POP/POP.h>

@interface GameRewardOnlineView ()
{
    UILabel *p_lblTitle;            //标题
    UILabel *p_lblShellCount;       //金币数
    UILabel *p_lblLeftCount;        //剩余次数
}

@end

@implementation GameRewardOnlineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark - 私有方法
- (void)initViews
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = [UIColor whiteColor];
    
    //标题
    UIView *viewTitle = [UIView new];
    [self addSubview:viewTitle];
    viewTitle.frame = CGRectMake(0, 0, AdaptedWidthValue(274), AdaptedHeightValue(47));
    viewTitle.backgroundColor = kUIColorFromRGB(0x30B0FB);
    
    p_lblTitle = [UILabel new];
    [viewTitle addSubview:p_lblTitle];
    p_lblTitle.frame = viewTitle.frame;
    p_lblTitle.textAlignment = NSTextAlignmentCenter;
    p_lblTitle.textColor = [UIColor whiteColor];
    p_lblTitle.font = [UIFont systemFontOfSize:18.0];
    p_lblTitle.text = @"在线奖励";
    
    //内容
    UIImageView *imgShell = [UIImageView new];
    [self addSubview:imgShell];
    imgShell.frame = CGRectMake(AdaptedWidthValue(45), AdaptedHeightValue(103), AdaptedWidthValue(62), AdaptedHeightValue(62));
    imgShell.image = [UIImage imageNamed:@"game_gold_icon"];
    
    p_lblShellCount = [UILabel new];
    [self addSubview:p_lblShellCount];
    p_lblShellCount.frame = CGRectMake(AdaptedWidthValue(111), AdaptedHeightValue(110), AdaptedWidthValue(140), AdaptedHeightValue(50));
    p_lblShellCount.textColor = kUIColorFromRGB(0x30B0FB);
    p_lblShellCount.font = [UIFont systemFontOfSize:kFontSizeWithps(100)];
    p_lblShellCount.text = @"+200";
    
    //剩余次数
    p_lblLeftCount = [UILabel new];
    [self addSubview:p_lblLeftCount];
    p_lblLeftCount.frame = CGRectMake(AdaptedWidthValue(42), AdaptedHeightValue(225), AdaptedWidthValue(232), AdaptedHeightValue(15));
    p_lblLeftCount.textColor = kUIColorFromRGB(0x969696);
    p_lblLeftCount.font = [UIFont systemFontOfSize:kFontSizeWithps(40)];
    p_lblLeftCount.attributedText = [self getLeftCountAttributeText:@"今天剩余次数0次(共2次)"];
    
    //确定按钮
    UIButton *btnOK = [UIButton new];
    [self addSubview:btnOK];
    btnOK.layer.cornerRadius = 5.0;
    btnOK.frame = CGRectMake(AdaptedWidthValue(30), AdaptedHeightValue(255), AdaptedWidthValue(214), AdaptedHeightValue(34));
    [btnOK setBackgroundColor:kUIColorFromRGB(0x30B0FB)];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//设置奖励剩余文本属性
- (NSMutableAttributedString *)getLeftCountAttributeText:(NSString *)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range1 = [[str string] rangeOfString:@"次("];
    NSRange range2 = [[str string] rangeOfString:@"数"];
    NSRange range_1 = NSMakeRange(NSMaxRange(range2), range1.location - NSMaxRange(range2));
    NSRange range3 = [[str string] rangeOfString:@"次)"];
    NSRange range4 = [[str string] rangeOfString:@"共"];
    NSRange range_2 = NSMakeRange(NSMaxRange(range4), range3.location - NSMaxRange(range4));
    [str addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x30B0FB) range:range_1];
    [str addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x30B0FB) range:range_2];
    return str;
}

#pragma mark - 公有方法
- (void)refreshUI:(RewardPopType)type shell:(int)shell count:(int)count
{
    NSString *contentStr;
    if (type == mRewardOnline) {
        p_lblTitle.text = @"在线奖励";
        contentStr = [NSString stringWithFormat:@"今天剩余次数%d次(共5次)",count];
    } 
    p_lblShellCount.text = [NSString stringWithFormat:@"+%d",shell];
    p_lblLeftCount.attributedText = [self getLeftCountAttributeText:contentStr];
}

- (void)showPopView
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(self.superview.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

#pragma mark - UI交互
- (void)btnOKClick:(UIButton *)btn
{
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(-self.layer.position.y);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.superview.hidden = YES;
    }];
    [self.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
}

@end
