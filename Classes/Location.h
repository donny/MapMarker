//
//  Location.h
//  BirdMark
//
//  Created by Donny Kurniawan on 22/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Location :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSString * locDesc;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * locImage;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * creationDate;

@end



