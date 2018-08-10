//
//  ViewController.m
//  ZJSGradientProgressRingDemo
//
//  Created by 周建顺 on 2018/8/10.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import "ViewController.h"

#import "ZJSGradientProgressRing.h"

#define ColorWithRGBHEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

@interface ViewController ()

@property (nonatomic, strong) ZJSGradientProgressRing *demo2View;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.demo2View = [[ZJSGradientProgressRing alloc] init];
    self.demo2View.gradientLayer.colors = @[(__bridge id)ColorWithRGBHEX(0xee5353).CGColor, (__bridge id)ColorWithRGBHEX(0xff6b6b).CGColor, (__bridge id)ColorWithRGBHEX(0xff9f43).CGColor, (__bridge id)ColorWithRGBHEX(0xfeca57).CGColor, (__bridge id)ColorWithRGBHEX(0x58cd8a).CGColor];
    self.demo2View.gradientLayer.locations = @[@0, @0.25, @0.5, @0.75, @1.0];
    self.demo2View.lineWidth = 20;
    self.demo2View.minAngle = M_PI_2 + M_PI_4;
    self.demo2View.maxAngle = M_PI * 2 + M_PI_4;
    self.demo2View.progress = 0.1;
    self.demo2View.animationDuration = 0.5;
    self.demo2View.frame = CGRectMake(10, 80 , 200, 200);
    
    [self.view addSubview:self.demo2View];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.demo2View setProgress:0.5 animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.demo2View setProgress:0.95 animated:YES];
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
