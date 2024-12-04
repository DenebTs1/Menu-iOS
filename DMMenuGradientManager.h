#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMMenuGradientManager : NSObject

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) CGFloat animationProgress;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
- (void)updateGradient;
- (void)updateFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
