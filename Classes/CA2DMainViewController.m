//
//  CA2DMainViewController.m
//  CA2D
//
//  Created by slightair on 10/11/15.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CA2DMainViewController.h"
#import	"CA2DSettings.h"

#define kToolbarToggleButtonIndex 2
#define kToolbarAnimationDuration 0.3
#define kCellSize 2

@interface CA2DMainViewController ()

- (void)replaceToolbarToggleButton:(UIBarButtonItem *)buttonItem;

@property(nonatomic, strong) CAViewController *caViewController;
@property(nonatomic, strong) UIBarButtonItem *playButtonItem;
@property(nonatomic, strong) UIBarButtonItem *pauseButtonItem;

@end

@implementation CA2DMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
    CA2DSettings *settings = [CA2DSettings sharedSettings];

    CAViewController *caViewController = [[CAViewController alloc] init];
    caViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [caViewController makeWorldWithSize:CGSizeMake(screenSize.width / kCellSize, screenSize.height / kCellSize)
                               cellSize:kCellSize
                                   rule:[settings objectForKey:kCA2DSettingRule]];

    [self.contentView addSubview:caViewController.view];

    self.caViewController = caViewController;

    self.playButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(didTappedToggleButton:)];
    self.playButtonItem.style = UIBarButtonItemStyleBordered;
    self.pauseButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(didTappedToggleButton:)];
    self.pauseButtonItem.style = UIBarButtonItemStyleBordered;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didTappedView:(id)sender
{
    if (self.toolBar.hidden) {
        self.toolBar.alpha = 0.0;
        self.toolBar.hidden = NO;

        [UIView animateWithDuration:kToolbarAnimationDuration
                         animations:^{
                             self.toolBar.alpha = 1.0;
                         }];
    }
    else {
        self.toolBar.alpha = 1.0;
        [UIView animateWithDuration:kToolbarAnimationDuration
                         animations:^{
                             self.toolBar.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             self.toolBar.hidden = YES;
                         }];
    }
}

- (void)didTappedShuffleButton:(id)sender
{
    [self shuffleWorld];
}

- (void)didTappedToggleButton:(id)sender
{
    if ([self.caViewController.timer isValid]) {
        [self pauseWorld];
    }
    else {
        [self playWorld];
    }
}

- (void)shuffleWorld {
    [self pauseWorld];
    [self.caViewController shuffleWorld];
}

- (void)playWorld {
    [self.caViewController playWorld];

    [self replaceToolbarToggleButton:self.pauseButtonItem];
}

- (void)pauseWorld {
    [self.caViewController pauseWorld];

    [self replaceToolbarToggleButton:self.playButtonItem];
}

- (void)setRule:(NSString *)rule {
    self.caViewController.rule = rule;
}

- (NSString *)rule {
    return self.caViewController.rule;
}

#pragma mark -
#pragma mark PrivateMethods

- (void)replaceToolbarToggleButton:(UIBarButtonItem *)buttonItem
{
    NSMutableArray *buttonItems = [NSMutableArray arrayWithArray:[self.toolBar items]];
    [buttonItems replaceObjectAtIndex:kToolbarToggleButtonIndex withObject:buttonItem];

    [self.toolBar setItems:[NSArray arrayWithArray:buttonItems] animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRuleSelectionView"]) {
        [self pauseWorld];
    }
}

@end
