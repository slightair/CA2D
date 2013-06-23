//
//  CA2DAppDelegate.h
//  CA2D
//
//  Created by slightair on 10/11/21.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CA2DMainViewController.h"

@interface CA2DAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end
