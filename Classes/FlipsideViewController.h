//
//  FlipsideViewController.h
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id <FlipsideViewControllerDelegate> delegate;
	
	IBOutlet UITableView *tableView;
	IBOutlet UISegmentedControl *mapTypeControl;
	
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *numberFormatter;

    NSMutableArray *locationsArray;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

@property (nonatomic, retain) NSMutableArray *locationsArray;

- (IBAction)done;
- (IBAction)mapTypeChanged:(id)sender;
- (IBAction)openWorqbench;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)removeLocation:(NSIndexPath *)index;
@end

