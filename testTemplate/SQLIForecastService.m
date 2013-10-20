//
//  SQLIForecastService.m
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import "SQLIForecastService.h"
#import "AFNetworking.h"
#import "City.h"
#import "Forecast.h"
#import "Weather.h"
#import "SQLIDatabaseAccess.h"

@implementation SQLIForecastService

+ (SQLIForecastService *)sharedInstance
{
    static SQLIForecastService *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
    }
    return self;
}

-(void)getForecastForCity:(City *)city
{
    NSString *getUrlStr = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&mode=json&units=metric&cnt=7",city.primaryKey];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getUrlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        for (NSDictionary *forecastDict in ((NSArray *) [responseObject objectForKey:JSON_KEY_FORECAST]))
        {
            Forecast *forecastObj = [NSEntityDescription insertNewObjectForEntityForName:@"Forecast" inManagedObjectContext:[SQLIDatabaseAccess sharedInstance].dbManager.managedObjectContext];
            
           
            forecastObj.date = [NSDate dateWithTimeIntervalSince1970:[[forecastDict objectForKey:JSON_KEY_TIMESTAMP]intValue]];
            forecastObj.humidity = [NSNumber numberWithFloat:[[forecastDict objectForKey:JSON_KEY_HUMIDITY] floatValue]];
            forecastObj.windSpeed = [NSNumber numberWithFloat:[[forecastDict objectForKey:JSON_KEY_WIND_SPEED]floatValue]];
            forecastObj.minTemp = [NSNumber numberWithFloat:[[[forecastDict objectForKey:JSON_KEY_TEMP_PARENT] objectForKey:JSON_KEY_MIN_TEMP]floatValue]];
            forecastObj.maxTemp = [NSNumber numberWithFloat:[[[forecastDict objectForKey:JSON_KEY_TEMP_PARENT] objectForKey:JSON_KEY_MAX_TEMP]floatValue]];
            forecastObj.city = city;
            
            // WEATHER
#warning TODO
            // SAVE
            NSError *error;
            [[SQLIDatabaseAccess sharedInstance] saveContext:error];

        }
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}


- (void)testGetForecastForCity
{
    NSArray *cities = [[SQLIDatabaseAccess sharedInstance]getCities];
    [self getForecastForCity:[cities objectAtIndex:0]];
}
@end
