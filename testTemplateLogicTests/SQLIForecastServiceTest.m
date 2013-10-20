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
    [mockClient GET:@"http://mockUrl" parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Get the result for the json returned by the mock ws
         [forecastResult setArray:[SQLIForecastService manageForecastForCityJson:responseObject AndCity:currentCity]];
         
         // Lift
         [[TestSemaphor sharedInstance] lift:semaphoreKey];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         // No result
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
