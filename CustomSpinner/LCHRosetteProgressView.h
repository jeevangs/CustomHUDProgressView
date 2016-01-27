//
//  LCHRosetteProgressView.h
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LCHRosetteProgressViewStyle) {
    LCHRosetteProgressViewStyleWhite,
    LCHRosetteProgressViewStyleBlue,
    LCHRosetteProgressViewStyleBlueLarge
};

@interface LCHRosetteProgressView : UIView <NSCoding>

@property(nonatomic) LCHRosetteProgressViewStyle progressViewStyle; // default is LCHRosetteProgressViewStyleWhite
@property(nonatomic) float progress;                        // 0.0 .. 1.0, default is 0.0. values outside are pinned.
@property (nullable, readwrite, nonatomic, strong) UIColor *color UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, nullable) NSProgress *observedProgress;

- (void)setProgress:(float)progress animated:(BOOL)animated;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithProgressViewStyle:(LCHRosetteProgressViewStyle)style;
- (instancetype)initWithProgressViewStyle:(LCHRosetteProgressViewStyle)style withText:(nullable NSString *)text NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
