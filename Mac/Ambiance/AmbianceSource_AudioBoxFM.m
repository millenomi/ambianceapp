//
//  AmbianceSource_AudioBoxFM.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceSource_AudioBoxFM.h"

#import "AmbianceBackend.h"
#import "SBJSON/JSON.h"

@interface AmbianceSource_AudioBoxFM ()

@property(retain) AmbianceBackend* backend;
@property(retain) NSTimer* scrobbleTimer;

@end

@implementation AmbianceSource_AudioBoxFM

@synthesize backend, scrobbleTimer;

- (id)initWithBackend:(AmbianceBackend*) b;
{
    self = [super init];
    if (self) {
        self.backend = b;
        self.scrobbleTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(scrobbleSong:) userInfo:nil repeats:YES];
    }
    
    return self;
}

#define kAmbianceAudioBoxFMBaseURL ([NSURL URLWithString:@"http://me+audioboxtrial%40infinite-labs.net:0fabio@audiobox.fm"])

static inline id ILAs(id something, Class type) {
	if ([something isKindOfClass:type])
		return something;
	else
		return nil;
}

- (void) scrobbleSong:(NSTimer*) t;
{
    NSURL* url = [NSURL URLWithString:@"api/player/nowplaying" relativeToURL:kAmbianceAudioBoxFMBaseURL];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
	[req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self.backend fetchURLRequest:req ifSucceeds:^(NSHTTPURLResponse* resp, NSData* data) {
		NSMutableDictionary* state = [NSMutableDictionary dictionary];
		
        if ([resp statusCode] == 200) {
			
			NSString* str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
			id x = ILAs([str JSONValue], [NSDictionary class]);
			
			x = ILAs([x objectForKey:@"track"], [NSDictionary class]);
			
			if (!x)
				return;
			
			id y;
			if ((y = [x objectForKey:@"title"]))
				[state setObject:y forKey:@"trackName"];
			
			if ((y = [ILAs([x objectForKey:@"album"], [NSDictionary class]) objectForKey:@"name"]))
				[state setObject:y forKey:@"albumName"];
			
			if ((y = [x objectForKey:@"artist"]))
				[state setObject:y forKey:@"albumArtist"];
			
			if ((y = [x objectForKey:@"track_number"]))
				[state setObject:y forKey:@"trackNumber"];
			
		}
		
		[self.backend postState:state toServiceWithIdentifier:kAmbianceMusicService ifSucceeds:NULL];
    }];
}

- (void) resign;
{
	[self.backend fetchURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"api/player/pause" relativeToURL:kAmbianceAudioBoxFMBaseURL]] ifSucceeds:NULL];
}

@end
