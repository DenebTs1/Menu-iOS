#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMDraggableMenu : UIView

@property (nonatomic, strong, readonly) UIVisualEffectView *blurView;
@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong, readonly) UILabel *headerTitleLabel;
@property (nonatomic, assign, readonly) CGSize originalSize;
@property (nonatomic, assign, readonly) CGFloat currentScale;
@property (nonatomic, assign, getter=isVisible) BOOL visible;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setupMenu;
- (void)show;
- (void)hide;
- (void)updateLayoutForScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
