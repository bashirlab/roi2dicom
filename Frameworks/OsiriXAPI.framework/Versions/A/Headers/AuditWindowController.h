/*=========================================================================
 Program:   OsiriX
 Copyright (c) 2010 - 2019 Pixmeo SARL
 266 rue de Bernex
 CH-1233 Bernex
 Switzerland
 All rights reserved.
 =========================================================================*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "OSIWindowController.h"

@class Audit;

@interface AuditWindowController : OSIWindowController <WKUIDelegate, WKNavigationDelegate>
{
    IBOutlet WKWebView *webView;
    IBOutlet NSPopUpButton *chartsPopupMenu;
    
    NSArray *reportsDictionaries;
    NSArray *dashboardsDictionaries;
    NSString *url, *sourcesTitle, *oldestDate, *mostRecentDate;
    BOOL isAddToDashboardButtonVisible;
    
    Audit *currentAudit;
    IBOutlet NSArrayController *audits;
    
    
    IBOutlet NSWindow *renameDashboardWindow;
    IBOutlet NSWindow *addToDashboardWindow;
    IBOutlet NSTextField *createDashboardTitleTextField;
    NSString *createDashboardTitle;
    NSArray *dashboardMenu;
    int dashboardMenuIndex;
    IBOutlet NSMenu *dashboardMenuGUI;
    
    BOOL createNewDashboard, addToExistingDashboard;
    NSURL *retainURL;
    NSDictionary *retainChart;
}

@property (readonly) WKWebView *webView;
@property (retain, nonatomic) NSString *url, *sourcesTitle, *mostRecentDate, *oldestDate;
@property (retain, nonatomic) NSArray *reportsDictionaries, *dashboardsDictionaries;
@property (retain) Audit *currentAudit;
@property (retain) NSString *createDashboardTitle;
@property (retain) NSArray *dashboardMenu;
@property (retain) NSURL *retainURL;
@property (retain) NSDictionary *retainChart;
@property (nonatomic) int dashboardMenuIndex;
@property BOOL isAddToDashboardButtonVisible, createNewDashboard, addToExistingDashboard;

+ (id) showWindow;
+ (id) showWindowWithUID:(NSString*) uid;
- (IBAction) reloadURL: (id) sender;
- (void) createDefaultDashboards;
@end
