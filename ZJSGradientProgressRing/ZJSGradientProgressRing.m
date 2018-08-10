//
//  ZJSGradientProgressRing.m
//  AS_DrawHealthIndexDemo
//
//  Created by 周建顺 on 2018/8/5.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import "ZJSGradientProgressRing.h"


@interface ZJSGradientProgressRing()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;

@end

@implementation ZJSGradientProgressRing



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.backgroundColor = [UIColor clearColor];
    _progress = 0.85;
    _lineWidth = 10;
    _minAngle = M_PI/2 + M_PI/4;
    _maxAngle = 2*M_PI + M_PI/4;
    _animationDuration = .3;
    _scale = 1;
    
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
    _gradientLayer.locations = @[@0, @1.0];
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = [UIColor redColor].CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    
    _progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _progressBackgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _progressBackgroundLayer.lineCap = kCALineCapRound;
    _progressBackgroundLayer.lineWidth = _lineWidth;
    
    
    [self.layer addSublayer:_progressBackgroundLayer];
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.mask = self.progressLayer;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    self.progressBackgroundLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
    
   
    
//    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat height = CGRectGetHeight(self.frame);
//
//    CGPoint center = CGPointMake(width/2.f, height/2.f);
//    CGFloat radius = width>height?(height/2 - self.lineWidth/2):(width/2 - self.lineWidth/2);
//
//
//    CGFloat start = (width/2 - radius)/width;
//     CGFloat end =  (width/2  + radius)/width;
//
 //   self.gradientLayer.frame = CGRectMake(width/2 - radius, 0, radius*2, height);
//    self.progressLayer.frame = CGRectMake(width/2 - radius, 0, radius*2, height);
//    self.progressBackgroundLayer.frame = CGRectMake(width/2 - radius, 0, radius*2, height);
    
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:@(0)];
//    [self.gradientLayer.locations enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat v = [obj floatValue];
//        [array addObject:@(start + (end - start)*v)];
//    }];
//    [array addObject:@(1)];
//    self.gradientLayer.locations = [array copy];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGPoint center = CGPointMake(width/2.f, height/2.f);
    CGFloat radius = width>height?(height/2 - self.lineWidth/2):(width/2 - self.lineWidth/2);
    
    CGFloat progressRadius = radius - 8*self.scale -self.lineWidth/2.f;
    
    CGFloat startAngle = self.minAngle;
    CGFloat endAngle = self.maxAngle;

    // 由于需要画点，所以需要在这边对对弧度进行转换
    if (self.minAngle > 2*M_PI) {
        startAngle = self.minAngle - ((NSInteger)(self.minAngle/(2*M_PI)))*2*M_PI;
        endAngle = (self.maxAngle - self.minAngle) + startAngle;
    }else if(self.minAngle < 0){
        startAngle = self.minAngle + ((NSInteger)(self.minAngle/(2*M_PI)))*2*M_PI + 2*M_PI;
        endAngle = (self.maxAngle - self.minAngle) + startAngle;
    }
    
   
    CGFloat angle = (endAngle - startAngle)*self.progress + startAngle;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:progressRadius startAngle:startAngle endAngle:angle clockwise:YES];
    self.progressLayer.path = bezierPath.CGPath;
    [bezierPath stroke];
     //  [self.progressLayer addAnimation:[self createAnimation] forKey:@"strokeEndAnimation"];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:progressRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressBackgroundLayer.path = bgPath.CGPath;
    [bgPath stroke];
    
    
    UIBezierPath *outterArc = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1.f] setStroke];
    [outterArc stroke];
    
    NSInteger count = 360 / 30;
    CGFloat pointRadius = 2.5*self.scale;
    CGFloat innerRadius = progressRadius - self.lineWidth/2 - pointRadius  - 8*self.scale;
    
    
    for (int i = 0; i< count ; i++) {
         CGFloat pointAngle = (M_PI*2 / count)*i;

        // 如果弧度减去startAngle小于0，则加2*M_PI
        CGFloat newPointAngle = (pointAngle - startAngle)>0?( pointAngle - startAngle):( pointAngle - startAngle + 2*M_PI);
        if ((endAngle - startAngle) >= (newPointAngle)&&
            newPointAngle >= 0) {
            UIBezierPath *point = [UIBezierPath bezierPathWithArcCenter:CGPointMake(cos(pointAngle)*innerRadius + center.x, sin(pointAngle)*innerRadius + center.y) radius:pointRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            [[UIColor colorWithRed:231.f/255.f green:231.f/255.f blue:231.f/255.f alpha:1.f] setFill];
            [point fill];
        }

    }
}


//-( CABasicAnimation *)createAnimation{
//    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 1.5*self.progress;
//    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
//    pathAnimation.autoreverses=NO;
//    pathAnimation.repeatCount = 0;
//
//    return pathAnimation;
//}

#pragma mark -

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        _progress = progress;
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        if (!_displayLink) {
            //Create and setup the display link
            [self.displayLink invalidate];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        } /*else {
           //Reuse the current display link
           }*/
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - self.animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [self.displayLink invalidate];
            self.displayLink = nil;
            self->_progress = self.animationToValue;
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        self->_progress = self.animationFromValue + dt * (self.animationToValue - self.animationFromValue);
        [self setNeedsDisplay];
        
    });
    
}

#pragma mark - getters and setters


-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth = _lineWidth;
    self.progressBackgroundLayer.lineWidth = _lineWidth;
    [self setNeedsDisplay];
}

-(void)setMaxAngle:(CGFloat)maxAngle{
    _maxAngle = maxAngle;
    [self setNeedsDisplay];
}

-(void)setMinAngle:(CGFloat)minAngle{
    _minAngle = minAngle;
    [self setNeedsDisplay];
}


@end
