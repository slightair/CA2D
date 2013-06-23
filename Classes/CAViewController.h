//
//  CAViewController.h
//  CA2D
//
//  Created by slightair on 10/11/03.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAView.h"

@interface CAViewController : UIViewController {
  NSInteger worldLength_;
  CGSize worldSize_;
  CGFloat cellSize_;
  NSData *cells_;
  NSString *rule_;
  NSUInteger born_;
  NSUInteger survive_;
  NSUInteger numConditions_;
  NSTimer *timer_;
  BOOL isNeedRestart_;
}

- (void)makeWorldWithSize:(CGSize)worldSize cellSize:(CGFloat)cellSize rule:(NSString *)rule;
- (void)playWorld;
- (void)pauseWorld;
- (void)clearWorld;
- (void)shuffleWorld;
- (void)tickWorld:(NSTimer *)timer;
- (NSTimer *)timer;

@property(nonatomic, strong) NSString *rule;

@end

