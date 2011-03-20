//
//  MapAnnotation.h
//  BirdMark
//
//  Created by Donny Kurniawan on 18/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation, MKReverseGeocoderDelegate> {
	CLLocationCoordinate2D coordinate;
	NSString *aTitle;
	NSString *aSubtitle;
	NSString *aImage;
	MKReverseGeocoder *reverseGeocoder;
	MKPlacemark *aAddress;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *aTitle;
@property (nonatomic, retain) NSString *aSubtitle;
@property (nonatomic, retain) NSString *aImage;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) MKPlacemark *aAddress;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
