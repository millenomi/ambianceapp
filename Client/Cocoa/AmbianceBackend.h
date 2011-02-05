//
//  AmbianceBackend.h
//  AmbianceClient
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAmbianceMusicService @"music"

typedef void (^AmbianceResponse)(NSHTTPURLResponse* resp, NSData* data);

@interface AmbianceBackend : NSObject {
@private
    
}

@property(readonly, retain) NSURL* URL;
- (id)initWithURL:(NSURL*) url clientIdentifier:(NSString*) clientId;

- (void) postState:(NSDictionary*) state toServiceWithIdentifier:(NSString*) ident ifSucceeds:(AmbianceResponse) done;

- (void) takeOverServiceWithIdentifier:(NSString*) ident ifSucceeds:(AmbianceResponse) done;

@end
