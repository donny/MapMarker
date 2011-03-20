//
//  FlipsideViewController.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "InputViewController.h"
#import "Location.h"

@implementation InputViewController

@synthesize delegate;

const CGFloat kScrollObjHeight = 50.0;
const CGFloat kScrollObjWidth = 50.0;
const NSUInteger kNumImages = 58;

static NSInteger prevSelection;
static NSInteger curSelection;


- (void)layoutScrollImages {
	UIButton *view = nil;
	NSArray *subviews = [scrollView subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews) {
		if ([view isKindOfClass:[UIButton class]] && view.tag > 0) {
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[scrollView setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView bounds].size.height)];
}


- (void)iconSelected:(id)sender {
	curSelection = [(UIButton *)sender tag];
	
	UIImage *imageNormal = [UIImage imageNamed:@"bgIconNormal.png"];
	UIImage *imageSelected = [UIImage imageNamed:@"bgIconSelected.png"];

	UIButton *prevButton = (UIButton *)[scrollView viewWithTag:prevSelection];
	UIButton *curButton = (UIButton *)[scrollView viewWithTag:curSelection];

	[prevButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
	[curButton setBackgroundImage:imageSelected forState:UIControlStateNormal];
	
	prevSelection = curSelection;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[textField becomeFirstResponder];
	
	// setup the scrollview for multiple images and add it to the view controller
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	//[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	scrollView.clipsToBounds = YES; // default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	//scrollView.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger i;
	for (i = 1; i <= kNumImages; i++) {
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d.png", i]];
		UIImage *bgImage = [UIImage imageNamed:@"bgIconNormal.png"];
		
		UIButton *button = [[UIButton alloc] init];
		CGRect rect = button.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		button.frame = rect;
		button.tag = i; // tag our buttons for later use when we place them in serial fashion
		//button.showsTouchWhenHighlighted = YES;
		[button setImage:image forState:UIControlStateNormal];
		[button setBackgroundImage:bgImage forState:UIControlStateNormal];
		
		[button addTarget:self action:@selector(iconSelected:) forControlEvents:UIControlEventTouchUpInside];
		
		[scrollView addSubview:button];
		
		[button release];
	}

	// select the default button (icon1)
	UIImage *bgImageSelected = [UIImage imageNamed:@"bgIconSelected.png"];
	UIButton *defaultButton = (UIButton *)[scrollView viewWithTag:1];
	[defaultButton setBackgroundImage:bgImageSelected forState:UIControlStateNormal];
	prevSelection = curSelection = 1;
	
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
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
    [super dealloc];
}


- (void)cancel {
	[self.delegate inputViewControllerDidFinish:self locDesc:nil locImage:nil];
}

#pragma mark -
#pragma mark Text Field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (range.location > 5)
//        return NO;
//    else
        return YES; 
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
	//[aTextField resignFirstResponder];
	NSString *desc = textField.text;
	NSString *image = [NSString stringWithFormat:@"icon%d", curSelection];
	[self.delegate inputViewControllerDidFinish:self locDesc:desc locImage:image];
	
	return YES;
}


@end
