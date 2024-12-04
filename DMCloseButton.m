#import "DMCloseButton.h"

@interface DMCloseButton ()

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) CAGradientLayer *gradientBorder;

@end

@implementation DMCloseButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupBlurEffect];
    [self setupCloseButton];
    [self setupGradientBorder];
    [self setupHoverEffect];
}

- (void)setupBlurEffect {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.bounds;
    self.blurView.layer.cornerRadius = self.bounds.size.height / 2;
    self.blurView.clipsToBounds = YES;
    [self addSubview:self.blurView];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.frame = self.bounds;
    [self updateButtonTitle:NO]; // Default to "Open" when menu is not visible
    [self.closeButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView.contentView addSubview:self.closeButton];
    [self setupStyle];
}

- (void)setupGradientBorder {
    self.gradientBorder = [CAGradientLayer layer];
    self.gradientBorder.frame = self.bounds;
    [self setupStyle];
    [self.layer addSublayer:self.gradientBorder];
}

- (void)setupHoverEffect {
    UIHoverGestureRecognizer *hover = [[UIHoverGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleHover:)];
    [self addGestureRecognizer:hover];
}

- (void)setupStyle {
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.gradientBorder.cornerRadius = 0; // Bouton rectangulaire
    self.gradientBorder.colors = @[
        (id)[UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.8].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:0.8].CGColor
    ];
    self.gradientBorder.startPoint = CGPointMake(0, 0);
    self.gradientBorder.endPoint = CGPointMake(1, 1);
    
    CALayer *mask = [CALayer layer];
    mask.frame = self.bounds;
    mask.cornerRadius = 0;
    mask.borderWidth = 1.0;
    mask.borderColor = [UIColor whiteColor].CGColor;
    self.gradientBorder.mask = mask;
}

- (void)updateButtonTitle:(BOOL)isVisible {
    NSString *title = isVisible ? @"Close" : @"Open";
    [self.closeButton setTitle:title forState:UIControlStateNormal];
}

- (BOOL)buttonTapped {
    if (self.onTap) {
        BOOL isVisible = self.onTap();
        [self updateButtonTitle:isVisible];
        return isVisible;
    }
    return NO; // Default return value if onTap is not set
}

- (void)handleHover:(UIHoverGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.05, 1.05);
            self.alpha = 0.8;
        }];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1.0;
        }];
    }
}

- (void)updateStyle {
    // Update gradient colors or other styling here
    [self.gradientBorder setNeedsDisplay];
}

@end
