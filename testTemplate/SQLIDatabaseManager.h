//
//  SQLIDatabaseManager.h
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header SQLIDatabaseManager.h
 @abstract Implementation of CoreData basic methods
 */
@interface SQLIDatabaseManager : NSObject

/*!
 @abstract Returns the managed object context for the application.
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/*!
 @abstract Returns the managed object model for the application.
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/*!
 @abstract Returns the persistent store coordinator for the application.
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 @abstract Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationLibrariesDirectory;

/*!
 @abstract Returns YES if "etlb.sqlite" exists, NO otherwise
 */
- (BOOL)databaseExist;

/*!
 @abstract Saves all modifications of the managed object context into the database
 */
- (BOOL)saveContext:(NSError *)error;

@end