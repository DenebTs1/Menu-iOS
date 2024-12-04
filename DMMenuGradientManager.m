#import "DMMenuGradientManager.h"

@interface DMMenuGradientManager ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation DMMenuGradientManager

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self setupGradientWithFrame:frame];
    }
    return self;
}

- (void)setupGradientWithFrame:(CGRect)frame {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = frame;
    self.gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.8].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:0.8].CGColor,
        (id)[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.8].CGColor
    ];
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.locations = @[@0.0, @0.5, @1.0];
}

- (void)startAnimation {
    [self.displayLink invalidate];
    self.animationProgress = 0.0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGradient)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)updateGradient {
    self.animationProgress += 0.005;
    if (self.animationProgress > 1.0) {
        self.animationProgress = 0.0;
    }
    
    CGFloat locations[3] = {
        fmod(self.animationProgress, 1.0),
        fmod(self.animationProgress + 0.5, 1.0),
        fmod(self.animationProgress + 1.0, 1.0)
    };
    
    self.gradientLayer.locations = @[
        @(locations[0]),
        @(locations[1]),
        @(locations[2])
    ];
}

- (void)updateFrame:(CGRect)frame {
    self.gradientLayer.frame = frame;
}

- (void)dealloc {
    [self stopAnimation];
}

@end
