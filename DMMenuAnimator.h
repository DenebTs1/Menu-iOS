#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMMenuAnimator : NSObject

+ (void)animateShow:(UIView *)view completion:(nullable void (^)(void))completion;
+ (void)animateHide:(UIView *)view completion:(nullable void (^)(void))completion;
+ (void)animateScale:(UIView *)view toScale:(CGFloat)scale;
+ (void)animateHoverBegin:(UIView *)view;
+ (void)animateHoverEnd:(UIView *)view;
+ (void)animateTapDown:(UIView *)view;
+ (void)animateTapUp:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
