//
//  CA2DSettings.m
//  CA2D
//
//  Created by slightair on 10/11/23.
//  Copyright 2010 slightair. All rights reserved.
//

#import "CA2DSettings.h"

// Default Rule is "Star Wars"
#define kDefaultRuleIndex 35

@interface CA2DSettings ()

- (void)loadSettingForKey:(NSString *)key initialValue:(id)object;

@end


@implementation CA2DSettings

+ (id)sharedSettings
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedInstance;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
  self = [super init];

  if (self) {
    settings_ = [[NSMutableDictionary alloc] init];

    NSArray *rules = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"]];
    NSInteger defaultRuleIndex = kDefaultRuleIndex;
    NSDictionary *rule = [rules objectAtIndex:defaultRuleIndex];

    [self loadSettingForKey:kCA2DSettingRule initialValue:[rule objectForKey:@"rule"]];
    [self loadSettingForKey:kCA2DSettingRuleIndex initialValue:[NSNumber numberWithInteger:defaultRuleIndex]];

    [[NSUserDefaults standardUserDefaults] registerDefaults:settings_];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }

  return self;
}

- (void)setObject:(id)object forKey:(NSString *)key {
  [settings_ setObject:object forKey:key];

  [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString *)key {
  return [settings_ objectForKey:key];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)loadSettingForKey:(NSString *)key initialValue:(id)object {
  id savedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];

  if (savedObject) {
    [settings_ setObject:savedObject forKey:key];
  }
  else {
    [settings_ setObject:object forKey:key];
  }
}

@end
