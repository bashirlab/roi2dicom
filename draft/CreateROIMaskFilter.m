//
//  CreateROIMaskFilter.m
//  CreateROIMask
//
//  Copyright (c) 2009 Aurelie. All rights reserved.
//

#import "CreateROIMaskFilter.h"
#import "Wait.h"
#import "BrowserController.h"
#import "MutableArrayCategory.h"

// include for createMaskFromFiles
#import "DicomFile.h"
#import "DCMObject.h"
#import "Analyze.h"

@implementation CreateROIMaskFilter


#pragma mark -
#pragma mark method createMaskFromDB


- (long) createMaskFromDB
{
	
	NSLog( @"Start createMask");
	long result = 0;
	//long answer = 0;
	
	NSOpenPanel			*sPanel			= [NSOpenPanel openPanel];
	
	// Find which data are selected in the browser. cf "exportAsImage in browserController.m
	//NSMutableArray *dicomFiles2Export = [NSMutableArray array];
	//NSMutableArray *filesToExport;
	
	///////////////////
	//filesToExport = [[BrowserController currentBrowser] filesForDatabaseOutlineSelection: dicomFiles2Export];
	
	//NSManagedObject		*item = [databaseOutline itemAtRow:[index firstIndex]];
	/*if ([[[item entity] name] isEqual:@"Study"])
		studySelected = item;
	else
		studySelected = [item valueForKey:@"study"];*/
	
	IBOutlet MyOutlineView          *databaseOutline = [[BrowserController currentBrowser] databaseOutline] ;
	
	//NSIndexSet		*selectedRows = [databaseOutline selectedRowIndexes];

	//NSArray *selectedSeries;
	NSMutableArray		*selectedSeries = [NSMutableArray array];
	NSEnumerator		*rowEnumerator = [databaseOutline selectedRowEnumerator];
	NSNumber			*row;
	NSMutableArray      *correspondingManagedObjects = [NSMutableArray array];
	int nbseries = 0;
	
	@try
	{
		while (row = [rowEnumerator nextObject])
		{
			NSManagedObject *curObj = [databaseOutline itemAtRow:[row intValue]];
			
			if( [[curObj valueForKey:@"type"] isEqualToString:@"Series"] )
			{
				//NSArray		*imagesArray = [self imagesArray: curObj onlyImages: onlyImages];
				//NSArray		*imagesArray = [self imagesArray: curObj onlyImages: onlyImages];
				[correspondingManagedObjects addObject: curObj];
				nbseries++;
			}
			
			if( [[curObj valueForKey:@"type"] isEqualToString:@"Study"] )
			{
				NSArray	*seriesArray = [[BrowserController currentBrowser] childrenArray: curObj onlyImages: NO];
				
				//int totImage = 0;
				
				for( NSManagedObject *obj in seriesArray )
				{
					//NSArray		*imagesArray = [self imagesArray: obj onlyImages: onlyImages];
					
					//totImage += [imagesArray count];
					
					
					if( [[obj valueForKey:@"type"] isEqualToString:@"Series"] )
					{
						//NSArray		*imagesArray = [self imagesArray: curObj onlyImages: onlyImages];
						
						[correspondingManagedObjects addObject: obj];
						nbseries++;
					}
				}
				
				//if( onlyImages == NO && totImage == 0)							// We don't want empty studies
				//	[context deleteObject: curObj];
			}
		}
		
		[correspondingManagedObjects removeDuplicatedObjects];
		[selectedSeries addObjectsFromArray: correspondingManagedObjects];
		
		//selectedSeries = [[ correspondingManagedObjects valueForKey:@"series"] allObjects];
		
		if( [correspondingManagedObjects count] != [selectedSeries count])
			NSLog(@"****** WARNING [correspondingManagedObjects count] != [selectedSeries count]");
		
		
		NSLog( @"selected files %d, selected series%d , manadged object %d", nbseries, [selectedSeries count], [correspondingManagedObjects count] );
		
	}
	@catch (NSException * e)
	{
		NSLog( @"Exception when looking for the selected files: %@", e);
		return 0;
	}
		
	/*if( [databaseOutline selectedRow] >= 0 )
	{			
		NSMutableArray *studiesToTransform = [NSMutableArray array];
		NSManagedObject	*album = [[[BrowserController currentBrowser] albumArray] objectAtIndex: albumTable.selectedRow];
		
		for( NSInteger x = 0; x < [selectedRows count] ; x++ )
		{
			NSInteger row = ( x == 0 ) ? [selectedRows firstIndex] : [selectedRows indexGreaterThanIndex: row];
		
			NSManagedObject	*study = [databaseOutline itemAtRow: row];
			
			if( [[study valueForKey:@"type"] isEqualToString: @"Study"] )
			{
				[studiesToTransform addObject: study];
				
				NSMutableSet	*studies = [album mutableSetValueForKey: @"studies"];
				[studies removeObject: study];
			}
		}
		
		
		[databaseOutline selectRow:[selectedRows firstIndex] byExtendingSelection:NO];
	}*/
	
	
	//////////////////////////////
	
	[sPanel setCanChooseDirectories:YES];
	[sPanel setCanChooseFiles:NO];
	[sPanel setAllowsMultipleSelection:NO];
	[sPanel setMessage: NSLocalizedString(@"Select the location where to export the mask files:",nil)];
	[sPanel setPrompt: NSLocalizedString(@"Choose",nil)];
	[sPanel setTitle: NSLocalizedString(@"Export",nil)];
	[sPanel setCanCreateDirectories:YES];
	
	if ([sPanel runModalForDirectory:nil file:nil types:nil] == NSFileHandlingPanelOKButton )
	{
		NSLog( @"yep");
		NSString			 *path = [[sPanel filenames] objectAtIndex:0]; //*dest,
		NSLog( @"export directory selected %@, number of files to export %d", path, [correspondingManagedObjects count]);
		Wait                *splash = [[Wait alloc] initWithString:NSLocalizedString(@"Export...", nil)];
		//BOOL				addDICOMDIR = [addDICOMDIRButton state];
		
		
		
		[splash setCancel:YES];
		[splash showWindow:self];
		[[splash progress] setMaxValue:[selectedSeries count]];
		
		/*	for( int i = 0; i < [filesToExport count]; i++ )
		 {
		 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		 NSManagedObject	*curImage = [dicomFiles2Export objectAtIndex:i];
		 NSString *extension = format;
		 
		 NSString *tempPath = [path stringByAppendingPathComponent:[curImage valueForKeyPath: @"series.study.name"]];
		 
		 // Find the PATIENT folder
		 if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) [[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		 else
		 {
		 if( i == 0)	{
		 if( NSRunInformationalAlertPanel( NSLocalizedString(@"Export", nil), [NSString stringWithFormat: NSLocalizedString(@"A folder already exists. Should I replace it? It will delete the entire content of this folder (%@)", nil), [tempPath lastPathComponent]], NSLocalizedString(@"Replace", nil), NSLocalizedString(@"Cancel", nil), nil) == NSAlertDefaultReturn)
		 {
		 [[NSFileManager defaultManager] removeFileAtPath:tempPath handler:nil];
		 [[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		 }
		 else break;
		 }
		 }
		 
		 tempPath = [tempPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@ - %@", [curImage valueForKeyPath: @"series.study.studyName"], [curImage valueForKeyPath: @"series.study.id"]]];
		 
		 // Find the STUDY folder
		 if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) [[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		 
		 NSMutableString *seriesStr = [NSMutableString stringWithString: [curImage valueForKeyPath: @"series.name"]];
		 [BrowserController replaceNotAdmitted:seriesStr];
		 tempPath = [tempPath stringByAppendingPathComponent: seriesStr ];
		 tempPath = [tempPath stringByAppendingFormat:@"_%@", [curImage valueForKeyPath: @"series.id"]];
		 
		 // Find the SERIES folder
		 if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) [[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		 
		 long imageNo = [[curImage valueForKey:@"instanceNumber"] intValue];
		 
		 if( previousSeries != [[curImage valueForKeyPath: @"series.id"] intValue])
		 {
		 previousSeries = [[curImage valueForKeyPath: @"series.id"] intValue];
		 serieCount++;
		 }
		 
		 dest = [NSString stringWithFormat:@"%@/IM-%4.4d-%4.4d.%@", tempPath, serieCount, imageNo, extension];
		 
		 int t = 2;
		 while( [[NSFileManager defaultManager] fileExistsAtPath: dest] )
		 {
		 if (!addDICOMDIR)
		 dest = [NSString stringWithFormat:@"%@/IM-%4.4d-%4.4d #%d.%@", tempPath, serieCount, imageNo, t, extension];
		 else
		 dest = [NSString stringWithFormat:@"%@/%4.4d%d", tempPath,  imageNo, t];
		 t++;
		 }
		 
		 DCMPix* dcmPix = [[DCMPix alloc] myinit: [curImage valueForKey:@"completePathResolved"] :0 :1 :nil :[[curImage valueForKey:@"frameID"] intValue] :[[curImage valueForKeyPath:@"series.id"] intValue] isBonjour:isCurrentDatabaseBonjour imageObj:curImage];
		 
		 if( dcmPix )
		 {
		 float curWW = 0;
		 float curWL = 0;
		 
		 if( [[curImage valueForKey:@"series"] valueForKey:@"windowWidth"] )
		 {
		 curWW = [[[curImage valueForKey:@"series"] valueForKey:@"windowWidth"] floatValue];
		 curWL = [[[curImage valueForKey:@"series"] valueForKey:@"windowLevel"] floatValue];
		 }
		 
		 if( curWW != 0 && curWW !=curWL)
		 [dcmPix checkImageAvailble :curWW :curWL];
		 else
		 [dcmPix checkImageAvailble :[dcmPix savedWW] :[dcmPix savedWL]];
		 
		 if( [format isEqualToString:@"jpg"] )
		 {
		 NSArray *representations = [[dcmPix image] representations];
		 NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:representations usingType:NSJPEGFileType properties:[NSDictionary dictionaryWithObject:[NSDecimalNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor]];
		 [bitmapData writeToFile:dest atomically:YES];
		 }
		 else
		 {
		 [[[dcmPix image] TIFFRepresentation] writeToFile:dest atomically:YES];
		 }
		 
		 [dcmPix release];
		 }
		 
		 [splash incrementBy:1];
		 
		 if( [splash aborted]) 
		 i = [filesToExport count];
		 
		 [pool release];
		 }*/
		
		//close progress window	
		[splash close];
		[splash release];
	}
	else
		NSLog( @"NSPanel did not run normally");
	
	
	// For each selected data create the corresponding mask (if there is at least 1 roi in the data)
	
	
	return result;
}



#pragma mark -
#pragma mark method createMaskFromFolders

- (long) createMaskFromFolders
{
	
	NSLog( @"Start createMaskFromFiles");	
	long result = 0;
	long answer = 0;

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:YES];
    [panel setCanChooseDirectories:YES];
	[panel setCanChooseFiles:NO];
    
    answer = [panel runModalForDirectory:nil file:nil];
	
	
    if (answer == NSOKButton) 
    {
		
		Wait                *splash = [[Wait alloc] initWithString:NSLocalizedString(@"Conversion...", nil)];		
		[splash setCancel:YES];
		[splash showWindow:self];
		[[splash progress] setMaxValue:[[panel filenames] count]];

		for (NSString * dir in [panel filenames]) // for each selected directory			
		{
			
			NSLog(@" Working on the directory %@", dir);
			
			NSArray * fileList =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];	  // careful, only the basename, not the full path
			
			BOOL dcmNotFound = YES;
			NSString *dcmDir = [[[NSString alloc] init] autorelease];			
			NSMutableArray *roiToConvert;
			roiToConvert = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
			
			// Find the dicom dir and the rois_series to convert
			
			for (NSString * file in fileList)
			{
				NSString * ext = [file pathExtension];
				NSString * completeFile = [dir stringByAppendingPathComponent: file];

				BOOL isDir;
				
				if ([ext isEqualToString:@"rois_series"])
				{
					[roiToConvert addObject:completeFile];
				}
				else if( dcmNotFound && [[NSFileManager defaultManager] fileExistsAtPath:completeFile isDirectory:&isDir] && isDir){
					dcmDir = completeFile;
					dcmNotFound = NO;
				}
				
						
			}
			
			if (dcmNotFound)
			{
				NSLog(@"No dcm directory found in the directory %@", dir);
			}
			else
			{
				NSMutableArray * dcmPixList = [NSMutableArray arrayWithCapacity:0];
				int dim[3];
				float pixdim[3], oCoord[2];
				NSPoint origin;
				
				int resdcm = [self createVolume: dcmDir dim: dim pixdim: pixdim origin: oCoord data: dcmPixList]; 
				
				if (resdcm == 1)
				{
					NSLog(@"Could not read correctly the dicom in the directory %@", dcmDir);
					result = 1;
				}
				else
				{
					origin = NSMakePoint (oCoord[0], oCoord[1]);
					NSLog(@"dimensions x %d, y %d, z %d, xspace %f yspace %f zspace %f, oX %f, oY %f", dim[0], dim[1], dim[2], pixdim[0], pixdim[1], pixdim, origin.x, origin.y);
				
				/*NSArray * dcmList =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dcmDir error:nil];			
				
				/////////////////////////////////////////
				NSString *dcmFile;
				BOOL dsstore = NO;
				if ([[dcmList objectAtIndex:0] isEqualToString:@".DS_Store"] == YES)
				{ 
					dcmFile = [dcmDir stringByAppendingPathComponent: [dcmList objectAtIndex:1]];
					dsstore = YES;
				}
				else
					dcmFile = [dcmDir stringByAppendingPathComponent: [dcmList objectAtIndex:0]];
				
				NSLog( @"File dcm %@ \n", dcmFile);

				
				DCMObject *dcmObject = [DCMObject objectWithContentsOfFile:dcmFile decodingPixelData:NO];
				
				if(!dcmObject)
				{
					NSLog( @"Error when reading the dcm file %@\n", dcmFile);
					result = 1;
				}
				else
				{				
					
					/////////// Read information about the DICOM volume	
					long x, y, z;
					float xSpacing, ySpacing, zSpacing, oX, oY, oZ;
					xSpacing = ySpacing = zSpacing = 1;
					oX = oY = oZ = 0;
					
					z = [dcmList count];
					if (dsstore)
						z = z-1;
					
					if (z < 2) // z == 1. One 3D dicom file
					{
						if( [dcmObject attributeValueWithName:@"Planes"])
						{
							z = [[dcmObject attributeValueWithName:@"Planes"] intValue];						
						}
					}
					
					// orientation
					NSArray *ipp = [dcmObject attributeArrayWithName:@"ImagePositionPatient"];
					if( ipp )
					{
						oX = [[ipp objectAtIndex:0] floatValue];
						oY = [[ipp objectAtIndex:1] floatValue];
						//originZ = [[ipp objectAtIndex:2] floatValue];
					}
					
					NSPoint origin = NSMakePoint (oX, oY);
					
					// image size
					if( [dcmObject attributeValueWithName:@"Rows"])
					{
						y = [[dcmObject attributeValueWithName:@"Rows"] intValue];
						y /= 2;
						y *= 2;
					}
					
					if( [dcmObject attributeValueWithName:@"Columns"])
					{
						x =  [[dcmObject attributeValueWithName:@"Columns"] intValue];
						x /= 2;
						x *= 2;
					}
					
					
					//pixel Spacing
					NSArray *pixelSpacing = [dcmObject attributeArrayWithName:@"PixelSpacing"];
					if(pixelSpacing.count >= 2 )
					{
						xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
						ySpacing = [[pixelSpacing objectAtIndex:1] floatValue];
					}
					else if(pixelSpacing.count >= 1 )
					{ 
						xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
						ySpacing = [[pixelSpacing objectAtIndex:0] floatValue];
					}
					else
					{
						NSArray *pixelSpacing = [dcmObject attributeArrayWithName:@"ImagerPixelSpacing"];
						if(pixelSpacing.count >= 2 )
						{
							xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
							ySpacing = [[pixelSpacing objectAtIndex:1] floatValue];
						}
						else if(pixelSpacing.count >= 1 )
						{
							xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
							ySpacing = [[pixelSpacing objectAtIndex:0] floatValue];
						}
					}
					

					if( [dcmObject attributeValueWithName:@"SliceThickness"]) zSpacing = [[dcmObject attributeValueWithName:@"SliceThickness"] floatValue]; // sliceThickness or spacingBetweenSlice
					
					NSLog(@"dimensions x %d, y %d, z %d, xspace %f yspace %f zspace %f, oX %f, oY %f", x, y, z, xSpacing, ySpacing, zSpacing, oX, oY);
					
					
					/////////// Create 3d volume
					
					NSMutableArray * dcmPixList = [NSMutableArray arrayWithCapacity:0];
					float val[x*y];
					int tmp, slice;
					for (tmp = 0; tmp < x*y; tmp++)
						val[tmp] = 0;
					
					for (slice = 0; slice < z ; slice++)
					{				
						DCMPix *myPix = [[DCMPix alloc] initwithdata:val :32 :x :y :xSpacing :ySpacing :oX :oY: oZ ];
						[dcmPixList addObject:myPix];
						[myPix release];
					}
					*/
					
					//////////// Treat each rois_series file
					
					//for (NSString * file in roisseriesList)  //for (NSString * file in fileList) 
					for (NSString * roiFile in roiToConvert)
					{
						//NSString * ext = [file pathExtension];// a supprimer
						//NSString *roiFile = [dir stringByAppendingPathComponent:file];

						NSLog( @"converting roi file %@", roiFile);
						
						int  seriescount, imagescount;
						imagescount = 0;
						
						NSArray *roisSeries = [[NSUnarchiver unarchiveObjectWithFile: roiFile] objectAtIndex: 0];
						seriescount = [roisSeries count];
						
						int slice;
						for( slice = 0; slice < dim[2]; slice++)
						{
							
							if( [roisSeries count] > slice)
							{
								NSArray *roisImages = [roisSeries objectAtIndex: slice];
								
								for( ROI *r in roisImages)
								{
									[r setOriginAndSpacing: pixdim[0] :pixdim[1] :origin];	
									imagescount++;
									
									// fillRoi in the corresponding slice
									[[dcmPixList objectAtIndex:slice] fillROI:r :255 :-99999 :99999 :NO ];
	
								}
							}
						}
						
						NSLog(@"file %@,  nb series %d, nb roi in images %d\n", roiFile, seriescount, imagescount);
						
					}
	
					/////// Write the result dcmPixList in an analyze file
					
					
					/*int dim[3];
					float pixdim[3];
					
					dim[0] = x;
					dim[1] = y;
					dim[2] = z;
					pixdim[0] = xSpacing ;
					pixdim[1] = ySpacing ;
					pixdim[2] = zSpacing ;*/
					
					NSString * tmpbasename = [dcmDir lastPathComponent];
					NSString * basename = [dir stringByAppendingPathComponent: tmpbasename];
					
					int res = [self writeAnalyze: basename dim: dim pixdim: pixdim data: dcmPixList];
					
					if (res == 1)
					{ NSLog(@" pb analyze");
						result = 1;
					}
			
					
				} // end of if(resdcm == 1) else
				
			} // end of if(dcmNotFound) else
			
			
			[splash incrementBy:1];
			
			if( [splash aborted]) 
			{
				NSLog(@"Processing aborted");
				[splash close];
				[splash release];
				[pool release];
				return 2;
			}


		} // end of for(NSString * dir in [panel filenames])
		
		//close progress window	
		[splash close];
		[splash release];
		
	} // end of if OK panel

	
	[pool release];
	return result;
}


#pragma mark -
#pragma mark Auxiliary functions
- (long) writeAnalyze: (NSString *) basename dim: (int *) dim pixdim : (float *) pixdim data : (NSMutableArray *) dcmPixList
{
	long ret = 0;
	int slice, tmp;
	int x, y, z;
	
	x = dim[0];
	y = dim[1];
	z = dim[2];
	
	// write the header
	NSString *header = [NSString stringWithFormat: @"%@.hdr", basename];
	const char * headerFile =  [header cStringUsingEncoding:[NSString 
															 defaultCStringEncoding]];
	
	int res = writeAnalyzeHeader(headerFile, dim, pixdim);
	
	if (res == 1)
	{

		NSLog(@"Error: unable to create the header file");
		return 1;
	}
	
	// write the data
	NSString *img = [NSString stringWithFormat: @"%@.img", basename];
	const char * imgFile =  [img cStringUsingEncoding:[NSString 
													   defaultCStringEncoding]];
	//open (or create) the file
	FILE * fp = fopen(imgFile, "w");
	if (fp == NULL)
	{

		NSLog(@"Error: unable to create the img file");
		return 1;
	}
	else
	{	
		NSLog(@"Writing analyze data");
		//write the data
		for (slice = 0; slice < z; slice++)
		{
			DCMPix  *pix = [dcmPixList objectAtIndex:slice];
			for (tmp = 0; tmp < x*y; tmp++)
			{
				unsigned char v = (unsigned char)[pix fImage][tmp];
				fwrite(&v, sizeof(unsigned char), 1, fp);
			}
			
		}
		fclose(fp);
		
	}

	return ret;
	
}

#pragma mark -
#pragma mark createVolume

- (long) createVolume: (NSString *) dcmDir dim: (int *) dim pixdim: (float *) pixdim origin: (NSPoint) origin data: (NSMutableArray *) dcmPixList {
	

	NSArray * dcmList =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dcmDir error:nil];			
	NSString *dcmFile;
	
	BOOL dsstore = NO;
	if ([[dcmList objectAtIndex:0] isEqualToString:@".DS_Store"] == YES)
	{ 
		dcmFile = [dcmDir stringByAppendingPathComponent: [dcmList objectAtIndex:1]];
		dsstore = YES;
	}
	else
		dcmFile = [dcmDir stringByAppendingPathComponent: [dcmList objectAtIndex:0]];
	
	NSLog( @"File dcm %@ \n", dcmFile);
	
	
	DCMObject *dcmObject = [DCMObject objectWithContentsOfFile:dcmFile decodingPixelData:NO];
	
	if(!dcmObject)
	{
		NSLog( @"Error when reading the dcm file %@\n", dcmFile);
		return 1;
	}
	else
	{				
		
		/////////// Read information about the DICOM volume	
		long x, y, z;
		float xSpacing, ySpacing, zSpacing, oX, oY, oZ;
		xSpacing = ySpacing = zSpacing = 1;
		oX = oY = oZ = 0;
		
		z = [dcmList count];
		if (dsstore)
			z = z-1;
		
		if (z < 2) // z == 1. One 3D dicom file
		{
			if( [dcmObject attributeValueWithName:@"Planes"])
			{
				z = [[dcmObject attributeValueWithName:@"Planes"] intValue];						
			}
		}
		
		// orientation
		NSArray *ipp = [dcmObject attributeArrayWithName:@"ImagePositionPatient"];
		if( ipp )
		{
			oX = [[ipp objectAtIndex:0] floatValue];
			oY = [[ipp objectAtIndex:1] floatValue];
			//originZ = [[ipp objectAtIndex:2] floatValue];
		}
		
		origin = NSMakePoint (oX, oY);
		
		// image size
		if( [dcmObject attributeValueWithName:@"Rows"])
		{
			y = [[dcmObject attributeValueWithName:@"Rows"] intValue];
			y /= 2;
			y *= 2;
		}
		
		if( [dcmObject attributeValueWithName:@"Columns"])
		{
			x =  [[dcmObject attributeValueWithName:@"Columns"] intValue];
			x /= 2;
			x *= 2;
		}
		
		
		//pixel Spacing
		NSArray *pixelSpacing = [dcmObject attributeArrayWithName:@"PixelSpacing"];
		if(pixelSpacing.count >= 2 )
		{
			xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
			ySpacing = [[pixelSpacing objectAtIndex:1] floatValue];
		}
		else if(pixelSpacing.count >= 1 )
		{ 
			xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
			ySpacing = [[pixelSpacing objectAtIndex:0] floatValue];
		}
		else
		{
			NSArray *pixelSpacing = [dcmObject attributeArrayWithName:@"ImagerPixelSpacing"];
			if(pixelSpacing.count >= 2 )
			{
				xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
				ySpacing = [[pixelSpacing objectAtIndex:1] floatValue];
			}
			else if(pixelSpacing.count >= 1 )
			{
				xSpacing = [[pixelSpacing objectAtIndex:0] floatValue];
				ySpacing = [[pixelSpacing objectAtIndex:0] floatValue];
			}
		}
		
		
		if( [dcmObject attributeValueWithName:@"SliceThickness"]) zSpacing = [[dcmObject attributeValueWithName:@"SliceThickness"] floatValue]; // sliceThickness or spacingBetweenSlice
		
// save the dimensions
		dim[0] = x;
		dim[1] = y;
		dim[2] = z;
		
		pixdim[0] = xSpacing;
		pixdim[1] = ySpacing;
		pixdim[2] = zSpacing;
		
		NSLog(@"dimensions x %d, y %d, z %d, xspace %f yspace %f zspace %f, oX %f, oY %f", x, y, z, xSpacing, ySpacing, zSpacing, oX, oY);
		
		
		/////////// Create 3d volume
		
		//NSMutableArray * dcmPixList = [NSMutableArray arrayWithCapacity:0];
		float val[x*y];
		int tmp, slice;
		for (tmp = 0; tmp < x*y; tmp++)
			val[tmp] = 0;
		
		for (slice = 0; slice < z ; slice++)
		{				
			DCMPix *myPix = [[DCMPix alloc] initwithdata:val :32 :x :y :xSpacing :ySpacing :oX :oY: oZ ];
			[dcmPixList addObject:myPix];
			[myPix release];
		}
		
	}
	return 0;
}

#pragma mark -
#pragma mark init plugin

- (void) initPlugin
{
	NSLog( @"Init CreateROIMaskPlugin");
}

- (long) filterImage:(NSString*) menuName
{
	long ret;
	
	NSLog( @"Run create roi mask plugin");

	
	if ( [ menuName isEqualToString: @"From DB"] ) 
	{
	
		ret = [ self createMaskFromDB ];
	}
	
	else if ( [ menuName isEqualToString: @"From folders"] ) 
	{
	
		ret = [ self createMaskFromFolders ];

	}
	
	else
	{
		NSLog( @"Wrong menu item selection");
		ret = 1;
		
	}
	
	if (ret == 1)
	{
		NSAlert * myAlert = [NSAlert alertWithMessageText:@"Error!"
											defaultButton:@"OK"
										  alternateButton:nil
											  otherButton:nil
								informativeTextWithFormat:@"Errors occured during the process, please check the log"];
		[myAlert runModal];
	}
	else if (ret == 2)
	{
		NSAlert * myAlert = [NSAlert alertWithMessageText:@"Cancel!"
											defaultButton:@"OK"
										  alternateButton:nil
											  otherButton:nil
								informativeTextWithFormat:@"Processing aborted"];
		[myAlert runModal];
	}
	else
	{
		NSAlert * myAlert = [NSAlert alertWithMessageText:@"End of the conversion"
											defaultButton:@"OK"
										  alternateButton:nil
											  otherButton:nil
								informativeTextWithFormat:@"No error occured during the conversion"];
		[myAlert runModal];
	}
	
	NSLog( @"End of CreateMaskPlugin");
	return ret;
}

@end
