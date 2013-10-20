//
//  SQLIForecastService.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#define JSON_KEY_TIMESTAMP @"dt"
#define JSON_KEY_PRESSURE @"dt"
#define JSON_KEY_HUMIDITY @"dt"
#define JSON_KEY_TIMESTAMP @"dt"
#define JSON_KEY_TIMESTAMP @"dt"
#define JSON_KEY_TIMESTAMP @"dt"
#define JSON_KEY_TIMESTAMP @"dt"

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

- (void)testGetForecastForCity;

@end
