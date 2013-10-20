//
//  SQLIForecastService.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#define JSON_KEY_FORECAST @"list"

#define JSON_KEY_TIMESTAMP @"dt"
#define JSON_KEY_HUMIDITY @"humidity"
#define JSON_KEY_WIND_SPEED @"speed"

#define JSON_KEY_TEMP_PARENT @"temp"
#define JSON_KEY_MIN_TEMP @"min"
#define JSON_KEY_MAX_TEMP @"max"

#define JSON_KEY_WEATHER @"weather"
#define JSON_KEY_WEATHER_ID @"id"
#define JSON_KEY_WEATHER_TITLE @"main"
#define JSON_KEY_WEATHER_DESC @"description"


#import <Foundation/Foundation.h>

/*!
 @header SQLIForecastService
 @abstract Forecast webservice
 */
@class City,Forecast,Weather;
@interface SQLIForecastService : NSObject

/*!
 @abstract Shared instance to access webservice manager
 */
+(SQLIForecastService *)sharedInstance;

/*!
 @abstract Get Forecast for a city
 */
-(void)getForecastForCity:(City *)city;

/*!
 @abstract Manage the json returned by the webservice
 */
+ (NSArray *)manageForecastForCityJson:(NSDictionary *)json AndCity:(City *)city;


// Not for TU, just for me
- (void)testGetForecastForCity;

@end
