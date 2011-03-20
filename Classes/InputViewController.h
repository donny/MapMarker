//
//  FlipsideViewController.h
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol InputViewControllerDelegate;

@interface InputViewController : UIViewController <UITextFieldDelegate> {
	id <InputViewControllerDelegate> delegate;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UITextField *textField;
}

@property (nonatomic, assign) id <InputViewControllerDelegate> delegate;

- (IBAction)cancel;

@end


@protocol InputViewControllerDelegate
- (void)inputViewControllerDidFinish:(InputViewController *)controller 
							 locDesc:(NSString *)desc locImage:(NSString *)image;
@end

