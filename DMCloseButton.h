#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMCloseButton : UIView

@property (nonatomic, copy) BOOL (^onTap)(void);

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateStyle;
- (BOOL)buttonTapped;

@end

NS_ASSUME_NONNULL_END
