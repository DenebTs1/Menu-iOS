#import "DMMenuGestureHandler.h"

@interface DMMenuGestureHandler () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, assign) CGPoint lastPanPoint;

@end

@implementation DMMenuGestureHandler

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.targetView = view;
        self.currentScale = 1.0;
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)setupGestureRecognizers {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    
    self.panGesture.delegate = self;
    self.pinchGesture.delegate = self;
    
    [self.targetView addGestureRecognizer:self.panGesture];
    [self.targetView addGestureRecognizer:self.pinchGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.targetView.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastPanPoint = self.targetView.center;
    }
    
    CGPoint newCenter = CGPointMake(self.lastPanPoint.x + translation.x,
                                  self.lastPanPoint.y + translation.y);
    
    // Limiter le déplacement aux bords de l'écran
    CGRect bounds = self.targetView.superview.bounds;
    CGFloat halfWidth = CGRectGetWidth(self.targetView.frame) / 2.0;
    CGFloat halfHeight = CGRectGetHeight(self.targetView.frame) / 2.0;
    
    newCenter.x = MAX(halfWidth, MIN(bounds.size.width - halfWidth, newCenter.x));
    newCenter.y = MAX(halfHeight, MIN(bounds.size.height - halfHeight, newCenter.y));
    
    [self.delegate menuDidMove:newCenter];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate menuDidFinishInteraction];
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        gesture.scale = self.currentScale;
    }
    
    CGFloat newScale = gesture.scale;
    newScale = MAX(0.8, MIN(newScale, 1.2));
    self.currentScale = newScale;
    
    [self.delegate menuDidScale:newScale];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate menuDidFinishInteraction];
    }
}

- (void)resetScale {
    self.currentScale = 1.0;
    [self.delegate menuDidScale:1.0];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
