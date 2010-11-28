//
//  CA2DSettings.h
//  CA2D
//
//  Created by slightair on 10/11/23.
//  Copyright 2010 slightair. All rights reserved.
//

#import <Foundation/Foundation.h>

// setting names.
#define kCA2DSettingRule @"Rule"
#define kCA2DSettingRuleIndex @"RuleIndex"

@interface CA2DSettings : NSObject {
	NSMutableDictionary *settings_;
}

+ (id)sharedSettings;
- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end
