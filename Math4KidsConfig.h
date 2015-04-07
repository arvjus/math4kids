//
//  Math4KidsConfig.h
//  Math4Kids
//
//  Created by Arvid Juskaitis on 5/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Config;

@protocol Math4KidsConfig

- (NSInteger)numberOfConfigs;
- (Config *)configWithIndex:(NSInteger)index;
- (NSInteger)indexOfDefaultConfig;

@end
