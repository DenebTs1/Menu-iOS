#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMFPSMonitor : UIView

@property (nonatomic, strong, readonly) UILabel *fpsLabel;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)startMonitoring;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
