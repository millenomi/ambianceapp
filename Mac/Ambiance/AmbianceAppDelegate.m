//
//  AmbianceAppDelegate.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceAppDelegate.h"

#import "AmbianceBackend.h"

@interface AmbianceAppDelegate ()

@property(assign) NSStatusItem* statusItem;
@property(assign) AmbianceBackend* backend;

@end


@implementation AmbianceAppDelegate

@synthesize statusItemMenu;
@synthesize backend;
@synthesize window, statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURL* url = [NSURL URLWithString:@"http://localhost:8008"];
    
    self.backend = [[AmbianceBackend alloc] initWithURL:url clientIdentifier:[[NSHost currentHost] localizedName]];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:20.0];
    [self.statusItem setImage:[NSImage imageNamed:@"StatusIcon"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"StatusIcon-Highlighted"]];
    [self.statusItem setMenu:self.statusItemMenu];
}

- (IBAction)returnHere:(id)sender;
{
    
}

@end
