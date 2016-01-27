//
//  LCHRosetteView.m
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "LCHRosetteView.h"
#import "LCHProgressBeadLayer.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface LCHRosetteView()
@property (nonatomic, strong) NSMutableDictionary *beadsSpokeDictionary;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CALayer *glassViewLayer;
@property (nonatomic, strong) CALayer *finalCurtainLayer;
@property (nonatomic, assign) LCHRosetteViewControl control;
@property (nonatomic, assign) NSUInteger numberOfSpokesDrawn;
@property (nonatomic, assign) NSUInteger pulsatingSpokeNumber;
@end

@implementation LCHRosetteView

- (void)drawRosetteViewForControl:(LCHRosetteViewControl)control{
    self.color = [UIColor brownColor];
    self.backgroundColor = [UIColor clearColor];
    self.control = control;

    self.beadsSpokeDictionary = [[NSMutableDictionary alloc] init];
    self.contentMode = UIViewContentModeCenter;
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubViews];
    
    [self addConstraintsForSubViews];
    
    [self registerForNotifications];
    
    [self drawBeadsOnView];
}

- (void)addSubViews {
    self.containerView = [[UIView alloc] init];
    self.containerView.clipsToBounds = YES;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.containerView];
    
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:15.0f];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.text = self.text;
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.label];
}

- (void) addSublayersForProgressView {
    self.numberOfSpokesDrawn = 0;
    self.pulsatingSpokeNumber = 0;
    
    self.glassViewLayer = [CALayer layer];
    [self.containerView.layer addSublayer:self.glassViewLayer];
    self.glassViewLayer.opacity = 0;
    
    self.finalCurtainLayer = [CALayer layer];
    [self.containerView.layer addSublayer:self.finalCurtainLayer];
    self.finalCurtainLayer.opacity = 1;
    
    CALayer *partialLayer1 = [CALayer layer];
    partialLayer1.opacity = 0.9;
    [partialLayer1 setValue:@"leftToMiddle" forKey:@"screenPart"];
    partialLayer1.backgroundColor = [UIColor redColor].CGColor;
    [self.finalCurtainLayer addSublayer:partialLayer1];
    
    CALayer *transparentLayer = [CALayer layer];
    transparentLayer.opacity = 0.9;
    [transparentLayer setValue:@"middle" forKey:@"screenPart"];
    transparentLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.finalCurtainLayer addSublayer:transparentLayer];
    
    CALayer *partialLayer2 = [CALayer layer];
    partialLayer2.opacity = 0.9;
    [partialLayer2 setValue:@"middleToRight" forKey:@"screenPart"];
    partialLayer2.backgroundColor = [UIColor blueColor].CGColor;
    [self.finalCurtainLayer addSublayer:partialLayer2];
}

- (void)addConstraintsForSubViews {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_containerView);
    
    NSArray *constraints = @[
                             @"H:|-0-[_containerView]-0-|",
                             @"V:|-0-[_containerView]-0-|"
                             ];
    for (NSString *constraint in constraints){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:viewsDictionary]];
    }
    
    // Constraint for the label inside rosetteView
    NSLayoutConstraint *labelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeWidth multiplier:1 constant:-100.0f];
    [self.containerView addConstraint:labelWidthConstraint];
    
    NSLayoutConstraint *labelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.containerView addConstraint:labelCenterXConstraint];
    
    NSLayoutConstraint *labelCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.containerView addConstraint:labelCenterYConstraint];
}

- (void)drawBeadsOnView {
    NSUInteger numberOfSpikes = 24;
    
    CGFloat radiusOfBead = 6.0f;
    CGFloat beadSizeForDrawingEachRadius = 0;
    CGFloat radiusIncrement = 0;
    
    for (NSUInteger j= 0; j < 5; j++) {
        for (NSUInteger i = 0; i < numberOfSpikes; i++) {
            beadSizeForDrawingEachRadius = roundf((1 -(j*.17)) * radiusOfBead * 10) / 10;
            LCHProgressBeadLayer *bead = [[LCHProgressBeadLayer alloc] initWithFrame:CGRectMake(0, 0, beadSizeForDrawingEachRadius, beadSizeForDrawingEachRadius) WithColor:self.color];
            [self.containerView.layer addSublayer:bead];
            if(![[self.beadsSpokeDictionary allKeys] containsObject:[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]]) {
                [self.beadsSpokeDictionary setObject:[NSMutableArray arrayWithObject:bead] forKey:[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]];
            }
            else {
                NSMutableArray *spokeBeadArray = self.beadsSpokeDictionary[[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]];
                [spokeBeadArray addObject:bead];
            }
        }
        radiusIncrement = radiusIncrement + beadSizeForDrawingEachRadius + 2.0f;
    }
    
    if(self.control == LCHRosetteViewControlProgressView) {
        [self addSublayersForProgressView];
    }
}

- (void) updateBeadsFrameWithColor:(UIColor *)UIColor {
    NSUInteger numberOfSpikes = 24;
    CGFloat potentialRadius = MIN(self.containerView.frame.size.width,self.containerView.frame.size.height);
    potentialRadius = MIN(potentialRadius, 290.0f);
    
    CGFloat radiusOfBead = floorf(potentialRadius / 25);
    
    CGFloat totalPaddingToBeAccounted = 10.0f;
    
    CGFloat radiusIncrement = 0;
    
    CGFloat beadSizeForDrawingEachRadius = 0;
    
    for (NSInteger rings = 0; rings < 5; rings++) {
        totalPaddingToBeAccounted = totalPaddingToBeAccounted + roundf((1 -(rings*.17)) * radiusOfBead * 10) / 10;
    }
    
    CGFloat radiusForCircle = (potentialRadius/2) - totalPaddingToBeAccounted;
    
    // This center is based on the view's size to which the beads are going to be attached.
    CGPoint center = CGPointMake(self.containerView.frame.size.width/2, self.containerView.frame.size.width/2);
    
    for(NSUInteger j=0; j<5; j++) {
        for(NSUInteger i =0 ; i< 24; i++) {
            beadSizeForDrawingEachRadius = roundf((1 -(j*.17)) * radiusOfBead * 10) / 10;
            NSMutableArray *spokeBeadArray = self.beadsSpokeDictionary[[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]];
            LCHProgressBeadLayer *beadLayer = (LCHProgressBeadLayer *)spokeBeadArray[j];
            beadLayer.position = CGPointMake(center.x + (radiusForCircle + radiusIncrement) * sinf( i * degreesToRadians(360/numberOfSpikes)), center.y + (radiusForCircle + radiusIncrement) * -cosf( i * degreesToRadians(360/numberOfSpikes)));
            beadLayer.backgroundColor = self.color.CGColor;
        }
        radiusIncrement = radiusIncrement + beadSizeForDrawingEachRadius + 2.0f;
    }
}

- (void)updateSpokesInRosette:(NSUInteger)numberOfSpokes withColor:(UIColor *)color animated:(BOOL)animated {
    
    CGFloat delayTimeForPulsating = 0.0f;
    CGFloat delayTime = 0.0f;
    
    for(NSUInteger i = self.numberOfSpokesDrawn; i < numberOfSpokes; i++) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *spokeBeadArray = self.beadsSpokeDictionary[[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]];
            for(NSUInteger j = 0; j < [spokeBeadArray count]; j++) {
                LCHProgressBeadLayer *beadLayer = (LCHProgressBeadLayer *)spokeBeadArray[j];
                CAKeyframeAnimation *backgroundAnimation = [self createAnimationForProperty:@"backgroundColor" withValues:@[(id)[UIColor clearColor].CGColor, (id)color.CGColor] atKeyTimes:@[@(0),@(0.5)] forDuration:0.3f];
                backgroundAnimation.removedOnCompletion = NO;
                [beadLayer addAnimation:backgroundAnimation forKey:@"backgroundColor"];
            }
        });
        if(animated) {
            delayTime = delayTime + 0.3;
            delayTimeForPulsating = delayTime;
        }
    }
    
    if(numberOfSpokes < 24) {
        [self displayPulsatingBeadsForSpoke:numberOfSpokes withDelay:delayTimeForPulsating withColor:color];
    }
    if(numberOfSpokes == 24) {
        [self performCompleteProgressAnimation];
    }
    
    self.numberOfSpokesDrawn = numberOfSpokes;
    self.pulsatingSpokeNumber = numberOfSpokes;
}

- (void) displayPulsatingBeadsForSpoke:(NSUInteger)spokeNumber withDelay:(CGFloat)delayForPulsating withColor:(UIColor *)color {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForPulsating * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *blinkingBeadArray = self.beadsSpokeDictionary[[NSString stringWithFormat:@"Spoke%lu",(unsigned long)spokeNumber]];
        for(NSUInteger j = 0; j < [blinkingBeadArray count]; j++) {
            LCHProgressBeadLayer *beadLayer = (LCHProgressBeadLayer *)blinkingBeadArray[j];
            CAKeyframeAnimation *backgroundAnimation = [self createAnimationForProperty:@"backgroundColor" withValues:@[(id)[UIColor clearColor].CGColor, (id)color.CGColor,(id)[UIColor clearColor].CGColor] atKeyTimes:@[@(0),@(0.5),@(0.8)] forDuration:1.2f];
            backgroundAnimation.removedOnCompletion = NO;
            backgroundAnimation.repeatCount = HUGE_VALF;
            [beadLayer addAnimation:backgroundAnimation forKey:@"backgroundColor"];
        }
    });
}

- (void) performCompleteProgressAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((24 - self.numberOfSpokesDrawn) * 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    CAKeyframeAnimation *glassViewAlphaAnimation = [self createAnimationForProperty:@"opacity" withValues:@[@(0),@(0.5),@(0.9)] atKeyTimes:@[@(0),@(0.6),@(0.9)] forDuration:1.0f];
    glassViewAlphaAnimation.removedOnCompletion = NO;
    [self.glassViewLayer addAnimation:glassViewAlphaAnimation forKey:@"opacity"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((28 - self.numberOfSpokesDrawn) * 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *glassViewPositionAnimation = [self createAnimationForProperty:@"position" withValues:@[[NSValue valueWithCGPoint:self.glassViewLayer.position], [NSValue valueWithCGPoint:CGPointMake(self.glassViewLayer.position.x + self.glassViewLayer.frame.size.width, self.glassViewLayer.position.y)]] atKeyTimes:@[@(0),@(0.9)] forDuration:3.0f];
        glassViewPositionAnimation.removedOnCompletion = NO;
        [self.glassViewLayer addAnimation:glassViewPositionAnimation forKey:@"position"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((((28 - self.numberOfSpokesDrawn)* 0.3) + 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *finalCurtainLayerPositionAnimation = [self createAnimationForProperty:@"position" withValues:@[[NSValue valueWithCGPoint:self.finalCurtainLayer.position], [NSValue valueWithCGPoint:CGPointMake(self.finalCurtainLayer.position.x + (1.0 * self.finalCurtainLayer.frame.size.width), self.finalCurtainLayer.position.y)]] atKeyTimes:@[@(0),@(0.9)] forDuration:4.0f];
        finalCurtainLayerPositionAnimation.removedOnCompletion = NO;
        [self.finalCurtainLayer addAnimation:finalCurtainLayerPositionAnimation forKey:@"position"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((((28 - self.numberOfSpokesDrawn) * 0.3) + 5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *finalCurtainLayerAlphaAnimation = [self createAnimationForProperty:@"opacity" withValues:@[@(1),@(0)] atKeyTimes:@[@(0),@(0.8),@(0.9)] forDuration:0.5f];
        finalCurtainLayerAlphaAnimation.removedOnCompletion = NO;
        [self.finalCurtainLayer addAnimation:finalCurtainLayerAlphaAnimation forKey:@"opacity"];
    });
}

- (void)setColorForSubLayersInFinalCurtainLayer {
    for (CALayer *subLayer in self.finalCurtainLayer.sublayers) {
        if([[subLayer valueForKey:@"screenPart"] isEqualToString:@"middle"]) {
            subLayer.backgroundColor = [UIColor clearColor].CGColor;
        }
        else {
            subLayer.backgroundColor = self.superview.backgroundColor.CGColor;
        }
    }
}

- (void)updateFrameForSubLayersInFinalCurtainLayer {
    for(CALayer *subLayer in self.finalCurtainLayer.sublayers) {
        NSString *layerValue = [subLayer valueForKey:@"screenPart"];
        if([layerValue isEqualToString:@"leftToMiddle"]) {
            subLayer.frame = CGRectMake(0, 0, 0.85 * subLayer.superlayer.frame.size.width, subLayer.superlayer.frame.size.height);
        }
        else if([layerValue isEqualToString:@"middle"]) {
            subLayer.frame = CGRectMake(0.85 * subLayer.superlayer.frame.size.width, 0, 0.05 * subLayer.superlayer.frame.size.width, subLayer.superlayer.frame.size.height);
        }
        else {
            subLayer.frame = CGRectMake(0.9 * subLayer.superlayer.frame.size.width, 0, 0.1 * subLayer.superlayer.frame.size.width, subLayer.superlayer.frame.size.height);

        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateBeadsFrameWithColor:self.color];
    if(self.control == LCHRosetteViewControlProgressView) {
        CGRect frame = self.bounds;
        self.glassViewLayer.frame = frame;
        self.glassViewLayer.backgroundColor = self.superview.backgroundColor.CGColor;
        
        frame.size.width = 1.25 * frame.size.width;
        frame.origin.x = -(frame.size.width);
        self.finalCurtainLayer.frame = frame;
        [self setColorForSubLayersInFinalCurtainLayer];
        [self updateFrameForSubLayersInFinalCurtainLayer];
        
    }
}

# pragma mark - Animation methods -

- (void)animateIndeterministicProgressView {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
    }];
    
    for (NSUInteger j = 0; j < 5; j++) {
        CAKeyframeAnimation *backgroundColorAnimation = [self createAnimationForProperty:@"backgroundColor" withValues:@[(id)[UIColor clearColor].CGColor,(id)self.color.CGColor] atKeyTimes:@[@(j*0.2),@((j+1)*0.2)] forDuration:2.5f];
        backgroundColorAnimation.removedOnCompletion = NO;
        backgroundColorAnimation.repeatCount = HUGE_VALF;
        
        for (NSUInteger i = 0; i < 24; i++) {
            LCHProgressBeadLayer *beadLayer = self.beadsSpokeDictionary[[NSString stringWithFormat:@"Spoke%lu",(unsigned long)i]][j];
            [beadLayer addAnimation:backgroundColorAnimation forKey:@"backgroundColor"];
        }
    }
    
    CAKeyframeAnimation *rosetteViewAlphaAnimation = [self createAnimationForProperty:@"opacity" withValues:@[@(1),@(1),@(0)] atKeyTimes:@[@(0),@(0.87),@(0.98)] forDuration:2.5f];
    rosetteViewAlphaAnimation.removedOnCompletion = NO;
    rosetteViewAlphaAnimation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rosetteViewAlphaAnimation forKey:@"opacity"];
}

- (void)stopAnimatingIndeterministicProgressView:(BOOL)hideAfterStopping {
    for(LCHProgressBeadLayer *bead in [self.containerView.layer sublayers]) {
        [bead removeAllAnimations];
    }
    [self.layer removeAllAnimations];
    
    if(hideAfterStopping) {
        [UIView animateWithDuration:0.7f animations:^{
            self.alpha = 0;
        }];
    }
}

- (CAKeyframeAnimation *)createAnimationForProperty:(NSString *)animatableProperty withValues:(NSArray *)values atKeyTimes:(NSArray *)keyTimes forDuration:(CGFloat)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:animatableProperty];
    animation.values = values;
    animation.keyTimes = keyTimes;
    animation.duration = duration;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

# pragma mark - Custom setter -

- (void) setColor:(UIColor *)color {
    _color = color;
    [self updateBeadsFrameWithColor:_color];
}

#pragma mark - Notifications -

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else {
        [self updateForCurrentOrientationAnimated:YES];
    }
}

- (void)updateForCurrentOrientationAnimated:(BOOL)animated {
    // Stay in sync with the superview in any case
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
}

@end
