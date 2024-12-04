#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DMMenuGestureHandlerDelegate <NSObject>

- (void)menuDidScale:(CGFloat)scale;
- (void)menuDidMove:(CGPoint)position;
- (void)menuDidFinishInteraction;

@end

@interface DMMenuGestureHandler : NSObject

@property (nonatomic, weak) id<DMMenuGestureHandlerDelegate> delegate;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, assign) CGPoint originalPosition;
@property (nonatomic, assign) CGFloat currentScale;

- (instancetype)initWithView:(UIView *)view;
- (void)setupGestureRecognizers;
- (void)resetScale;

@end

NS_ASSUME_NONNULL_END
