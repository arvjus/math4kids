//
//  MainWindowDelegate.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 4/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Math4KidsConfig.h"

@class MathOperation, Stats, Math4KidsConfig;

@interface Math4KidsController : NSObject 
{
	id <Math4KidsConfig> delegate;
	NSComboBox *configurations;
	NSTextField *questionTextField;
	NSTextField *answerTextField;
	NSImageView *smileyImageView;
	MathOperation *mathOperation;
	Stats *stats;
}

@property (assign) IBOutlet id <Math4KidsConfig> delegate; 
@property (assign) IBOutlet NSComboBox *configurations;
@property (assign) IBOutlet NSTextField *questionTextField;
@property (assign) IBOutlet NSTextField *answerTextField;
@property (assign) IBOutlet NSImageView *smileyImageView;
@property (retain) MathOperation *mathOperation;


- (IBAction)comboboxItemSelected:(id)sender;
- (IBAction)enterAnswer:(id)sender;
- (IBAction)submitAnswer:(id)sender;
- (IBAction)reloadQuestion:(id)sender;
- (void)processAnswer:(NSString *)answer;

@end
