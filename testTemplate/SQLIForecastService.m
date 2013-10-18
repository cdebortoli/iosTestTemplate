//
//  SQLIForecastService.m
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import "SQLIForecastService.h"


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
    
}

@end
