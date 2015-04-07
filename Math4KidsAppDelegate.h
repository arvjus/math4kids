//
//  Math4Kids_AppDelegate.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/8/12.
//  Copyright __MyCompanyName__ 2012 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Math4KidsConfig.h>

@class PersistenceHelper;
@class Config;


@interface Math4KidsAppDelegate : NSObject <Math4KidsConfig>
{
    NSWindow *window;
	PersistenceHelper *persistenceHelper;
	NSArray *configurations;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet PersistenceHelper *persistenceHelper;
@property (assign) NSArray *configurations;

- (IBAction)openPreferences:(id)sender;

@end
