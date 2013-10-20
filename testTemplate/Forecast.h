//
//  Forecast.h
//  testTemplate
//
//  Created by cdebortoli on 20/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Weather;

@interface Forecast : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * maxTemp;
@property (nonatomic, retain) NSNumber * minTemp;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) Weather *weather;

@end
