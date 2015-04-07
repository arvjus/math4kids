//
//  PersistenceHelper.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PersistenceHelper.h"
#import "Config.h"
#import "Defs.h"

@interface PersistenceHelper ()
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
- (NSPersistentStoreCoordinator *)initPersistentStoreCoordinator;
@end


@implementation PersistenceHelper

@synthesize persistentStoreCoordinator, managedObjectModel, managedObjectContext;

- (id)init 
{
	if ((self = [super init])) {
		managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
		if (!managedObjectModel) {
			NSAssert(NO, @"Managed object model is nil");
			NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
		} else if ([self initPersistentStoreCoordinator]) {
			managedObjectContext = [[NSManagedObjectContext alloc] init];
			[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
		}
	}
	
	return self;
}

- (NSPersistentStoreCoordinator *)initPersistentStoreCoordinator
{
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ?[paths objectAtIndex:0] : NSTemporaryDirectory();
    NSString *applicationSupportDirectory = [basePath stringByAppendingPathComponent:@"Math4Kids"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    if (![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL]) {
        if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory, error]));
            NSLog(@"Error creating application support directory at %@ : %@", applicationSupportDirectory, error);
            return nil;
        }
    }

    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent:@"storedata.xml"]];
	if (![fileManager fileExistsAtPath:[url path] isDirectory:NULL]) {
		requiresDataInitialization = YES;
	}
	
    error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType
          configuration:nil URL:url
          options:nil
          error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;

		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
	}
	
	return persistentStoreCoordinator;
}

- (void)dealloc
{
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Interface methods

- (BOOL)populateDataIfRequired
{
	if (requiresDataInitialization) {
        NSLog(@"Initializing data..");
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Config" inManagedObjectContext:self.managedObjectContext];
		Config *config;

		config = [[Config alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
		config.name = @"Pre-school";
		config.minNumber = [NSNumber numberWithInt:1];
		config.maxNumber = [NSNumber numberWithInt:10];
		config.usePositiveNumbersOnly = [NSNumber numberWithBool:YES];
		config.solve = [NSNumber numberWithInt:SOLVE_RESULT];
		config.operationAdd = [NSNumber numberWithBool:YES];
		config.operationSub = [NSNumber numberWithBool:YES];
		config.operationMul = [NSNumber numberWithBool:NO];
		config.operationDiv = [NSNumber numberWithBool:NO];
		config.sortOrder = [NSNumber numberWithInt:1];
		[config release];
		
		config = [[Config alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
		config.name = @"First class";
		config.minNumber = [NSNumber numberWithInt:1];
		config.maxNumber = [NSNumber numberWithInt:100];
		config.usePositiveNumbersOnly = [NSNumber numberWithBool:YES];
		config.solve = [NSNumber numberWithInt:SOLVE_OPERAND_RESULT];
		config.operationAdd = [NSNumber numberWithBool:YES];
		config.operationSub = [NSNumber numberWithBool:YES];
		config.operationMul = [NSNumber numberWithBool:YES];
		config.operationDiv = [NSNumber numberWithBool:YES];
		config.sortOrder = [NSNumber numberWithInt:2];
		[config release];
		
		config = [[Config alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
		config.name = @"Second class";
		config.minNumber = [NSNumber numberWithInt:10];
		config.maxNumber = [NSNumber numberWithInt:100];
		config.usePositiveNumbersOnly = [NSNumber numberWithBool:NO];
		config.solve = [NSNumber numberWithInt:SOLVE_OPERAND_RESULT];
		config.operationAdd = [NSNumber numberWithBool:YES];
		config.operationSub = [NSNumber numberWithBool:YES];
		config.operationMul = [NSNumber numberWithBool:NO];
		config.operationDiv = [NSNumber numberWithBool:NO];
		config.sortOrder = [NSNumber numberWithInt:3];
		[config release];
	
		config = [[Config alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
		config.name = @"Third class";
		config.minNumber = [NSNumber numberWithInt:10];
		config.maxNumber = [NSNumber numberWithInt:1000];
		config.usePositiveNumbersOnly = [NSNumber numberWithBool:NO];
		config.solve = [NSNumber numberWithInt:SOLVE_OPERAND_RESULT];
		config.operationAdd = [NSNumber numberWithBool:YES];
		config.operationSub = [NSNumber numberWithBool:YES];
		config.operationMul = [NSNumber numberWithBool:YES];
		config.operationDiv = [NSNumber numberWithBool:YES];
		config.sortOrder = [NSNumber numberWithInt:4];
		[config release];
		
        NSLog(@"Done with data initialization");

		requiresDataInitialization = NO;
	
		return YES;
	}

	return NO;
}

- (BOOL)saveChanges:(NSError **)error
{
    if (!managedObjectContext) return NSTerminateNow;

    if (![managedObjectContext commitEditing]) {
        NSLog(@"%@:%s unable to commit editing", [self class], _cmd);
        return NO;
    }

    if (![managedObjectContext hasChanges])
		return YES;

    if (![managedObjectContext save:error]) {
        NSLog(@"%@:%s unable to save, %@", [self class], _cmd, *error);
        return NO;
    }

    return YES;
}

- (id)objectWithURLString:(NSString *)urlString
{
	NSURL *moURL = [NSURL URLWithString:urlString];
	NSManagedObjectID *moID = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:moURL];
	if (!moID) {
		return nil;
	}
	NSManagedObject *object = [self.managedObjectContext objectWithID:moID];
	return [object retain];
}

- (NSArray *)allObjects
{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Config" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSError *error = nil;
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	return [array retain];
}

@end
