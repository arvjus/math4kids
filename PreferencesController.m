//
//  PreferencesController.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"
#import "ConfigArrayController.h"
#import "PersistenceHelper.h"
#import "Config.h"
#import "Defs.h"


@implementation PreferencesController

@synthesize configArrayController, persistenceHelper, sortDescriptors;

- (id)initWithPersitenceHelper:(PersistenceHelper *)persistenceHelper_
{
    if ((self = [super initWithWindowNibName:@"Preferences"])) {
        self.persistenceHelper = persistenceHelper_;
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
		self.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[sortDescriptor release];
    }
    return self;
}


#pragma mark -
#pragma mark Actions

- (IBAction)setAsDefaultConfiguration:(id)sender
{
    NSError *error = nil;
    if (![self.persistenceHelper saveChanges:&error]) {
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert setMessageText:[NSString stringWithFormat:@"Could not save last changes to disk. %@", [error userInfo]]];
		[alert runModal];
	}

	NSArray *array = [configArrayController selectedObjects];
	if ([array count] > 0) {
		Config *config = [array objectAtIndex:0];
		NSManagedObjectID *moID = [config objectID];
		[[NSUserDefaults standardUserDefaults] setValue:[moID.URIRepresentation absoluteString] forKey:@"ConfigURL"];
		[[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_DEFAULT_CONFIG_SET object:nil];
	}
}

- (BOOL)windowShouldClose:(id)sender
{
    NSError *error = nil;
    if ([self.persistenceHelper saveChanges:&error]) {
		[[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_CONFIG_DB_UPDATED object:nil];
	} else {
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert setMessageText:[NSString stringWithFormat:@"Could not save last changes to disk. %@", [error userInfo]]];
		[alert runModal];
	}
	return YES;
}

@end
