//
//  SQLIForecastService.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

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

@end
