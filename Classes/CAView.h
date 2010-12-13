//
//  CAView.h
//  CA2D
//
//  Created by slightair on 10/11/03.
//  Copyright 2010 slightair. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CAView : UIView {
  unsigned char *cells_;
  CGSize worldSize_;
  CGFloat cellSize_;
  NSUInteger numConditions_;
  unsigned char *raw_;
}

- (void)allocateRawData;

@property (nonatomic) unsigned char *cells;
@property (nonatomic) CGSize worldSize;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) NSUInteger numConditions;

@end
