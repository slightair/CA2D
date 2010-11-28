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

// Implementing Singleton

static id _instance = nil;

+ (id)sharedSettings {
	@synchronized(self){
		if (!_instance) {
			[[self alloc] init];
		}
	}
	
	return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self){
		if (!_instance) {
			_instance = [super allocWithZone:zone];
			return _instance;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (void)release {
	// nothing is done.
}

- (id)autorelease {
	return self;
}

- (id)init {
	self = [super init];
	
	if (self) {
		settings_ = [[NSMutableDictionary alloc] init];
		
		NSArray *rules = [[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"]] autorelease];
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

- (void)dealloc {
	[settings_ release];
	[super dealloc];
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
