//
//  AmbianceSource_iTunes.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceSource_iTunes.h"

#import "AmbianceBackend.h"

#import <ScriptingBridge/ScriptingBridge.h>
#import "iTunes.h"

@interface AmbianceSource_iTunes () 

@property(retain) AmbianceBackend* backend;
- (void) updateStateWithNotification:(NSNotification*) n;

@end

@implementation AmbianceSource_iTunes

@synthesize backend;

- (id)initWithBackend:(AmbianceBackend*) b;
{
    self = [super init];
    if (self) {

        self.backend = b;
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(iTunesDidChangeTrack:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    }
    
    return self;
}

- (void) iTunesDidChangeTrack:(NSNotification*) n;
{
    NSLog(@"%@", [n userInfo]);
    NSString* playerState = [[n userInfo] objectForKey:@"Player State"];
    
    if ([playerState isEqualToString:@"Playing"]) {
        [self.backend takeOverServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse* resp, NSData* data) {
            
            [self updateStateWithNotification:n];
            
        }];
    } else {
        [self updateStateWithNotification:n];
    }
}

- (void) updateStateWithNotification:(NSNotification*) n;
{
    NSString* playerState = [[n userInfo] objectForKey:@"Player State"];
    NSMutableDictionary* state = [NSMutableDictionary dictionary];
    
    if ([playerState isEqualToString:@"Playing"]) {
		id x;
		
		if ((x = [[n userInfo] objectForKey:@"Name"]))
			[state setObject:x forKey:@"trackName"];
		
		if ((x = [[n userInfo] objectForKey:@"Album"]))
			[state setObject:x forKey:@"albumName"];
        
		if ((x = [[n userInfo] objectForKey:@"Album Artist"]))
			[state setObject:x forKey:@"albumArtist"];
		
		if ((x = [[n userInfo] objectForKey:@"Track Number"]))
			[state setObject:x forKey:@"trackNumber"];
        
        iTApplication* app = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        iTPlaylist* playlist = app.currentPlaylist;
        if (playlist.specialKind == iTESpKNone) {
            [state setObject:[playlist name] forKey:@"playlistName"];
            NSInteger i = [[playlist tracks] indexOfObject:[app currentTrack]];
            if (i != NSNotFound)
                [state setObject:[NSNumber numberWithInteger:i] forKey:@"indexOfTrackInPlaylist"];
        }
    }
    
    [self.backend postState:state toServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse *resp, NSData *data) {
        NSLog(@"Done!");
    }];
}

- (void) resign;
{
    iTApplication* itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    if (![itunes isRunning])
        return;
    
    iTEPlS state = itunes.playerState;
    if (state != iTEPlSPaused && state != iTEPlSStopped)
        [itunes pause];
}

- (void)takeOverWithTrackForState:(NSDictionary *)state;
{
    iTApplication* itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    NSString* name = [state objectForKey:@"trackName"];
    NSString* album = [state objectForKey:@"albumName"];
    
    iTSource* librarySource = nil;
    for (iTSource* s in [itunes sources]) {
        if (s.kind == iTESrcLibrary) {
            librarySource = s;
            break;
        }
    }
    
    if (!librarySource)
        return;
    
    // <#TODO#>
    if (!name || !album)
        return;
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"name == %@ && album == %@", name, album];
    
    NSArray* a = [[[[librarySource libraryPlaylists] objectAtIndex:0] tracks] filteredArrayUsingPredicate:pred];
    if ([a count] > 0) {
        iTTrack* track = [a objectAtIndex:0];
        [track playOnce:NO];
    }
}

@end
