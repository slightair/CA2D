//
//  CA2DMainViewController.h
//  CA2D
//
//  Created by slightair on 10/11/15.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAViewController.h"

@interface CA2DMainViewController : UIViewController

- (void)shuffleWorld;
- (void)playWorld;
- (void)pauseWorld;
- (void)setRule:(NSString *)rule;
- (NSString *)rule;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIView *contentView;

- (IBAction)didTappedView:(id)sender;
- (IBAction)didTappedShuffleButton:(id)sender;
- (IBAction)didTappedToggleButton:(id)sender;

@end
