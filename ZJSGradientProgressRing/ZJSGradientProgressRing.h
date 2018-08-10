//
//  ZJSGradientProgressRing.h
//  AS_DrawHealthIndexDemo
//
//  Created by 周建顺 on 2018/8/5.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSGradientProgressRing : UIView

@property (nonatomic, assign) CGFloat progress;

/**
 The durations of animations in seconds. Dafault is 0.3.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 The progress width.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 The progress start Angle.
 */
@property (nonatomic, assign) CGFloat minAngle;

/**
 The progress end Angle.
 */
@property (nonatomic, assign) CGFloat maxAngle;

@property (nonatomic, assign) CGFloat scale;


/**
 The progress layer.
 */
@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
