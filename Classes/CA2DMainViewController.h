//
//  CA2DMainViewController.h
//  CA2D
//
//  Created by slightair on 10/11/15.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAViewController.h"
#import "CA2DSettingsViewController.h"


@interface CA2DMainViewController : UIViewController {
	UIToolbar *toolbar_;
	UIBarButtonItem *playButtonItem_;
	UIBarButtonItem *pauseButtonItem_;
	
	CAViewController *caViewController_;
	CA2DSettingsViewController *settingsViewController_;
	UINavigationController *navigationController_;
}

- (void)clearWorld;
- (void)shuffleWorld;
- (void)playWorld;
- (void)pauseWorld;
- (void)showSettingsView;
- (void)setRule:(NSString *)rule;
- (NSString *)rule;

@end
