//
//  PreferencesController.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ConfigArrayController;
@class PersistenceHelper;

@interface PreferencesController : NSWindowController
{
	ConfigArrayController *configArrayController;
	PersistenceHelper *persistenceHelper;
	NSArray *sortDescriptors;
}

@property (nonatomic, retain) IBOutlet ConfigArrayController *configArrayController;
@property (nonatomic, retain) PersistenceHelper *persistenceHelper;
@property (nonatomic, retain) NSArray *sortDescriptors;

- (id)initWithPersitenceHelper:(PersistenceHelper *)persistenceHelper;
- (IBAction)setAsDefaultConfiguration:(id)sender;

@end
