//
//  AmbianceSource_iPod.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceSource_iPod.h"

#import "AmbianceBackend.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AmbianceSource_iPod () 

@property(retain) AmbianceBackend* backend;
- (void) updateStateWithItem:(MPMediaItem*) item state:(MPMusicPlaybackState) state;

@end

@implementation AmbianceSource_iPod

@synthesize backend;

- (id)initWithBackend:(AmbianceBackend*) b;
{
    self = [super init];
    if (self) {
        
        self.backend = b;
        MPMusicPlayerController* ipod = [MPMusicPlayerController iPodMusicPlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodTrackDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:ipod];
        [ipod beginGeneratingPlaybackNotifications];
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void) iPodTrackDidChange:(NSNotification*) n;
{
    NSLog(@"%@", [n userInfo]);
    MPMusicPlayerController* ipod = [n object];
    MPMediaItem* nowPlayingItem = ipod.nowPlayingItem;
    MPMusicPlaybackState state = ipod.playbackState;
    
    if (nowPlayingItem && state == MPMusicPlaybackStatePlaying) {
        [self.backend takeOverServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse* resp, NSData* data) {
            
            [self updateStateWithItem:nowPlayingItem state:state];
            
        }];
    } else {
        [self updateStateWithItem:nowPlayingItem state:state];
    }
}

- (void) updateStateWithItem:(MPMediaItem*) item state:(MPMusicPlaybackState) s;
{
    NSMutableDictionary* state = [NSMutableDictionary dictionary];
    
    if (!item || s == MPMusicPlaybackStatePlaying) {
		id x;
		
		if ((x = [item valueForProperty:MPMediaItemPropertyTitle]))
			[state setObject:x forKey:@"trackName"];
		
		if ((x = [item valueForProperty:MPMediaItemPropertyAlbumTitle]))
			[state setObject:x forKey:@"albumName"];
        
		if ((x = [item valueForProperty:MPMediaItemPropertyAlbumArtist]))
			[state setObject:x forKey:@"albumArtist"];
		
		if ((x = [item valueForProperty:MPMediaItemPropertyAlbumTrackNumber]))
			[state setObject:x forKey:@"trackNumber"];
    }
    
    [self.backend postState:state toServiceWithIdentifier:kAmbianceMusicService ifSucceeds:^(NSHTTPURLResponse *resp, NSData *data) {
        NSLog(@"Done!");
    }];
}

- (void) resign;
{
    MPMusicPlayerController* ipod = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMusicPlaybackState state = ipod.playbackState;
    if (state != MPMusicPlaybackStatePaused && state != MPMusicPlaybackStateStopped)
        [ipod pause];
}

- (void) takeOverWithTrackForState:(NSDictionary*) state;
{
    NSString* name = [state objectForKey:@"trackName"];
    NSString* album = [state objectForKey:@"albumName"];
    
    // <#TODO#>
    if (!name || !album)
        return;
    
    NSSet* preds = [NSSet setWithObjects:
                    [MPMediaPropertyPredicate predicateWithValue:name forProperty:MPMediaItemPropertyTitle],
                    [MPMediaPropertyPredicate predicateWithValue:album forProperty:MPMediaItemPropertyAlbumTitle],                    
                    nil];
    
    MPMediaQuery* query = [[[MPMediaQuery alloc] initWithFilterPredicates:preds] autorelease];
    
    // Yes, it's ugly, but this way we don't call -count, giving mpmq an opportunity to limit fetches.
    MPMediaItem* item = nil;;
    for (MPMediaItem* i in query.items) {
        item = i;
        break;
    }
    
    if (!item)
        return;
    
    MPMusicPlayerController* ipod = [MPMusicPlayerController iPodMusicPlayer];
    [ipod setQueueWithQuery:[MPMediaQuery songsQuery]];
    ipod.nowPlayingItem = item;
    ipod.currentPlaybackTime = 0;
    [ipod play];
}

@end
