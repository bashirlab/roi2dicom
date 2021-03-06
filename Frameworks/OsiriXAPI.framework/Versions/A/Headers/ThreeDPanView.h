/*=========================================================================
 Program:   OsiriX
 Copyright (c) 2010 - 2019 Pixmeo SARL
 266 rue de Bernex
 CH-1233 Bernex
 Switzerland
 All rights reserved.
 =========================================================================*/

#import <Cocoa/Cocoa.h>
#import "ThreeDPositionController.h"

@interface ThreeDPanView : NSImageView
{
	NSPoint mouseDownPoint;
	ThreeDPositionController *controller;
}

- (void)setController: (ThreeDPositionController*) c;

@end
