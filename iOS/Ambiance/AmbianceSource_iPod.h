//
//  AmbianceSource_iPod.h
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmbianceBackend;

@interface AmbianceSource_iPod : NSObject {
@private
    
}

- (id)initWithBackend:(AmbianceBackend*) b;
- (void) resign;

- (void) takeOverWithTrackForState:(NSDictionary*) state;

@end
