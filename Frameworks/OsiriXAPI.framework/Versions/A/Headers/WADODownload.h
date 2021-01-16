/*=========================================================================
 Program:   OsiriX
 Copyright (c) 2010 - 2019 Pixmeo SARL
 266 rue de Bernex
 CH-1233 Bernex
 Switzerland
 All rights reserved.
 =========================================================================*/


#import <Foundation/Foundation.h>

@class DicomDatabase;

@interface WADODownload : NSObject
{
	int WADOThreads;
    int WADOTotal, countOfSuccesses;
    int WADOGrandTotal, WADOBaseTotal;
    unsigned long totalData, receivedData;
	NSMutableDictionary *WADODownloadDictionary, *logEntry;
	BOOL showErrorMessage, firstWadoErrorDisplayed, _abortAssociation;
    NSTimeInterval firstReceivedTime, lastStatusUpdate;
    NSString *baseStatus, *incomingPath;
    NSMutableArray *filesToIndexDirectly;
    NSThread *mainThread;
    DicomDatabase *database;
}

@property BOOL _abortAssociation, showErrorMessage;
@property int countOfSuccesses, WADOGrandTotal, WADOBaseTotal;
@property unsigned long totalData, receivedData;
@property (retain) NSString *baseStatus, *incomingPath;
@property (retain) DicomDatabase *database;

- (void) WADODownload: (NSArray*) urlToDownload;

@end
