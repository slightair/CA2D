//
//  CAView.m
//  CA2D
//
//  Created by slightair on 10/11/03.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CAView.h"

#define kDefaultScale 1.0

@implementation CAView

@synthesize cells = cells_;
@synthesize worldSize = worldSize_;
@synthesize cellSize = cellSize_;
@synthesize numConditions = numConditions_;

enum CMYKComponents {
  kCyan,
  kMagenta,
  kYellow,
  kBlack,
  kNumberOfCMYKComponents
};

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code.
    cells_ = NULL;
    worldSize_ = CGSizeZero;
    cellSize_ = 0.0;
    numConditions_ = 0;
  }
  return self;
}

- (void)layoutSubviews {
  if ([self respondsToSelector:@selector(contentScaleFactor)]) {
    self.contentScaleFactor = 1.0;
  }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code.
  
  size_t width = (size_t)(worldSize_.width * cellSize_);
  size_t height = (size_t)(worldSize_.height * cellSize_);
  size_t bitsPerComponent = 8;
  size_t bitsPerPixel = kNumberOfCMYKComponents * bitsPerComponent;
  size_t bytesPerRow = kNumberOfCMYKComponents * width;
  CGColorSpaceRef colorSpaceCMYK = CGColorSpaceCreateDeviceCMYK();
  
  size_t rawSize = width * height * kNumberOfCMYKComponents;
  unsigned char *raw = (unsigned char *)malloc(rawSize);
  
  int i = 0;
  int x, y, ex, ey;
  unsigned char cond;
  int offset;
  
  for (y=0; y < (int)worldSize_.height; y++) {
    for(ey=0; ey < cellSize_; ey++) {
      for (x=0; x < (int)worldSize_.width; x++) {
        cond = cells_[x + (int)worldSize_.width * y];
        
        for(ex=0; ex < cellSize_; ex++) {
          offset = i * kNumberOfCMYKComponents;
          
          if (cond == 0) {
            raw[offset + kCyan]    = 0;
            raw[offset + kMagenta] = 0;
            raw[offset + kYellow]  = 0;
            raw[offset + kBlack]   = 0xff;
          }
          else {
            raw[offset + kCyan]    = 0;
            raw[offset + kMagenta] = (unsigned char)((1.0 - (1.0 / (numConditions_ - 2) * (cond - 1))) * 0xff);
            raw[offset + kYellow]  = 0xff;
            raw[offset + kBlack]   = 0;
          }
          
          i++;
        }
      }
    }
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, raw, rawSize, NULL);
  
  CGImageRef image = CGImageCreate(width,
                                   height,
                                   bitsPerComponent,
                                   bitsPerPixel,
                                   bytesPerRow,
                                   colorSpaceCMYK,
                                   kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                   provider,
                                   NULL,
                                   NO,
                                   kCGRenderingIntentDefault);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(ctx, 0.0, self.frame.size.height);
  CGContextScaleCTM(ctx, 1.0, -1.0);
  CGContextDrawImage(ctx, self.bounds, image);
  
  free(raw);
  CGColorSpaceRelease(colorSpaceCMYK);
  CGDataProviderRelease(provider);
  CGImageRelease(image);
}

- (void)dealloc {
  [super dealloc];
}


@end
