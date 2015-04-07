//
//  MathOp.h
//  math4kids
//
//  Created by Arvid Juskaitis on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Config;

@interface MathOperation : NSObject
{
	NSString *correct;
	NSString *question;
	int answer;
}

@property (nonatomic, retain) NSString *correct;
@property (nonatomic, retain) NSString *question;
@property int answer;	

+ (MathOperation *)mathOpWithConfig:(Config *)config;

@end
