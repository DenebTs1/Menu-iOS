#import "DMFPSMonitor.h"
#import <QuartzCore/QuartzCore.h>

@interface DMFPSMonitor ()

@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, strong) NSTimer *fpsTimer;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation DMFPSMonitor

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFPSMonitor];
    }
    return self;
}

- (void)setupFPSMonitor {
    // Premium glass effect container
    UIVisualEffectView *fpsBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    fpsBlurView.frame = self.bounds;
    fpsBlurView.layer.cornerRadius = 0;
    fpsBlurView.clipsToBounds = YES;
    
    // Professional gradient background
    CAGradientLayer *fpsGradient = [CAGradientLayer layer];
    fpsGradient.frame = fpsBlurView.bounds;
    fpsGradient.colors = @[
        (id)[UIColor colorWithRed:0.25 green:0.45 blue:0.85 alpha:0.6].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.35 blue:0.7 alpha:0.6].CGColor
    ];
    fpsGradient.cornerRadius = 0;
    [fpsBlurView.layer insertSublayer:fpsGradient atIndex:0];
    
    // Modern label styling
    self.fpsLabel = [[UILabel alloc] initWithFrame:fpsBlurView.bounds];
    self.fpsLabel.text = @"FPS: 0";
    self.fpsLabel.textColor = [UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:1.0];
    self.fpsLabel.textAlignment = NSTextAlignmentCenter;
    self.fpsLabel.font = [UIFont monospacedSystemFontOfSize:14 weight:UIFontWeightMedium];
    
    [fpsBlurView.contentView addSubview:self.fpsLabel];
    [self addSubview:fpsBlurView];
}

- (void)startMonitoring {
    self.frameCount = 0;
    self.lastTime = CACurrentMediaTime();
    
    self.fpsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateFPS)
                                                  userInfo:nil
                                                   repeats:YES];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                 selector:@selector(frameUpdate)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                         forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
    [self.fpsTimer invalidate];
    [self.displayLink invalidate];
    self.fpsTimer = nil;
    self.displayLink = nil;
}

- (void)frameUpdate {
    self.frameCount++;
}

- (void)updateFPS {
    NSTimeInterval currentTime = CACurrentMediaTime();
    NSTimeInterval elapsed = currentTime - self.lastTime;
    float fps = self.frameCount / elapsed;
    self.lastTime = currentTime;
    self.frameCount = 0;
    
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS: %.0f", fps];
}

- (void)dealloc {
    [self stopMonitoring];
}

@end
