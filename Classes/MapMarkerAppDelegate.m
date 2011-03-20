//
//  BirdMarkAppDelegate.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MapMarkerAppDelegate.h"
#import "MainViewController.h"

@implementation MapMarkerAppDelegate

@synthesize window, mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		NSLog(@"ERROR in applicationDidFinishLaunching:");
	}
	
	mainViewController.managedObjectContext = context;
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	[[Reachability sharedReachability] setHostName:@"maps.google.com"];
	if ([[Reachability sharedReachability] remoteHostStatus] == NotReachable) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MapMarker Error"
														message:@"No Internet connection."
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"ERROR in applicationWillTerminate:");
        } 
    }
}


- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
    [mainViewController release];
    [window release];
    [super dealloc];
}


/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark Core Data

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Locations.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"ERROR in persistentStoreCoordinator");
    }    
	
    return persistentStoreCoordinator;
}


@end
