//
//  FlipsideViewController.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Location.h"

@implementation FlipsideViewController

@synthesize delegate, dateFormatter, numberFormatter, locationsArray;


- (void)viewDidLoad {
    [super viewDidLoad];
	tableView.editing = YES;
}


- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mapType = [standardUserDefaults objectForKey:@"MapType"];
	
	switch ([mapType unsignedIntValue]) {
		case MKMapTypeStandard:
			mapTypeControl.selectedSegmentIndex = 0;
			break;
		case MKMapTypeSatellite:
			mapTypeControl.selectedSegmentIndex = 1;
			break;
		case MKMapTypeHybrid:
			mapTypeControl.selectedSegmentIndex = 2;
			break;
		default:
			mapTypeControl.selectedSegmentIndex = 0;
			break;
	}
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dateFormatter release];
	[numberFormatter release];

	[locationsArray release];
    [super dealloc];
}


- (IBAction)mapTypeChanged:(id)sender {
	NSNumber *mapType;
	switch ([sender selectedSegmentIndex]) {
		case 0:
			mapType = [NSNumber numberWithUnsignedInt:MKMapTypeStandard];
			break;
		case 1:
			mapType = [NSNumber numberWithUnsignedInt:MKMapTypeSatellite];
			break;
		case 2:
			mapType = [NSNumber numberWithUnsignedInt:MKMapTypeHybrid];
			break;
		default:
			mapType = [NSNumber numberWithUnsignedInt:MKMapTypeStandard];
			break;
	}
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	[standardUserDefaults setObject:mapType forKey:@"MapType"];
	[standardUserDefaults synchronize];
}


- (IBAction)openWorqbench {
	NSURL *actionURL = [NSURL URLWithString:@"http://www.worqbench.com"];
	[[UIApplication sharedApplication] openURL:actionURL];	
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
    static NSString *CellIdentifier = @"EditingCell";
	
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
    
	return cell;
}


/**
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[delegate removeLocation:indexPath]; // Handles the deletion in locationsArray as well.
		[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
}


@end
