//
//  AmbianceAppDelegate_iPhone.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceAppDelegate_iPhone.h"

@implementation AmbianceAppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    NSString* text = [NSString stringWithFormat:[self.returnButton titleForState:UIControlStateNormal], [UIDevice currentDevice].model];
    [self.returnButton setTitle:text forState:UIControlStateNormal];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@synthesize returnButton;

- (void)dealloc
{
    [returnButton release];
	[super dealloc];
}

@end
