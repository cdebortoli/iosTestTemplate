//
//  SQLIDatabaseAccess.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLIDatabaseManager.h"

@class City, Forecast, Weather;

/*!
 @header SQLIDatabaseAccess.h
 @abstract Singleton giving access to the Core Data Stack
 */
@interface SQLIDatabaseAccess : NSObject

#pragma mark - Init

/*!
 @abstract returns the Database Manager
 */
@property (nonatomic, strong) SQLIDatabaseManager *dbManager;

/*!
 @abstract Returns the instance of the Database Access if created, else creating it
 */
+(SQLIDatabaseAccess *)sharedInstance;


#pragma mark - Methods

/*!
 @abstract Generate the base data of cities
 */
- (void)generateBaseCities;

/*!
 @abstract Delete the base data of cities
 */
- (void)deleteBaseCities;

/*!
 @abstract Get City for a particular name
 */
- (City *)getCityWithName:(NSString *)name;


#pragma mark - Save and rollback

/*!
 @abstract calls the context saving method of the DB Manager
 */
- (BOOL)saveContext:(NSError *)error;

/*!
 @abstract Cancels modifications applied to the Managed Object Context
 */
- (void)rollback;

/*!
 @abstract Return the list of cities
 */
- (NSArray *)getCities;


@end
