//
//  AmbianceAppDelegate.h
//  Ambiance
//
//  Created by ∞ on 05/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AmbianceAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSMenu *statusItemMenu;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusItemMenu;

- (IBAction)returnHere:(id)sender;

@end
