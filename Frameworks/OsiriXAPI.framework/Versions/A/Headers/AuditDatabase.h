/*=========================================================================
 Program:   OsiriX
 Copyright (c) 2010 - 2019 Pixmeo SARL
 266 rue de Bernex
 CH-1233 Bernex
 Switzerland
 All rights reserved.
 =========================================================================*/

#import "N2ManagedDatabase.h"

@interface AuditDatabase : N2ManagedDatabase {
}

+(id)defaultDatabase;
+(NSString*) defaultPath;
@end
