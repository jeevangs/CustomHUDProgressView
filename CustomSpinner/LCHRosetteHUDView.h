//
//  LCHRosetteHUDView.h
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "LCHRosetteView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LCHRosetteHUDViewStyle) {
    LCHRosetteHUDViewStyleWhite,
    LCHRosetteHUDViewStyleBlue,
    LCHRosetteHUDViewStyleBlueLarge
};

@interface LCHRosetteHUDView : UIView <NSCoding>

@property(nonatomic) LCHRosetteHUDViewStyle rosetteViewStyle; // default is LCHRosetteHUDViewStyleWhite
@property(nonatomic) BOOL hidesWhenStopped;                   // default is YES.
@property (nullable, readwrite, nonatomic, strong) UIColor *color UI_APPEARANCE_SELECTOR;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRosetteHUDStyle:(LCHRosetteHUDViewStyle)style withText:(nullable NSString *)text NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRosetteHUDStyle:(LCHRosetteHUDViewStyle)style;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end

NS_ASSUME_NONNULL_END