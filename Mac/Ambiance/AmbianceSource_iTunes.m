//
//  AmbianceSource_iTunes.m
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmbianceSource_iTunes.h"

#import "AmbianceBackend.h"

@implementation AmbianceSource_iTunes

- (id)initWithBackend:(AmbianceBackend*) backend;
{
    self = [super init];
    if (self) {

        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(iTunesDidChangeTrack:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    }
    
    return self;
}

- (void) iTunesDidChangeTrack:(NSNotification*) n;
{
    // <#TODO#>
    
    NSLog(@"%@", [n userInfo]);
}

@end
