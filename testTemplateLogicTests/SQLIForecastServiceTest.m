//
//  SQLIForecastServiceTest.m
//  testTemplate
//
//  Created by cdebortoli on 20/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AFNetworking.h"
#import "TestSemaphor.h"

#import "SQLIDatabaseAccess.h"
#import "City.h"
#import "Forecast.h"
#import "Weather.h"
#import "SQLIForecastService.h"


@interface SQLIForecastServiceTest : XCTestCase

@end

@implementation SQLIForecastServiceTest
{
    City *currentCity;
    NSDictionary *mockJson;
    NSMutableArray *forecastResult;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    // Generate all cities
    [[SQLIDatabaseAccess sharedInstance] generateBaseCities];
    
    // Get london city
    currentCity = [[SQLIDatabaseAccess sharedInstance] getCityWithName:@"London"];
    
    // Get mock json
    NSURL *dataServiceURL   = [[NSBundle bundleForClass:self.class] URLForResource:@"londonForecast" withExtension:@"json"];
    NSData *sampleData      = [NSData dataWithContentsOfURL:dataServiceURL];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:sampleData options:kNilOptions error:&error];
    mockJson = json;
    
    // Set array
    forecastResult = [[NSMutableArray alloc]init];
}

- (void)tearDown
{
    [[SQLIDatabaseAccess sharedInstance] rollback];

    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testForecastDownload
{
    // create a mock of the AFHTTPClient:
    id mockClient = [OCMockObject mockForClass:[AFHTTPRequestOperationManager class]];

    // Mock async method
    [[[mockClient stub] andDo:^(NSInvocation *invocation)
    {
        // Block to return
        void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = nil;
        
        [invocation getArgument:&successBlock atIndex:4];

        // Return the block with the mock
        successBlock(nil,
                     mockJson
                     );

    }]
    GET:[OCMArg any]
    parameters:nil
    success:[OCMArg any]
    failure:[OCMArg any]];

    
    // Set a semaphore key for block test
    NSString *semaphoreKey = @"forecastLoaded";
    
    // Start the method
    NSString *getUrlStr = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&mode=json&units=metric&cnt=7",currentCity.primaryKey];
    [mockClient GET:getUrlStr parameters:nil
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
             forecastObj.city = currentCity;
             [forecastResult addObject:forecastObj];
             // WEATHER
         }

         // Lift
         [[TestSemaphor sharedInstance] lift:semaphoreKey];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         forecastResult = nil;
         // Lift
         [[TestSemaphor sharedInstance] lift:semaphoreKey];

     }];
    
    // Wait until the key (lifted at the return of blocks)
    [[TestSemaphor sharedInstance] waitForKey:semaphoreKey];

    // Test result
    XCTAssertNotNil(forecastResult, @"");
    XCTAssertTrue([forecastResult count] == [[mockJson valueForKey:JSON_KEY_FORECAST] count]);
}

@end
