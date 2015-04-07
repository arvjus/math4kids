//
//  Config.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Config :  NSManagedObject
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * minNumber;
@property (nonatomic, retain) NSNumber * maxNumber;
@property (nonatomic, retain) NSNumber * usePositiveNumbersOnly;
@property (nonatomic, retain) NSNumber * solve;
@property (nonatomic, retain) NSNumber * operationAdd;
@property (nonatomic, retain) NSNumber * operationSub;
@property (nonatomic, retain) NSNumber * operationMul;
@property (nonatomic, retain) NSNumber * operationDiv;
@property (nonatomic, retain) NSNumber * sortOrder;

- (void)copyValuesFromObject:(Config *)config;

@end



