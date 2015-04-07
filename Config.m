// 
//  Config.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Config.h"


@implementation Config 

@dynamic name;
@dynamic minNumber;
@dynamic maxNumber;
@dynamic usePositiveNumbersOnly;
@dynamic solve;
@dynamic operationAdd;
@dynamic operationSub;
@dynamic operationMul;
@dynamic operationDiv;
@dynamic sortOrder;

- (void)copyValuesFromObject:(Config *)config 
{
	self.name = [NSString stringWithFormat:@"%@ (copy)", config.name];
	self.minNumber = config.minNumber;
	self.maxNumber = config.maxNumber;
	self.usePositiveNumbersOnly = config.usePositiveNumbersOnly;
	self.solve = config.solve;
	self.operationAdd = config.operationAdd;
	self.operationSub = config.operationSub;
	self.operationMul = config.operationMul;
	self.operationDiv = config.operationDiv;
	self.sortOrder = config.sortOrder;
}

@end
