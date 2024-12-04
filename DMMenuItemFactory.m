#import "DMMenuItemFactory.h"
#import "DMMenuAnimator.h"

@implementation DMMenuItemFactory

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    [self setupHoverEffect:button];
    [self setupTapAnimation:button];
    
    return button;
}

+ (UIView *)createMenuItemContainerWithButton:(UIButton *)button {
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    container.layer.cornerRadius = 10;
    [container addSubview:button];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.topAnchor constraintEqualToAnchor:container.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [button.heightAnchor constraintEqualToConstant:50]
    ]];
    
    return container;
}

+ (NSArray<NSString *> *)menuItemsForSegment:(NSInteger)segment {
    switch (segment) {
        case 0: // First element
            return @[@"Dashboard", @"Analytics", @"Reports", @"Statistics"];
        case 1: // Profile
            return @[@"Personal Info", @"Security", @"Preferences", @"Notifications"];
        case 2: // Settings
            return @[@"General", @"Display", @"Privacy", @"Advanced"];
        default:
            return @[];
    }
}

+ (void)setupHoverEffect:(UIButton *)button {
    UIHoverGestureRecognizer *hover = [[UIHoverGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(handleHover:)];
    [button addGestureRecognizer:hover];
}

+ (void)handleHover:(UIHoverGestureRecognizer *)gesture {
    UIView *button = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [DMMenuAnimator animateHoverBegin:button];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [DMMenuAnimator animateHoverEnd:button];
    }
}

+ (void)setupTapAnimation:(UIButton *)button {
    [button addTarget:self
              action:@selector(buttonTouchDown:)
    forControlEvents:UIControlEventTouchDown];
    
    [button addTarget:self
              action:@selector(buttonTouchUp:)
    forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

+ (void)buttonTouchDown:(UIButton *)button {
    [DMMenuAnimator animateTapDown:button];
}

+ (void)buttonTouchUp:(UIButton *)button {
    [DMMenuAnimator animateTapUp:button];
}

@end
