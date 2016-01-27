//
//  ViewController.m
//  CustomSpinner
//
//  Created by Geddam Subramanyam, Jeevan Kumar on 1/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ViewController.h"
#import "LCHRosetteProgressView.h"
#import "LCHRosetteHUDView.h"

@interface ViewController ()
@property NSProgress *progress;
@property UIProgressView *progressView;
@property LCHRosetteProgressView *lchProgressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor brownColor];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUInteger batchSize = 20;
    self.progress = [NSProgress progressWithTotalUnitCount:batchSize];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, 100, 100);
    self.progressView.center = self.view.center;
    //self.progressView.observedProgress = self.progress;
    [self.view addSubview:self.progressView];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerInvoked) userInfo:nil repeats:YES];
    
    LCHRosetteHUDView *hudView = [[LCHRosetteHUDView alloc] initWithRosetteHUDStyle:LCHRosetteHUDViewStyleBlue withText:@"Connecting"];
    //hudView.frame = CGRectMake(0, 0, 200, 200);
    hudView.hidesWhenStopped = NO;
    [self.view addSubview:hudView];
    [hudView startAnimating];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hudView stopAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hudView startAnimating];
    });
    
    
    self.lchProgressView = [[LCHRosetteProgressView alloc] initWithProgressViewStyle:LCHRosetteProgressViewStyleBlue withText:@"Connecting"];
    self.lchProgressView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, 0, 150, 150);
    self.lchProgressView.observedProgress = self.progress;
    [self.view addSubview:self.lchProgressView];
    
    //[self.lchProgressView setProgress:1.0 animated:YES];
}

- (void) timerInvoked {
    self.progress.completedUnitCount < 20 ? [self.progress setCompletedUnitCount:++self.progress.completedUnitCount] : nil;
    [self.progressView setProgress:0.9 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
