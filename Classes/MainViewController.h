//
//  MainViewController.h
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "InputViewController.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, InputViewControllerDelegate, DetailViewControllerDelegate, 
MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet MKMapView *mapView;
	IBOutlet UITableView *tableView;
	IBOutlet UIBarButtonItem *barButton;
	
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *numberFormatter;
	
    NSMutableArray *locationsArray;
	NSMutableArray *annotationsArray;
    CLLocationManager *locationManager;
	NSManagedObjectContext *managedObjectContext;
	
	CLLocation *lastAddedLocation;
}

@property (nonatomic, retain) NSMutableArray *locationsArray;
@property (nonatomic, retain) NSMutableArray *annotationsArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	    

@property (nonatomic, retain) CLLocation *lastAddedLocation;

- (IBAction)showInfo;
- (IBAction)showDetail:(id)sender;
- (IBAction)performAction;
- (IBAction)toggleView;

- (void)removeLocation:(NSIndexPath *)index;

@end
