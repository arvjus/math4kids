//
//  ConfigArrayController.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigArrayController.h"
#import "Config.h"


@implementation ConfigArrayController

- (IBAction)duplicate:(id)sender
{
	NSArray *array = [self selectedObjects];
	if ([array count] == 0)
		return;

	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Config" inManagedObjectContext:self.managedObjectContext];
	Config *config = [[Config alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
	[config copyValuesFromObject:[array objectAtIndex:0]];
}

@end
