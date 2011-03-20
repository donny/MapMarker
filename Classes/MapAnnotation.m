//
//  MapAnnotation.m
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate, aTitle, aSubtitle, aImage, reverseGeocoder, aAddress;

-(id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	if([self init]) {
		coordinate = aCoordinate;
		[self reverseGeocoder];
	}
	return self;
}

- (NSString *)title{
	return aTitle;
}

- (NSString *)subtitle{
	if (aAddress == nil)
		return aSubtitle;
	
	NSString *myAddress = [NSString stringWithFormat:@"%@ %@", aAddress.subThoroughfare, aAddress.thoroughfare];
	
	return myAddress;
}

- (void)dealloc {
	[aTitle release];
	[aSubtitle release];
	[aImage release];
	[reverseGeocoder release];
	[aAddress release];
    [super dealloc];
}

#pragma mark -
#pragma mark Reverse Geocoder

- (MKReverseGeocoder *)reverseGeocoder {
	if (reverseGeocoder != nil) {
		return reverseGeocoder;
	}
	
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	[reverseGeocoder setDelegate:self];
	[reverseGeocoder start];
	
	return reverseGeocoder;
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
//	NSString *address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//	NSLog(@"%@", address);
//	
//	NSLog(@"%@-%@", placemark.subThoroughfare, placemark.thoroughfare);
//	NSLog(@"%@-%@", placemark.subLocality, placemark.locality);
//	NSLog(@"%@-%@", placemark.subAdministrativeArea, placemark.administrativeArea);
//	NSLog(@"%@-%@-%@", placemark.countryCode, placemark.country, placemark.postalCode);

	self.aAddress = placemark;
}


@end
