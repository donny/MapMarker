//
//  MainViewController.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "MapAnnotation.h"
#import "Location.h"

@implementation MainViewController

@synthesize locationsArray, annotationsArray, locationManager, managedObjectContext, lastAddedLocation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];

	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:4];
	
	// Start the location manager.
	[[self locationManager] startUpdatingLocation];
	
	/*
	 Fetch existing events.
	 Create a fetch request, add a sort descriptor, then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"ERROR in viewDidLoad");
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setLocationsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
	
	// Set up the annotations.
	annotationsArray = [[NSMutableArray alloc] initWithCapacity:[locationsArray count]];
	
	for (Location *event in locationsArray) {
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [[event latitude] doubleValue];
		coordinate.longitude = [[event longitude] doubleValue];
		
		MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:coordinate];
		annotation.aTitle = [event locDesc];
		annotation.aSubtitle = @"";
		annotation.aImage = [event locImage];
		[annotationsArray insertObject:annotation atIndex:[annotationsArray count]];
		
		BOOL selectedFlag = [[event selected] boolValue];
		
		if (selectedFlag) {
			[mapView addAnnotation:annotation];
		}
		
		[annotation release];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mapType = [standardUserDefaults objectForKey:@"MapType"];

	if (mapType == nil) {
		mapType = [NSNumber numberWithUnsignedInt:MKMapTypeStandard];
		[standardUserDefaults setObject:mapType forKey:@"MapType"];
		[standardUserDefaults synchronize];
	}
	
	mapView.mapType = [mapType unsignedIntValue];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	[dateFormatter release];
	[numberFormatter release];
	
	self.locationsArray = nil;
	self.annotationsArray = nil;
	self.locationManager = nil;
	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dateFormatter release];
	[numberFormatter release];

	[locationsArray release];
	[annotationsArray release];
	[locationManager release];
	[managedObjectContext release];
	
	[lastAddedLocation release];
    [super dealloc];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)showInfo {    
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	controller.dateFormatter = dateFormatter;
	controller.numberFormatter = numberFormatter;
	controller.locationsArray = locationsArray;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (IBAction)showDetail:(id)sender {    
	DetailViewController *controller = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	controller.delegate = self;
	controller.location = [locationsArray objectAtIndex:[sender tag]];
	controller.mapAnnotation = [annotationsArray objectAtIndex:[sender tag]];
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)performAction {
	// If it's not possible to get a location, then return.
	CLLocation *location = [locationManager location];
	if (!location) {
		return;
	}

	self.lastAddedLocation = location;
	
	// Show the input view.
	InputViewController *controller = [[InputViewController alloc] initWithNibName:@"InputView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)toggleView {
	static BOOL toggle = YES;
	
	CGRect rMap = mapView.frame;
	CGRect rTable = tableView.frame;
	
	CGFloat tableHeight = 186.0;
	
	if (toggle) {
		toggle = !toggle;
		
		CGRect rNewMap = rMap;
		rNewMap.size.height += tableHeight;
		
		CGRect rNewTable = rTable;
		rNewTable.origin.y += tableHeight;
		rNewTable.size.height -= tableHeight;
		
		CGContextRef context = UIGraphicsGetCurrentContext();

		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.8];
		[mapView setFrame:rNewMap];
		[tableView setFrame:rNewTable];
		[UIView commitAnimations];
	} else {
		toggle = !toggle;
				
		CGRect rNewMap = rMap;
		rNewMap.size.height -= tableHeight;
		
		CGRect rNewTable = rTable;
		rNewTable.origin.y -= tableHeight;
		rNewTable.size.height += tableHeight;
		
		[tableView setFrame:rNewTable];
		[mapView setFrame:rNewMap];
	}	
}

#pragma mark -
#pragma mark View Delegates

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)detailViewControllerDidFinish:(DetailViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)removeLocation:(NSIndexPath *)index {
	// Delete the managed object at the given index path.
	NSManagedObject *eventToDelete = [locationsArray objectAtIndex:index.row];
	[managedObjectContext deleteObject:eventToDelete];
	
	// Update the array and table view.
	[locationsArray removeObjectAtIndex:index.row];
	[mapView removeAnnotation:[annotationsArray objectAtIndex:index.row]];
	[annotationsArray removeObjectAtIndex:index.row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:NO];
	
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"ERROR in removeMarker:");
	}
}


- (void)inputViewControllerDidFinish:(InputViewController *)controller locDesc:(NSString *)desc locImage:(NSString *)img {
	[self dismissModalViewControllerAnimated:YES];
	
	if (desc == nil && img == nil)
		return;
	
	/*
	 Create a new instance of the Location entity.
	 */
	Location *event = (Location *)[NSEntityDescription insertNewObjectForEntityForName:@"Location" 
																inManagedObjectContext:managedObjectContext];
	
	// Configure the new event with information from the location.
	[event setLatitude:[NSNumber numberWithDouble:[lastAddedLocation coordinate].latitude]];
	[event setLongitude:[NSNumber numberWithDouble:[lastAddedLocation coordinate].longitude]];
	
	[event setSelected:[NSNumber numberWithBool:YES]];
	// Should be timestamp, but this will be constant for simulator.
	//[event setCreationDate:[lastAddedLocation timestamp]];
	[event setCreationDate:[NSDate date]];
	
	[event setLocDesc:desc];
	[event setLocImage:img];
	
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"ERROR in inputViewControllerDidFinish:locDesc:locImage:");
	}
	
	/*
	 Display the map region.
	 */
	MKCoordinateRegion region;
	region.center = [lastAddedLocation coordinate];
	region.span.latitudeDelta = 0.1;
	region.span.longitudeDelta = 0.1;
	mapView.region = region;
	
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:[lastAddedLocation coordinate]];
	annotation.aTitle = [event locDesc];
	annotation.aSubtitle = @"";
	annotation.aImage = [event locImage];
    [mapView addAnnotation:annotation];
	//[mapView selectAnnotation:annotation animated:YES];
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    [locationsArray insertObject:event atIndex:0];
	[annotationsArray insertObject:annotation atIndex:0];
    [tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
					 atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	[annotation release];
}

#pragma mark -
#pragma mark Map View

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *defaultPinID = @"DefaultPinID";

	MKPinAnnotationView *pin = nil;
	
	if ([annotation isKindOfClass:[MapAnnotation class]]) {
		pin = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];

		if (pin == nil) {
			pin = (MKPinAnnotationView *)[[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																		  reuseIdentifier:defaultPinID] autorelease];
			pin.canShowCallout = YES;
			pin.animatesDrop = YES;
		}
		
		MapAnnotation *mapA = (MapAnnotation *)annotation;
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png", mapA.aImage]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		pin.leftCalloutAccessoryView = imageView;
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		button.tag = [annotationsArray indexOfObjectIdenticalTo:annotation];
		[button addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
		pin.rightCalloutAccessoryView = button;
	} else if ([annotation isKindOfClass:[MKUserLocation class]]) {
		[mapView setCenterCoordinate:[[((MKUserLocation *) annotation) location] coordinate] animated:YES];
	}
	
    return pin;
}

#pragma mark -
#pragma mark Location Manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationManager setDelegate:self];
	
	return locationManager;
}


/**
 Conditionally enable the Add button:
 If the location manager is generating updates, then enable the button;
 If the location manager is failing, then disable the button.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
    barButton.enabled = YES;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    barButton.enabled = NO;
}

#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
    return [locationsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Get the event corresponding to the current index path and configure the table view cell.
	Location *event = (Location *)[locationsArray objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [event locDesc];
	
	NSString *string = [NSString stringWithFormat:@"%@ : %@, %@",
						[dateFormatter stringFromDate:[event creationDate]],
						[numberFormatter stringFromNumber:[event latitude]],
						[numberFormatter stringFromNumber:[event longitude]]];
    cell.detailTextLabel.text = string;
	
	BOOL selectedFlag = [[event selected] boolValue];
	UIImage *image;
	
	if (selectedFlag)
		image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_red.png", event.locImage]];
	else
		image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", event.locImage]];

	//cell.imageView.image = selectedFlag ? [UIImage imageNamed:@"itemChecked.png"] : [UIImage imageNamed:@"itemUnchecked.png"];
	cell.imageView.image = image;
	
	return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Location *event = (Location *)[locationsArray objectAtIndex:indexPath.row];
	UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
	MapAnnotation *annotation = [annotationsArray objectAtIndex:indexPath.row];

	BOOL selectedFlag = [[event selected] boolValue];
	
	[event setSelected:[NSNumber numberWithBool:!selectedFlag]];
	
	if (!selectedFlag) {
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_red.png", event.locImage]];
		
		//Display the map region.
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [[event latitude] doubleValue];
		coordinate.longitude = [[event longitude] doubleValue];
		MKCoordinateRegion region;
		region.center = coordinate;
		region.span.latitudeDelta = 0.1;
		region.span.longitudeDelta = 0.1;
		mapView.region = region;
		
		[mapView addAnnotation:annotation];
	} else {
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", event.locImage]];
		[mapView removeAnnotation:annotation];
	}
	
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"ERROR in tableView:didSelectRowAtIndexPath:");
	}
}


@end
