//
//  LCHRosetteProgressView.m
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "LCHRosetteProgressView.h"
#import "LCHRosetteView.h"

@interface LCHRosetteProgressView ()

@property (nonatomic, strong) LCHRosetteView *rosetteView;

@end

@implementation LCHRosetteProgressView

- (instancetype)initWithProgressViewStyle:(LCHRosetteProgressViewStyle)style withText:(nullable NSString *)text {
    CGRect frameToBeUsed = CGRectZero;
    if(style == LCHRosetteProgressViewStyleBlueLarge) {
        frameToBeUsed = CGRectMake(0, 0, 300, 300);
    }
    else {
        frameToBeUsed = CGRectMake(0, 0, 150, 150);
    }
    self = [super initWithFrame:frameToBeUsed];
    if(self) {
        self.observedProgress = nil;
        self.progressViewStyle = style;
        self.backgroundColor = [UIColor whiteColor];
        
        if(style == LCHRosetteProgressViewStyleBlue || style == LCHRosetteProgressViewStyleBlueLarge) {
            self.color = [UIColor blueColor];
        }
        else {
            self.color = [UIColor whiteColor];
        }
        
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
        
        [self.rosetteView drawRosetteViewForControl:LCHRosetteViewControlProgressView];
        self.rosetteView.color = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithProgressViewStyle:(LCHRosetteProgressViewStyle)style {
    return [self initWithProgressViewStyle:style withText:nil];
}

# pragma mark - Lifecycle -

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:@(_progress) forKey:@"progress"];
    [aCoder encodeObject:_color forKey:@"color"];
    [aCoder encodeObject:_observedProgress forKey:@"observedProgress"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.progress = [[aDecoder decodeObjectForKey:@"progress"] floatValue];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.observedProgress = [aDecoder decodeObjectForKey:@"observedProgress"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.progressViewStyle = LCHRosetteProgressViewStyleBlueLarge;
        self.color = [UIColor blueColor];
        self.rosetteView.color = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(float)progress {
    progress = (progress < 0) ? 0.0 : MIN(progress,1.0);
    _progress = progress;
    [self setProgress:_progress animated:NO];
}

- (void) setObservedProgress:(NSProgress *)observedProgress {
    _observedProgress = observedProgress;
    if(observedProgress) {
        [_observedProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

# pragma mark - KVO method -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        if(progress.fractionCompleted <= 1.0) {
            [self.rosetteView updateSpokesInRosette:progress.fractionCompleted * 24 withColor:self.color animated:YES];
        }
    }
}

# pragma mark - Progress View methods -

- (void)setProgress:(float)progress animated:(BOOL)animated {
    progress = (progress < 0) ? 0.0 : MIN(progress,1.0);
    NSUInteger numberOfSpokesToBeFilled = progress * 24;
    [self.rosetteView updateSpokesInRosette:numberOfSpokesToBeFilled withColor:self.color animated:animated];
}

@end
