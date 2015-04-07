//
//  Stats.h
//  math4kids
//
//  Created by Arvid Juskaitis on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CURRENT_STATUS
{
	WRONG = -1,
	UNKNOWN = 0,
	RIGHT = 1
} CURRENT_STATUS;

@interface Stats : NSObject
{
	int countRight;
	int countWrong;
	CURRENT_STATUS currentStatus;
}

- (void)report:(BOOL)right;
- (NSString *)smiley;

@end
