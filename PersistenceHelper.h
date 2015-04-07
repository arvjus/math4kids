//
//  PersistenceHelper.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Config;

@interface PersistenceHelper : NSObject
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	BOOL requiresDataInitialization;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (BOOL)populateDataIfRequired;
- (BOOL)saveChanges:(NSError **)error;
- (id)objectWithURLString:(NSString *)urlString;
- (NSArray *)allObjects;

@end
