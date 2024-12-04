#import "DMDraggableMenu.h"
#import "DMMenuAnimator.h"
#import "DMMenuItemFactory.h"

@interface DMDraggableMenu ()

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, strong) UIStackView *menuItemsStackView;

@end

@implementation DMDraggableMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originalSize = frame.size;
        self.currentScale = 1.0;
        [self setupMenu];
    }
    return self;
}

- (void)setupMenu {
    [self createMenuView];
    [self setupBlurEffect];
    [self setupHeader];
    [self setupMenuContent];
}

- (void)createMenuView {
    self.layer.cornerRadius = 20;
    self.clipsToBounds = YES;
    self.autoresizesSubviews = YES;
}

- (void)setupBlurEffect {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.bounds;
    [self addSubview:self.blurView];
}

- (void)setupHeader {
    // Create header container
    UIView *headerView = [[UIView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.blurView.contentView addSubview:headerView];
    
    // Setup title label
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerTitleLabel.text = @"First element";
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    [headerView addSubview:self.headerTitleLabel];
    
    // Setup segmented control
    [self setupSegmentedControl:headerView];
    
    // Setup separator line
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    separatorLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [headerView addSubview:separatorLine];
    
    // Layout constraints for header
    [NSLayoutConstraint activateConstraints:@[
        [headerView.leadingAnchor constraintEqualToAnchor:self.blurView.contentView.leadingAnchor],
        [headerView.trailingAnchor constraintEqualToAnchor:self.blurView.contentView.trailingAnchor],
        [headerView.topAnchor constraintEqualToAnchor:self.blurView.contentView.topAnchor],
        [headerView.heightAnchor constraintEqualToConstant:120],
        
        [self.headerTitleLabel.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:20],
        [self.headerTitleLabel.topAnchor constraintEqualToAnchor:headerView.topAnchor constant:20],
        
        [self.segmentedControl.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:20],
        [self.segmentedControl.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-20],
        [self.segmentedControl.topAnchor constraintEqualToAnchor:self.headerTitleLabel.bottomAnchor constant:20],
        
        [separatorLine.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor],
        [separatorLine.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor],
        [separatorLine.bottomAnchor constraintEqualToAnchor:headerView.bottomAnchor],
        [separatorLine.heightAnchor constraintEqualToConstant:0.5]
    ]];
}

- (void)setupSegmentedControl:(UIView *)headerView {
    NSArray *items = @[@"First element", @"Profile", @"Settings"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentedControl.selectedSegmentIndex = 0;
    
    // Style the segmented control
    self.segmentedControl.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [self.segmentedControl setTitleTextAttributes:@
    {
        //NSForegroundColorAttributeName: [UIColor whiteColor]
    } forState:UIControlStateNormal];
    
    [headerView addSubview:self.segmentedControl];
    
    [self.segmentedControl addTarget:self
                            action:@selector(segmentChanged:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    [UIView transitionWithView:self.headerTitleLabel
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        self.headerTitleLabel.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    } completion:nil];
    
    [self updateMenuItemsForSegment:sender.selectedSegmentIndex];
}

- (void)setupMenuContent {
    self.menuItemsStackView = [[UIStackView alloc] init];
    self.menuItemsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuItemsStackView.axis = UILayoutConstraintAxisVertical;
    self.menuItemsStackView.spacing = 10;
    self.menuItemsStackView.alignment = UIStackViewAlignmentFill;
    [self.blurView.contentView addSubview:self.menuItemsStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.menuItemsStackView.topAnchor constraintEqualToAnchor:self.blurView.contentView.topAnchor constant:140],
        [self.menuItemsStackView.leadingAnchor constraintEqualToAnchor:self.blurView.contentView.leadingAnchor constant:20],
        [self.menuItemsStackView.trailingAnchor constraintEqualToAnchor:self.blurView.contentView.trailingAnchor constant:-20],
        [self.menuItemsStackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.blurView.contentView.bottomAnchor constant:-20]
    ]];
    
    [self updateMenuItemsForSegment:0];
}

- (void)updateMenuItemsForSegment:(NSInteger)segment {
    for (UIView *view in self.menuItemsStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    NSArray *menuItems = [DMMenuItemFactory menuItemsForSegment:segment];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (NSString *title in menuItems) {
            UIButton *button = [DMMenuItemFactory createMenuButtonWithTitle:title];
            UIView *container = [DMMenuItemFactory createMenuItemContainerWithButton:button];
            [self.menuItemsStackView addArrangedSubview:container];
        }
    }];
}

- (void)show {
    self.visible = YES;
    [DMMenuAnimator animateShow:self completion:nil];
}

- (void)hide {
    self.visible = NO;
    [DMMenuAnimator animateHide:self completion:nil];
}

- (void)updateLayoutForScale:(CGFloat)scale {
    self.currentScale = scale;
    [DMMenuAnimator animateScale:self toScale:scale];
}

@end
