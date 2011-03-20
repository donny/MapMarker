//
//  FlipsideViewController.h
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "Location.h"


@protocol DetailViewControllerDelegate;

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	id <DetailViewControllerDelegate> delegate;
	
	IBOutlet UITableView *tableView;
	IBOutlet UILabel *description;
	IBOutlet UIImageView *image;
	
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *numberFormatter;
		
	Location *location;
	MapAnnotation *mapAnnotation;
}

@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) MapAnnotation *mapAnnotation;

- (IBAction)done;
- (IBAction)openEmail;
- (IBAction)openMaps;

@end


@protocol DetailViewControllerDelegate
- (void)detailViewControllerDidFinish:(DetailViewController *)controller;
@end

