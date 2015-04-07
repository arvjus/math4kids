//
//  MathOp.m
//  math4kids
//
//  Created by Arvid Juskaitis on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MathOperation.h"
#import "Config.h"
#import "Defs.h"


@interface MathOperation ()
+ (int)randomOperandWithConfig:(Config *)config;
+ (int)randomOperationWithConfig:(Config *)config;
+ (void)randomNumber:(int *)pnum andNumber:(int *)pnum2 withConfig:(Config *)config;
+ (void)randomNumber:(int *)pnum andNumberLt:(int *)pnumlt withConfig:(Config *)config;
+ (void)randomNumber:(int *)pnum andNumberGt:(int *)pnumgt withConfig:(Config *)config;
+ (char)operationChar:(int)operation;
@end


@implementation MathOperation

@synthesize correct, question, answer;

+(void) initialize {
	srand(time(nil));
}

+ (MathOperation *)mathOpWithConfig:(Config *)config {
	int operand = [self randomOperandWithConfig:config];
	int operation = [self randomOperationWithConfig:config];
	
	int value1;
	int value2;
	int result;
	
	MathOperation* mop = [[MathOperation alloc] init];
	switch (operand) {
		case OPERAND_1ST:
			switch (operation) {
				case OPERATION_ADD:
					[self randomNumber:&value1 andNumberGt:&result withConfig:config];
					value2 = result - value1; 
					break;
				case OPERATION_SUB: 
					if ([config.usePositiveNumbersOnly boolValue]) {
						[self randomNumber:&value1 andNumberLt:&value2 withConfig:config];
					} else {
						[self randomNumber:&value1 andNumber:&value2 withConfig:config];
					}
					result = value1 - value2; 
					break;
				case OPERATION_MUL: 
					[self randomNumber:&value1 andNumberGt:&result withConfig:config];
					value2 = result / (value1 ? value1 : 1); 
					result = value1 * value2;
					break;
				case OPERATION_DIV: 
					[self randomNumber:&value1 andNumberGt:&result withConfig:config];
					value2 = value1 / result;
					if (!value2)
						value2 = 1;
					value1 = value2 * result; 
					break;
			}
			
			[mop setCorrect:[NSString stringWithFormat: @"%d %c %d = %d", value1, [self operationChar:operation], value2, result]];
			[mop setQuestion:[NSString stringWithFormat: @"_ %c %d = %d", [self operationChar:operation], value2, result]];
			[mop setAnswer:value1];
			break;
			
		case OPERAND_2ND:
			switch (operation) {
				case OPERATION_ADD:
					[self randomNumber:&value2 andNumberGt:&result withConfig:config];
					value1 = result - value2; 
					break;
				case OPERATION_SUB: 
					if ([config.usePositiveNumbersOnly boolValue]) {
						[self randomNumber:&value2 andNumberLt:&value1 withConfig:config];
					} else {
						[self randomNumber:&value2 andNumber:&value1 withConfig:config];
					}
					result = value1 - value2;	
					break;
				case OPERATION_MUL: 
					[self randomNumber:&value2 andNumberGt:&result withConfig:config];
					value1 = result / (value2 ? value2 : 1); 
					result = value1 * value2;
					break;
				case OPERATION_DIV: 
					[self randomNumber:&value2 andNumberLt:&result withConfig:config];
					if (!value2)
						value2 = 1;
					if (!result) 
						result = 1;
					value1 = value2 * result; 
					break;
			}

			[mop setCorrect:[NSString stringWithFormat: @"%d %c %d = %d", value1, [self operationChar:operation], value2, result]];
			[mop setQuestion:[NSString stringWithFormat: @"%d %c _ = %d", value1, [self operationChar:operation], result]];
			[mop setAnswer:value2];
			break;
			
		case OPERAND_RESULT:
			switch (operation) {
				case OPERATION_ADD:
					[self randomNumber:&result andNumberLt:&value1 withConfig:config];
					value2 = result - value1; 
					break;
				case OPERATION_SUB: 
					if ([config.usePositiveNumbersOnly boolValue]) {
						[self randomNumber:&result andNumberGt:&value1 withConfig:config];
						value2 = value1 - result; 
					} else {
						[self randomNumber:&result andNumber:&value2 withConfig:config];
						value1 = value2 - result; 
					}
					break;
				case OPERATION_MUL: 
					[self randomNumber:&result andNumberLt:&value1 withConfig:config];
					value2 = result / (value1 ? value1 : 1); 
					result = value1 * value2;
					break;
				case OPERATION_DIV: 
					[self randomNumber:&result andNumberGt:&value1 withConfig:config];
					if (!result) 
						result = 1;
					value2 = value1 / result;
					value1 = result * value2; 
					break;
			}

			[mop setCorrect:[NSString stringWithFormat: @"%d %c %d = %d", value1, [self operationChar:operation], value2, result]];
			[mop setQuestion:[NSString stringWithFormat: @"%d %c %d = _", value1, [self operationChar:operation], value2]];
			[mop setAnswer:result];
			break;
	}
	return [mop autorelease];
}

+ (void)randomNumber:(int *)pnum andNumber:(int *)pnum2 withConfig:(Config *)config  {
	int min = [config.minNumber intValue]; 
	int max = [config.maxNumber intValue] + 1; 
	*pnum = rand() % (max - min) + min;
	*pnum2 = rand() % (max + 1);
}

+ (void)randomNumber:(int *)pnum andNumberLt:(int *)pnumlt withConfig:(Config *)config  {
	int min = [config.minNumber intValue]; 
	int max = [config.maxNumber intValue] + 1; 
	*pnum = rand() % (max - min) + min;
	*pnumlt = rand() % (*pnum + 1);
}

+ (void)randomNumber:(int *)pnum andNumberGt:(int *)pnumgt withConfig:(Config *)config  {
	int min = [config.minNumber intValue]; 
	int max = [config.maxNumber intValue] + 1; 
	*pnum = rand() % (max - min) + min;
	*pnumgt = rand() % (max - *pnum) + *pnum;
}

+ (int)randomOperandWithConfig:(Config *)config {
	int solve = [config.solve intValue];
	
	if (solve == SOLVE_RESULT) {
		return OPERAND_RESULT;
	}

	NSMutableArray *operands = [NSMutableArray array];
	[operands addObject:[NSNumber numberWithInt:OPERAND_1ST]];
	[operands addObject:[NSNumber numberWithInt:OPERAND_2ND]];
	if (solve == SOLVE_OPERAND_RESULT)
		[operands addObject:[NSNumber numberWithInt:OPERAND_RESULT]];

	int index = rand() % ([operands count]);
	return [[operands objectAtIndex:index] intValue];
}

+ (int)randomOperationWithConfig:(Config *)config {
	NSMutableArray *operations = [NSMutableArray array];
	if ([config.operationAdd boolValue])
		[operations addObject:[NSNumber numberWithInt:OPERATION_ADD]];
	if ([config.operationSub boolValue])
		[operations addObject:[NSNumber numberWithInt:OPERATION_SUB]];
	if ([config.operationMul boolValue])
		[operations addObject:[NSNumber numberWithInt:OPERATION_MUL]];
	if ([config.operationDiv boolValue])
		[operations addObject:[NSNumber numberWithInt:OPERATION_DIV]];
	if (![operations count])
		return OPERATION_ADD;

	int index = rand() % ([operations count]);
	return [[operations objectAtIndex:index] intValue];
}

+ (char)operationChar:(int)operation {
	switch (operation) {
		case OPERATION_ADD: return '+';
		case OPERATION_SUB: return '-';
		case OPERATION_MUL: return 'x';
		case OPERATION_DIV: return '/';
	}
	return 0;
}

@end
