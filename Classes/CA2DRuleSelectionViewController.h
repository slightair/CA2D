//
//  CA2DRuleSelectionViewController.h
//  CA2D
//
//  Created by slightair on 10/11/21.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA2DRuleSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)didPressedCancelButton:(id)sender;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
