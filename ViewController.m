#import "ViewController.h"
#import "DMFPSMonitor.h"
#import "DMDraggableMenu.h"
#import "DMMenuGradientManager.h"
#import "DMMenuGestureHandler.h"
#import "DMCloseButton.h"

@interface ViewController () <DMMenuGestureHandlerDelegate>

@property (nonatomic, strong) DMDraggableMenu *menuView;
@property (nonatomic, strong) DMFPSMonitor *fpsMonitor;
@property (nonatomic, strong) DMMenuGradientManager *gradientManager;
@property (nonatomic, strong) DMMenuGestureHandler *gestureHandler;
@property (nonatomic, strong) DMCloseButton *closeButton;
@property (nonatomic, assign) BOOL isMenuVisible;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];
    [self setupMenu];
    [self setupCloseButton];
    [self setupFPSMonitor];
}

- (void)setupBackground {
    UIColor *backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    
    CAGradientLayer *backgroundGradient = [CAGradientLayer layer];
    backgroundGradient.frame = self.view.bounds;
    backgroundGradient.colors = @[
        (id)[UIColor colorWithRed:0.12 green:0.15 blue:0.22 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.06 green:0.08 blue:0.12 alpha:1.0].CGColor
    ];
    [self.view.layer insertSublayer:backgroundGradient atIndex:0];
}

- (void)setupMenu {
    // Create menu
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = 375;
    CGFloat centerX = (screenBounds.size.width - width) / 2;
    CGFloat centerY = (screenBounds.size.height - 400) / 2;
    
    self.menuView = [[DMDraggableMenu alloc] initWithFrame:CGRectMake(centerX, centerY, width, 400)];
    [self.view addSubview:self.menuView];
    
    // Setup gradient
    self.gradientManager = [[DMMenuGradientManager alloc] initWithFrame:self.menuView.bounds];
    [self.menuView.layer insertSublayer:self.gradientManager.gradientLayer atIndex:0];
    [self.gradientManager startAnimation];
    
    // Setup gesture handler
    self.gestureHandler = [[DMMenuGestureHandler alloc] initWithView:self.menuView];
    self.gestureHandler.delegate = self;
    self.gestureHandler.originalPosition = self.menuView.center;
    
    self.isMenuVisible = YES;
}

- (void)setupCloseButton {
    self.closeButton = [[DMCloseButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 180, 0, 100, 36)];
    
    __weak typeof(self) weakSelf = self;
    self.closeButton.onTap = ^BOOL{
        [weakSelf closeButtonTapped];
        return weakSelf.isMenuVisible;
    };
    
    [self.view addSubview:self.closeButton];
}

- (void)setupFPSMonitor {
    self.fpsMonitor = [[DMFPSMonitor alloc] initWithFrame:CGRectMake(0, 50, 100, 30)];
    [self.view addSubview:self.fpsMonitor];
    [self.fpsMonitor startMonitoring];
}

- (void)closeButtonTapped {
    if (self.isMenuVisible) {
        [self.menuView hide];
        [self.gradientManager stopAnimation];
    } else {
        [self.menuView show];
        [self.gradientManager startAnimation];
    }
    self.isMenuVisible = !self.isMenuVisible;
}

#pragma mark - DMMenuGestureHandlerDelegate

- (void)menuDidScale:(CGFloat)scale {
    [self.menuView updateLayoutForScale:scale];
    [self.gradientManager updateFrame:self.menuView.bounds];
}

- (void)menuDidMove:(CGPoint)position {
    self.menuView.center = position;
}

- (void)menuDidFinishInteraction 
{
    if (self.menuView.currentScale != 1.0) {
        [self.menuView updateLayoutForScale:1.0];
    }
}

@end
