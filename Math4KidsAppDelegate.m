//
//  Math4Kids_AppDelegate.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/8/12.
//  Copyright __MyCompanyName__ 2012 . All rights reserved.
//

#import "Math4KidsAppDelegate.h"
#import "PersistenceHelper.h"
#import "PreferencesController.h"
#import "Config.h"
#import "Defs.h"


@interface Math4KidsAppDelegate ()
- (void)reloadconfigurations:(id)sender;
@end


@implementation Math4KidsAppDelegate

@synthesize window, persistenceHelper, configurations;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	window.backgroundColor = [NSColor whiteColor];

	NSError *error = nil;
	if ([persistenceHelper populateDataIfRequired]) {
		[self.persistenceHelper saveChanges:&error];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadconfigurations:) name:NOTIFICATION_CONFIG_DB_UPDATED object:nil];
	[self reloadconfigurations:self];
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [persistenceHelper.managedObjectContext undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSError *error = nil;
    if (![self.persistenceHelper saveChanges:&error]) {
        // This error handling simply presents error information in a panel with an
        // "Ok" button, which does not include any attempt at error recovery (meaning,
        // attempting to fix the error.)  As a result, this implementation will
        // present the information to the user and then follow up with a panel asking
        // if the user wishes to "Quit Anyway", without saving the changes.

        // Typically, this process should be altered to include application-specific
        // recovery steps.

        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;

        NSString *question     = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info         = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton   = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert  *alert        = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;

        if (answer == NSAlertAlternateReturn)
			return NSTerminateCancel;
    }

    return NSTerminateNow;
}

- (IBAction)openPreferences:(id)sender
{
    PreferencesController *preferencesController = [[PreferencesController alloc] initWithPersitenceHelper:self.persistenceHelper];
    [preferencesController showWindow:self];
}

- (void)reloadconfigurations:(id)sender {
	self.configurations = [persistenceHelper allObjects];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONFIG_LIST_LOADED object:nil];
}

#pragma mark -
#pragma mark Math4KidsConfig delegate

- (NSInteger)numberOfConfigs
{
	return [self.configurations count];
}

- (NSInteger)indexOfDefaultConfig;
{
	NSString *configURLString = [[NSUserDefaults standardUserDefaults] stringForKey:@"ConfigURL"];
	
	NSInteger index = 0;
	for (int i = 0; i < [self.configurations count]; i ++) {
		Config *config = [self.configurations objectAtIndex:i];
		NSManagedObjectID *moID = [config objectID];
		NSURL *moURL = [moID URIRepresentation];
		NSString *moURLString = [moURL absoluteString];
		if ([configURLString compare:moURLString] == NSOrderedSame) {
			index = i;
			break;
		}
	}
	return index;
}

- (Config *)configWithIndex:(NSInteger)index
{
	if (index != -1 && index < [self.configurations count]) {
		return [self.configurations objectAtIndex:index];
	}
	return nil;
}

@end
