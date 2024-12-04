#import "DMMenuAnimator.h"

@implementation DMMenuAnimator

+ (void)animateShow:(UIView *)view completion:(nullable void (^)(void))completion {
    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    view.alpha = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

+ (void)animateHide:(UIView *)view completion:(nullable void (^)(void))completion {
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

+ (void)animateScale:(UIView *)view toScale:(CGFloat)scale {
    CGFloat clampedScale = MIN(MAX(scale, 0.8), 1.2);
    
    [UIView animateWithDuration:0.2
                     animations:^{
        view.transform = CGAffineTransformMakeScale(clampedScale, clampedScale);
    }];
}

+ (void)animateHoverBegin:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.02, 1.02);
        view.alpha = 0.8;
    }];
}

+ (void)animateHoverEnd:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }];
}

+ (void)animateTapDown:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(0.97, 0.97);
        view.alpha = 0.8;
    }];
}

+ (void)animateTapUp:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1.0;
    }];
}

@end
