//
//  FlipsideViewController.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

@synthesize delegate, dateFormatter, numberFormatter, location, mapAnnotation;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMaximumFractionDigits:6];
}


- (void)viewWillAppear:(BOOL)animated {
	tableView.backgroundColor = [UIColor blackColor];

	description.text = location.locDesc;
	UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_white.png", location.locImage]];
	image.image = img;
}


- (IBAction)done {
	[self.delegate detailViewControllerDidFinish:self];	
}


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
	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dateFormatter release];
	[numberFormatter release];
		
	[location release];
	[mapAnnotation release];
    [super dealloc];
}


- (IBAction)openEmail {
	NSString *mSubject = @"My Location";
	NSString *myLocation;
	
	if (mapAnnotation.aAddress != nil)
		myLocation = [NSString stringWithFormat:@"%@ %@\n%@\n%@\n%@\n%@", 
					  mapAnnotation.aAddress.subThoroughfare, mapAnnotation.aAddress.thoroughfare,
					  mapAnnotation.aAddress.locality, mapAnnotation.aAddress.administrativeArea,
					  mapAnnotation.aAddress.postalCode, mapAnnotation.aAddress.country];
	else
		myLocation = [NSString stringWithFormat:@"latitude:%@\nlongitude:%@", 
					  [numberFormatter stringFromNumber:location.latitude], [numberFormatter stringFromNumber:location.longitude]];
	
	NSString *mBody = [NSString stringWithFormat:@"I am here:\n%@", myLocation];
	
	NSURL *actionURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",
											 @"",
											 [mSubject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
											 [mBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[[UIApplication sharedApplication] openURL:actionURL];
}


- (IBAction)openMaps {
	NSURL *actionURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@", 
											 [[numberFormatter stringFromNumber:location.latitude] 
											  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
											 [[numberFormatter stringFromNumber:location.longitude] 
											  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[[UIApplication sharedApplication] openURL:actionURL];
}

#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
	
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"address";
			NSString *myAddress;
			if (mapAnnotation.aAddress != nil)
				myAddress = [NSString stringWithFormat:@"%@ %@\n%@\n%@\n%@\n%@", 
							 mapAnnotation.aAddress.subThoroughfare, mapAnnotation.aAddress.thoroughfare,
							 mapAnnotation.aAddress.locality, mapAnnotation.aAddress.administrativeArea,
							 mapAnnotation.aAddress.postalCode, mapAnnotation.aAddress.country];
			else
				myAddress = @"-";
			cell.detailTextLabel.numberOfLines = 5;
			cell.detailTextLabel.text = myAddress;
			break;
		case 1:
			cell.textLabel.text = @"date";
			cell.detailTextLabel.text = [dateFormatter stringFromDate:location.creationDate];
			break;
		case 2:
			cell.textLabel.text = @"latitude";
			cell.detailTextLabel.text = [numberFormatter stringFromNumber:location.latitude];
			break;
		case 3:
			cell.textLabel.text = @"longitude";
			cell.detailTextLabel.text = [numberFormatter stringFromNumber:location.longitude];
			break;			
	}
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			if (mapAnnotation.aAddress != nil)
				return 120.0;
			else
				return 44.0;
		case 1:
			return 44.0;
		case 2:
			return 44.0;
		case 3:
			return 44.0;
		default:
			return 44.0;
	}
	
}

@end
