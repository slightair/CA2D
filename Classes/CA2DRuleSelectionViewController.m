//
//  CA2DRuleSelectionViewController.m
//  CA2D
//
//  Created by slightair on 10/11/21.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CA2DRuleSelectionViewController.h"
#import "CA2DSettingsViewController.h"
#import "CA2DSettings.h"

#define kNumberOfSection 1
#define kRuleSection 0

@implementation CA2DRuleSelectionViewController


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
  // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization.
    rules_ = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"]];
    self.title = @"Rules";
  }
  return self;
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations.
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return kNumberOfSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [rules_ count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }

  // Configure the cell...
  NSDictionary *ruleDict = [rules_ objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [ruleDict objectForKey:@"name"];
  cell.detailTextLabel.text = [ruleDict objectForKey:@"rule"];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  NSInteger selectedRuleIndex = [[[CA2DSettings sharedSettings] objectForKey:kCA2DSettingRuleIndex] integerValue];
  if (indexPath.row == selectedRuleIndex) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source.
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CA2DSettingsViewController *settingsViewController = (CA2DSettingsViewController *)[self.navigationController.viewControllers objectAtIndex:0];
  CA2DSettings *settings = [CA2DSettings sharedSettings];
  
  NSInteger selectedRuleIndex = [[settings objectForKey:kCA2DSettingRuleIndex] integerValue];
  if (indexPath.row != selectedRuleIndex) {
    NSDictionary *ruleDict = [rules_ objectAtIndex:indexPath.row];
    
    UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRuleIndex inSection:kRuleSection]];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    prevCell.accessoryType = UITableViewCellAccessoryNone;
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [settings setObject:[ruleDict objectForKey:@"rule"] forKey:kCA2DSettingRule];
    [settings setObject:[NSNumber numberWithInteger:indexPath.row] forKey:kCA2DSettingRuleIndex];
    
    [settingsViewController.tableView reloadData];
  }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [rules_ release];
  [super dealloc];
}


@end

