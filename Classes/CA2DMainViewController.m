//
//  CA2DMainViewController.m
//  CA2D
//
//  Created by slightair on 10/11/15.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CA2DMainViewController.h"
#import	"CA2DSettings.h"

#define kToolbarHeight 44
#define kFixedSpaceWidth 64

#define kCellSize 2

@interface CA2DMainViewController ()

- (void)replaceLastToolbarButton:(UIBarButtonItem *)buttonItem;

@end

@implementation CA2DMainViewController

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization.
  }
  return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	CGSize caViewSize = CGSizeMake(screenSize.width, screenSize.height - kToolbarHeight);
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarSize.height, screenSize.width, screenSize.height)];
	
	CA2DSettings *settings = [CA2DSettings sharedSettings];
	caViewController_ = [[CAViewController alloc] init];
	caViewController_.view.frame = CGRectMake(0, 0, caViewSize.width, caViewSize.height);
	[caViewController_ makeWorldWithSize:CGSizeMake(caViewSize.width / kCellSize, caViewSize.height / kCellSize) cellSize:kCellSize rule:[settings objectForKey:kCA2DSettingRule]];
	
	// toolbar settings.
	toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, caViewSize.height, screenSize.width, kToolbarHeight)];
	toolbar_.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem *clearButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearWorld)] autorelease];
	UIBarButtonItem *randomButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(shuffleWorld)] autorelease];
	UIBarButtonItem *settingButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showSettingsView)] autorelease];
	UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	spaceItem.width = kFixedSpaceWidth;
	
	playButtonItem_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playWorld)];
	pauseButtonItem_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseWorld)];
	
	NSArray *buttonItems = [NSArray arrayWithObjects:
	            clearButtonItem,
							spaceItem,
							randomButtonItem,
							spaceItem,
							settingButtonItem,
							spaceItem,
							playButtonItem_,
							nil];
	
	[toolbar_ setItems:buttonItems animated:NO];
	
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self.view addSubview:caViewController_.view];
	[self.view addSubview:toolbar_];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations.
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
  [toolbar_ release];
  [playButtonItem_ release];
  [pauseButtonItem_ release];
  [caViewController_ release];
  [settingsViewController_ release];
  [navigationController_ release];
  
  [super dealloc];
}

- (void)clearWorld {
	[self pauseWorld];
	[caViewController_ clearWorld];
}

- (void)shuffleWorld {
	[self pauseWorld];
	[caViewController_ shuffleWorld];
}

- (void)playWorld {
	[caViewController_ playWorld];
	
	[self replaceLastToolbarButton:pauseButtonItem_];
}

- (void)pauseWorld {
	[caViewController_ pauseWorld];
	
	[self replaceLastToolbarButton:playButtonItem_];
}

- (void)showSettingsView {
	[self pauseWorld];
	
	if (!navigationController_) {
		settingsViewController_ = [[CA2DSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
		settingsViewController_.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		
		navigationController_ = [[UINavigationController alloc] initWithRootViewController:settingsViewController_];
		navigationController_.navigationBar.barStyle = UIBarStyleBlack;
		UINavigationItem *rootItem = [navigationController_.navigationBar.items objectAtIndex:0];
		rootItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:settingsViewController_ action:@selector(close)];
	}
	
	[self presentModalViewController:navigationController_ animated:YES];
}

- (void)setRule:(NSString *)rule {
	caViewController_.rule = rule;
}

- (NSString *)rule {
	return caViewController_.rule;
}

#pragma mark -
#pragma mark PrivateMethods

- (void)replaceLastToolbarButton:(UIBarButtonItem *)buttonItem {
	NSMutableArray *buttonItems = [NSMutableArray arrayWithArray:[toolbar_ items]];
	[buttonItems removeLastObject];
	[buttonItems addObject:buttonItem];
	
	[toolbar_ setItems:[NSArray arrayWithArray:buttonItems] animated:NO];
}

@end
