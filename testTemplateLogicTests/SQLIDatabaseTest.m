//
//  SQLIDatabaseTest.m
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLIDatabaseAccess.h"

@interface SQLIDatabaseTest : XCTestCase

@end

@implementation SQLIDatabaseTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    [[SQLIDatabaseAccess sharedInstance] rollback];

    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
}

- (void)testExample
{
    [[SQLIDatabaseAccess sharedInstance] generateBaseCities];
    NSArray *cities = [[SQLIDatabaseAccess sharedInstance] getCities];
    XCTAssertNotNil(cities, @"Cities generation fail");
    XCTAssertTrue(3 ==  [cities count], @"Cities generation fail");
}

@end
