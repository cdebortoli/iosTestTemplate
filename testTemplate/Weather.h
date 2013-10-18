//
//  Weather.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forecast;

@interface Weather : NSManagedObject

@property (nonatomic, retain) NSNumber * primaryKey;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) Forecast *forecasts;

@end
