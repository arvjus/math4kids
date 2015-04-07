//
//  Stats.m
//  math4kids
//
//  Created by Arvid Juskaitis on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Stats.h"


@implementation Stats

- (void)report:(BOOL)right
{
	if (right) {
		currentStatus = RIGHT;
		countRight += (countWrong > 0 ? 1 : 2);
		countWrong = 0;
	} else {
		currentStatus = WRONG;
		countWrong ++;
		countRight = 0;
	}
}

- (NSString *)smiley
{
	NSString *ret = @"neutral.png";
	if (currentStatus == RIGHT) {
		ret = countRight > 1 ? @"right.png" : @"neutral.png";
	} else if (currentStatus == WRONG) {
		ret = countWrong <= 1 ? @"wrong.png" : @"terrible.png";
	}
	return ret;
}

@end
