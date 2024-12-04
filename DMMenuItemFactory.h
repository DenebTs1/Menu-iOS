#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DMMenuItemFactory : NSObject

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title;
+ (UIView *)createMenuItemContainerWithButton:(UIButton *)button;
+ (NSArray<NSString *> *)menuItemsForSegment:(NSInteger)segment;
+ (void)setupHoverEffect:(UIButton *)button;
+ (void)setupTapAnimation:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
