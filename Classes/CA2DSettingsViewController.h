//
//  CA2DSettingsViewController.h
//  CA2D
//
//  Created by slightair on 10/11/21.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA2DRuleSelectionViewController.h"

@interface CA2DSettingsViewController : UITableViewController {
  CA2DRuleSelectionViewController *ruleSelectionViewController_;
}

- (void)close;

@end
