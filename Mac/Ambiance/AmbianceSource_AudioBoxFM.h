//
//  AmbianceSource_AudioBoxFM.h
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmbianceBackend;

@interface AmbianceSource_AudioBoxFM : NSObject {
@private
    AmbianceBackend* backend;
    NSTimer* scrobbleTimer;
}

- (id)initWithBackend:(AmbianceBackend*) b;
- (void) resign;

@end
