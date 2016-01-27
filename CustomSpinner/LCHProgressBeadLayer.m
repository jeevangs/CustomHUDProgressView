//
//  LCHProgressBeadLayer.m
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "LCHProgressBeadLayer.h"

@implementation LCHProgressBeadLayer

- (id)initWithFrame:(CGRect)frame WithColor:(UIColor *)color{
    self = [super init];
    if(self) {
        self.frame = frame;
        self.backgroundColor = color.CGColor;
        self.cornerRadius = frame.size.width/2;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"The frame is %@",NSStringFromCGRect(self.frame)];
}

@end
