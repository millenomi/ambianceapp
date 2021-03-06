//
//  AmbianceSource_iTunes.h
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmbianceBackend;

@interface AmbianceSource_iTunes : NSObject {
@private
    AmbianceBackend* backend;
}

- (id)initWithBackend:(AmbianceBackend*) backend;
- (void) resign;

- (void) takeOverWithTrackForState:(NSDictionary*) state;

@end
