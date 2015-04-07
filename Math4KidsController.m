//
//  MainWindowDelegate.m
//  Math4Kids
//
//  Created by Arvid Juskaitis on 4/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Math4KidsController.h"

#import "Config.h"
#import "MathOperation.h"
#import "Stats.h"
#import "Defs.h"

@implementation Math4KidsController

@synthesize delegate, configurations, questionTextField, answerTextField, smileyImageView, mathOperation;

- (id)init {
	if ((self = [super init])) {
		stats = [[Stats alloc] init];
	}
	return self;
}

- (void)dealloc {
	[stats release];
	[super dealloc];
}

- (void)awakeFromNib {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(reloadconfigurations:) name:NOTIFICATION_CONFIG_LIST_LOADED object:nil];
}

- (IBAction)comboboxItemSelected:(id)sender
{
	NSLog(@"comboboxItemSelected");
	[self reloadQuestion:self];
}

- (IBAction)enterAnswer:(id)sender {
	NSString *answer = [self.answerTextField stringValue];
	if ([answer length] > 0) {
		[self processAnswer:answer];
	} else {
		[self reloadQuestion:self];
	}
}

- (IBAction)submitAnswer:(id)sender
{
	NSString *answer = [self.answerTextField stringValue];
	if ([answer length] > 0) {
		[self processAnswer:answer];
	}
}

- (IBAction)reloadQuestion:(id)sender
{
	NSLog(@"reloadQuestion");
	NSInteger index = [self.configurations indexOfSelectedItem];
	self.mathOperation = [MathOperation mathOpWithConfig:[delegate configWithIndex:index]];
	[self.questionTextField setStringValue:mathOperation.question];
	[self.answerTextField setStringValue:@""];
}

- (void)processAnswer:(NSString *)answer
{
	BOOL right = [answer intValue] == mathOperation.answer;
	[stats report:right];
	NSImage *image = [NSImage imageNamed:[stats smiley]];
	[smileyImageView setImage:image];
	if (right) {
		[self.questionTextField setStringValue:mathOperation.correct];
	}
	[self.answerTextField setStringValue:@""];
	NSLog(@"right = %d %@", right, [stats smiley]);
}

- (void)reloadconfigurations:(id)sender
{
	NSLog(@"reloadconfigurations - ");
	[self.configurations reloadData];
	[self.configurations selectItemAtIndex:[delegate indexOfDefaultConfig]];
	[self reloadQuestion:self];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [delegate numberOfConfigs];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
	return [[delegate configWithIndex:index] valueForKey:@"name"];
}


@end
