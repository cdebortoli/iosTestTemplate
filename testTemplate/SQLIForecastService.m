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
        NSLog(@"JSON: %@", responseObject);
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
