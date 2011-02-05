//
//  AmbianceAppDelegate.h
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AmbianceBackend, AmbianceSource_iTunes;

@interface AmbianceAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSMenu *statusItemMenu;
    
    AmbianceBackend* backend;
    AmbianceSource_iTunes* iTunes;
    NSTimer* resignTimer;
    NSStatusItem* statusItem;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusItemMenu;

- (IBAction)returnHere:(id)sender;

@end
