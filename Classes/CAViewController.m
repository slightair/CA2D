//
//  CAViewController.m
//  CA2D
//
//  Created by slightair on 10/11/03.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CAViewController.h"

#define kUpdateInterval 0.05

enum ruleParams {
  kSurvive,
  kBorn,
  kNumConditions
};

@implementation CAViewController

@synthesize rule = rule_;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  self.view = [[[CAView alloc] initWithFrame:CGRectZero] autorelease];
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
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [cells_ release];
  [rule_ release];
  
  [super dealloc];
}

- (void)makeWorldWithSize:(CGSize)worldSize cellSize:(CGFloat)cellSize rule:(NSString *)rule {
  worldSize_ = worldSize;
  cellSize_ = cellSize;
  worldLength_ = sizeof(unsigned char) * (int)worldSize.width * (int)worldSize.height;
  
  self.rule = rule;
  
  CAView *caView = (CAView *)self.view;
  caView.worldSize = worldSize;
  caView.cellSize = cellSize;
  
  [self shuffleWorld];
}

- (void)playWorld {
  timer_ = [NSTimer scheduledTimerWithTimeInterval:kUpdateInterval target:self selector:@selector(tickWorld:) userInfo:nil repeats:YES];
}

- (void)pauseWorld {
  [timer_ invalidate];
  timer_ = nil;
}

- (void)clearWorld {
  unsigned char *raw = (unsigned char *)malloc(worldLength_);
  int i;
  
  for(i=0;i<worldLength_;i++){
    raw[i] = 0;
  }
  
  [cells_ autorelease];
  cells_ = [[NSData alloc] initWithBytesNoCopy:raw length:worldLength_];
  
  CAView *caView = (CAView *)self.view;
  caView.cells = (unsigned char *)[cells_ bytes];
  [caView setNeedsDisplay];
}

- (void)shuffleWorld {
  unsigned char *raw = (unsigned char *)malloc(worldLength_);
  int w = (int)worldSize_.width;
  int h = (int)worldSize_.height;
  int i;
  
  int x, y;
  i = 0;
  for(y=0;y<h;y++){
    for(x=0;x<w;x++){
      if(random() % 20 == 0){
        raw[i] = (unsigned char)(numConditions_ - 1);
      }
      else{
        raw[i] = 0;
      }
      i++;
    }
  }
  
  [cells_ autorelease];
  cells_ = [[NSData alloc] initWithBytesNoCopy:raw length:worldLength_];
  
  CAView *caView = (CAView *)self.view;
  caView.cells = (unsigned char *)[cells_ bytes];
  [caView setNeedsDisplay];
}

- (void)tickWorld:(NSTimer *)timer {
  unsigned char *prevCells = (unsigned char *)[cells_ bytes];
  unsigned char *cells = (unsigned char *)malloc(worldLength_);
  
  int x, y, i, j, count;
  int w = (int)worldSize_.width;
  int h = (int)worldSize_.height;
  int lastX = w - 1;
  int lastY = h - 1;
  unsigned char condMax = (unsigned char)(numConditions_ - 1);
  
  for(y=0;y<h;y++){
    for(x=0;x<w;x++){
      count = 0;
      
      if(y==0){
        // top edge
        if(x==0){
          // left edge
          if(prevCells[lastX + lastY * w] == condMax)count++;
          if(prevCells[0 + lastY * w] == condMax)count++;
          if(prevCells[1 + lastY * w] == condMax)count++;
          if(prevCells[lastX + 0 * w] == condMax)count++;
          if(prevCells[lastX + 1 * w] == condMax)count++;
          
          for(j=0;j<=1;j++){
            for(i=0;i<=1;i++){
              if(prevCells[i + j * w] == condMax)count++;
            }
          }
        }
        else if(x==lastX){
          // right edge
          if(prevCells[(lastX-1) + lastY * w] == condMax)count++;
          if(prevCells[lastX + lastY * w] == condMax)count++;
          if(prevCells[0 + lastY * w] == condMax)count++;
          if(prevCells[0 + 0 * w] == condMax)count++;
          if(prevCells[0 + 1 * w] == condMax)count++;
          
          for(j=0;j<=1;j++){
            for(i=lastX-1;i<=lastX;i++){
              if(prevCells[i + j * w] == condMax)count++;
            }
          }
        }
        else{
          for(i=x-1;i<=x+1;i++){
            if(prevCells[i + lastY * w] == condMax)count++;
          }
          
          for(j=0;j<=1;j++){
            for(i=x-1;i<=x+1;i++){
              if(prevCells[i + j * w] == condMax)count++;
            }
          }
        }
      }
      else if(y==lastY){
        // bottom edge
        if(x==0){
          // left edge
          for(j=lastY-1;j<=lastY;j++){
            for(i=0;i<=1;i++){
              if(prevCells[i + j * w] == condMax)count++;
            }
          }
          if(prevCells[lastX + (lastY-1) * w] == condMax)count++;
          if(prevCells[lastX + lastY * w] == condMax)count++;
          if(prevCells[lastX + 0 * w] == condMax)count++;
          if(prevCells[0 + 0 * w] == condMax)count++;
          if(prevCells[1 + 0 * w] == condMax)count++;
        }
        else if(x==lastX){
          // right edge
          for(j=lastY-1;j<=lastY;j++){
            for(i=lastX-1;i<=lastX;i++){
              count += prevCells[i + j * w] == condMax ? 1 : 0;
            }
          }
          count += prevCells[0 + (lastY-1) * w] == condMax ? 1 : 0;
          count += prevCells[0 + lastY * w] == condMax ? 1 : 0;
          count += prevCells[(lastX-1) + 0 * w] == condMax ? 1 : 0;
          count += prevCells[lastX + 0 * w] == condMax ? 1 : 0;
          count += prevCells[0 + 0 * w] == condMax ? 1 : 0;
        }
        else{
          for(i=x-1;i<=x+1;i++){
            if(prevCells[i + 0 * w] == condMax)count++;
          }
          
          for(j=lastY-1;j<=lastY;j++){
            for(i=x-1;i<=x+1;i++){
              if(prevCells[i + j * w] == condMax)count++;
            }
          }
        }
      }
      else if(x==0){
        // left edge
        for(j=y-1;j<=y+1;j++){
          for(i=0;i<=1;i++){
            if(prevCells[i + j * w] == condMax)count++;
          }
          if(prevCells[lastX + j * w] == condMax)count++;
        }
      }
      else if(x==lastX){
        // right edge
        for(j=y-1;j<=y+1;j++){
          for(i=lastX-1;i<=lastX;i++){
            count += prevCells[i + j * w] == condMax ? 1 : 0;
          }
          count += prevCells[0 + j * w] == condMax ? 1 : 0;
        }
      }
      else{
        for(j=y-1;j<=y+1;j++){
          for(i=x-1;i<=x+1;i++){
            if(prevCells[i + j * w] == condMax)count++;
          }
        }
      }
      
      if(prevCells[x + y * w] == condMax)count--;
      
      NSUInteger env = 0;
      if(count > 0){
        env = (1 << (count - 1));
      } 
      
      unsigned char prevCond = prevCells[x + y * w];
      if(prevCond == 0 && born_ & env){
        cells[x + y * w] = condMax;
      }
      else if(prevCond == condMax && survive_ & env){
        cells[x + y * w] = prevCond;
      }
      else{
        if(prevCond > 0){
          cells[x + y * w] = prevCond - 1;
        }
        else{
          cells[x + y * w] = 0;
        }
      }
    }
  }
  
  [cells_ autorelease];
  cells_ = [[NSData alloc] initWithBytesNoCopy:cells length:worldLength_];
  
  CAView *caView = (CAView *)self.view;
  caView.cells = (unsigned char *)[cells_ bytes];
  [caView setNeedsDisplay];
}

- (void)setRule:(NSString *)rule {
  const char *str;
  NSArray *params;
  char tmp[2];
  int i;
  
  [rule_ autorelease];
  rule_ = [rule retain];
  
  params = [rule componentsSeparatedByString:@"/"];
  
  str = [[params objectAtIndex:kSurvive] UTF8String];
  survive_ = 0;
  for(i=0;i<strlen(str);i++){
    snprintf(tmp, 2, "%c", str[i]);
    survive_ += 1 << (atoi(tmp) - 1);
  }
  
  str = [[params objectAtIndex:kBorn] UTF8String];
  born_ = 0;
  for(i=0;i<strlen(str);i++){
    snprintf(tmp, 2, "%c", str[i]);
    born_ += 1 << (atoi(tmp) - 1);
  }
  
  numConditions_ = [[params objectAtIndex:kNumConditions] integerValue];
  
  CAView *caView = (CAView *)self.view;
  caView.numConditions = numConditions_;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (timer_) {
    isNeedRestart_ = YES;
  }
  [self pauseWorld];
  
  UITouch *touch = [touches anyObject];
  unsigned char *cells = (unsigned char *)[cells_ bytes];
  CGPoint point = [touch locationInView:self.view];
  NSInteger index = (int)(point.x / cellSize_) + (int)(point.y / cellSize_) * (int)worldSize_.width;
  cells[index] = (unsigned char)(numConditions_ - 1);
  
  [self.view setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  unsigned char *cells = (unsigned char *)[cells_ bytes];
  CGPoint point = [touch locationInView:self.view];
  NSInteger index = (int)(point.x / cellSize_) + (int)(point.y / cellSize_) * (int)worldSize_.width;
  cells[index] = (unsigned char)(numConditions_ - 1);
  
  [self.view setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  unsigned char *cells = (unsigned char *)[cells_ bytes];
  CGPoint point = [touch locationInView:self.view];
  NSInteger index = (int)(point.x / cellSize_) + (int)(point.y / cellSize_) * (int)worldSize_.width;
  cells[index] = (unsigned char)(numConditions_ - 1);
  
  [self.view setNeedsDisplay];
  
  if (isNeedRestart_) {
    [self playWorld];
    
    isNeedRestart_ = NO;
  }
}

@end
