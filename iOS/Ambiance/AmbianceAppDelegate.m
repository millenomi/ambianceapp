//
//  AmbianceAppDelegate.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceAppDelegate.h"

#import "AmbianceBackend.h"
#import "AmbianceSource_iPod.h"

#import "SBJSON/JSON.h"

@interface AmbianceAppDelegate ()

@property(retain, nonatomic) AmbianceBackend* backend;
@property(retain, nonatomic) AmbianceSource_iPod* iPod;

@property(retain, nonatomic) NSTimer* resignTimer;

@end


@implementation AmbianceAppDelegate

@synthesize backend, iPod, resignTimer;
@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL* url = [NSURL URLWithString:@"http://kikyo.local:8008"];
    
    self.backend = [[[AmbianceBackend alloc] initWithURL:url clientIdentifier:[UIDevice currentDevice].name] autorelease];
    
    self.iPod = [[[AmbianceSource_iPod alloc] initWithBackend:self.backend] autorelease];
    
    self.resignTimer = [[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkResignation:) userInfo:nil repeats:YES] retain];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) checkResignation:(NSTimer*) timer;
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
                [self.iPod resign];
            }
        }
    }];
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
