//
//  MatchHeaderCollectionReusableView.m
//  Memento
//
//  Created by Andrey Morozov on 01.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "MatchHeaderCollectionReusableView.h"

@interface MatchHeaderCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation MatchHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timerLabel.text = @"00:00.00";
    [self startTimer];
}

- (IBAction)closeButton:(id)sender {
    self.cancelBlock();
}

- (void)startTimer {
    self.isRunning = YES;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
}

- (void)updateTimer {
    self.count++;
    int min = floor(self.count/100/60);
    int sec = floor(self.count/100);
    int msec = self.count % 100;
    
    if (sec >= 60) {
        sec = sec % 60;
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d.%02d", min, sec, msec];
}

- (NSString *)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    return self.timerLabel.text;
}


@end
