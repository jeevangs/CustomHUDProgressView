//
//  LCHRosetteHUDView.m
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "LCHRosetteHUDView.h"
#import "LCHRosetteView.h"

@interface LCHRosetteHUDView()

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) LCHRosetteView *rosetteView;

@end

@implementation LCHRosetteHUDView

- (instancetype)initWithRosetteHUDStyle:(LCHRosetteHUDViewStyle)style withText:(NSString *)text {
    CGRect frameToBeUsed = CGRectZero;
    if(style == LCHRosetteHUDViewStyleBlueLarge) {
        frameToBeUsed = CGRectMake(0, 0, 300, 300);
    }
    else {
        frameToBeUsed = CGRectMake(0, 0, 150, 150);
    }
    self = [super initWithFrame:frameToBeUsed];
    if(self) {
        self.hidesWhenStopped = YES;
        self.rosetteViewStyle = style;
        self.backgroundColor = [UIColor clearColor];
        
        self.rosetteView = [[LCHRosetteView alloc] init];
        self.rosetteView.translatesAutoresizingMaskIntoConstraints = NO;
        self.rosetteView.text = text;
        [self addSubview:self.rosetteView];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_rosetteView);
        
        NSArray *constraints = @[
                                 @"H:|-0-[_rosetteView]-0-|",
                                 @"V:|-0-[_rosetteView]-0-|"
                                 ];
        for (NSString *constraint in constraints){
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:viewsDictionary]];
        }
        
        [self.rosetteView drawRosetteViewForControl:LCHRosetteViewControlHUDView];
        if(style == LCHRosetteHUDViewStyleBlue || style == LCHRosetteHUDViewStyleBlueLarge) {
            self.rosetteView.color = [UIColor blueColor];
        }
        else {
            self.rosetteView.color = [UIColor whiteColor];
        }
    }
    return self;
}

- (instancetype)initWithRosetteHUDStyle:(LCHRosetteHUDViewStyle)style {
    return [self initWithRosetteHUDStyle:style withText:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:_hidesWhenStopped forKey:@"hidesWhenStopped"];
    [aCoder encodeObject:_color forKey:@"color"];
    [aCoder encodeBool:_isAnimating forKey:@"isAnimating"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.isAnimating = [aDecoder decodeBoolForKey:@"isAnimating"];
        self.hidesWhenStopped = [aDecoder decodeBoolForKey:@"hidesWhenStopped"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.hidesWhenStopped = YES;
        self.rosetteViewStyle = LCHRosetteHUDViewStyleBlueLarge;
        self.color = [UIColor blueColor];
    }
    return self;
}

- (void)startAnimating {
    self.isAnimating = YES;
    [self.rosetteView animateIndeterministicProgressView];
}

- (void)stopAnimating {
    self.isAnimating = NO;
    [self.rosetteView stopAnimatingIndeterministicProgressView:self.hidesWhenStopped];
}

# pragma mark - Custom Setter/Getter methods -

- (BOOL)isAnimating {
    return _isAnimating;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.rosetteView.color = color;
}

@end
