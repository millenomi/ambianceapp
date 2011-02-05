//
//  AmbianceAppDelegate.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceAppDelegate.h"

#import "AmbianceBackend.h"
#import "AmbianceSource_iTunes.h"

#import "SBJSON/JSON.h"

@interface AmbianceAppDelegate ()

@property(retain) NSStatusItem* statusItem;
@property(retain) AmbianceBackend* backend;

@property(retain) AmbianceSource_iTunes* iTunes;

@property(retain) NSTimer* resignTimer;

@end


@implementation AmbianceAppDelegate

@synthesize statusItemMenu;
@synthesize backend;
@synthesize window, statusItem;
@synthesize iTunes, resignTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURL* url = [NSURL URLWithString:@"http://localhost:8008"];
    
    self.backend = [[AmbianceBackend alloc] initWithURL:url clientIdentifier:[[NSHost currentHost] localizedName]];
    
    self.iTunes = [[AmbianceSource_iTunes alloc] initWithBackend:self.backend];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:20.0];
    [self.statusItem setImage:[NSImage imageNamed:@"StatusIcon"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"StatusIcon-Highlighted"]];
    [self.statusItem setMenu:self.statusItemMenu];
    
    self.resignTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkResigning:) userInfo:nil repeats:YES];
}

- (IBAction)returnHere:(id)sender;
{
    [self.backend fetchStateOfServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse *resp, NSData *data) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!jsonString)
            return;
        
        id x = [jsonString JSONValue];
        if (![x isKindOfClass:[NSDictionary class]])
            return;
        
        [self.backend takeOverServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse *resp, NSData *data) {
            // TODO play song whose details come from 'x'.
        }];
    }];
}

- (void) checkResigning:(NSTimer*) t;
{
    [self.backend fetchStateOfServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse *resp, NSData *data) {
        
        if ([resp statusCode] >= 400)
            return;
        
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!jsonString)
            return;
        
        id x = [jsonString JSONValue];
        if ([x isKindOfClass:[NSDictionary class]]) {
            id client = [x objectForKey:@"takingOverClient"];
            
            if (client && ![self.backend.clientIdentifier isEqual:client]) {
                // RESIGN!
                [self.iTunes resign];
            }
        }
    }];
}

@end
