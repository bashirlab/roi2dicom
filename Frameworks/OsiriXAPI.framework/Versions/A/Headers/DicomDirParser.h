/*=========================================================================
 Program:   OsiriX
 Copyright (c) 2010 - 2019 Pixmeo SARL
 266 rue de Bernex
 CH-1233 Bernex
 Switzerland
 All rights reserved.
 =========================================================================*/

#import <Foundation/Foundation.h>

@interface NSString(NumberStuff)
- (BOOL)holdsIntegerValue;
@end


/** \brief  Reads and parses DICOMDIRs */

@interface DicomDirParser : NSObject
{
	NSString *data, *dirpath;
}

- (id) init:(NSString*) file;
- (void) parseArray:(NSMutableArray*) files;

@end
