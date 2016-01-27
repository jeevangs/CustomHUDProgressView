//
//  LCHRosetteView.h
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCHRosetteViewControl) {
    LCHRosetteViewControlHUDView,
    LCHRosetteViewControlProgressView
};

@interface LCHRosetteView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *color;

- (void)drawRosetteViewForControl:(LCHRosetteViewControl)control;
- (void)animateIndeterministicProgressView;
- (void)stopAnimatingIndeterministicProgressView:(BOOL)hideAfterStopping;

- (void)updateSpokesInRosette:(NSUInteger)numberOfSpokes withColor:(UIColor *)color animated:(BOOL)animated;

@end
