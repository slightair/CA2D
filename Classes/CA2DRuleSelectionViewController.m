//
//  CA2DRuleSelectionViewController.m
//  CA2D
//
//  Created by slightair on 10/11/21.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CA2DRuleSelectionViewController.h"
#import "CA2DSettings.h"

#define kNumberOfSection 1
#define kRuleSection 0

@interface CA2DRuleSelectionViewController ()

@property (nonatomic, strong) NSArray *rules;

@end

@implementation CA2DRuleSelectionViewController

- (void)didPressedCancelButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rules = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return kNumberOfSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.rules count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSDictionary *ruleDict = [self.rules objectAtIndex:indexPath.row];

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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CA2DSettings *settings = [CA2DSettings sharedSettings];

    NSInteger selectedRuleIndex = [[settings objectForKey:kCA2DSettingRuleIndex] integerValue];

    if (indexPath.row != selectedRuleIndex) {
        NSDictionary *ruleDict = [self.rules objectAtIndex:indexPath.row];

        UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRuleIndex inSection:kRuleSection]];
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        prevCell.accessoryType = UITableViewCellAccessoryNone;
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

        [settings setObject:[ruleDict objectForKey:@"rule"] forKey:kCA2DSettingRule];
        [settings setObject:[NSNumber numberWithInteger:indexPath.row] forKey:kCA2DSettingRuleIndex];
    }

    [self dismissModalViewControllerAnimated:YES];
}

@end