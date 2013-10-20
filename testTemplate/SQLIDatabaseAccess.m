//
//  SQLIDatabaseAccess.m
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import "SQLIDatabaseAccess.h"
#import "City.h"


@implementation SQLIDatabaseAccess

static SQLIDatabaseAccess __strong *sharedInstance = nil;


#pragma mark - Init

+(SQLIDatabaseAccess *)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.dbManager = [[SQLIDatabaseManager alloc] init];
        // Set city data
        [self generateBaseCities];
    }
    return self;
}


#pragma mark - Methods

- (void)generateBaseCities
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:self.dbManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.dbManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] != 3)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSError* error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        for (NSDictionary *city in (NSArray *)result)
        {
            City *cityObj = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.dbManager.managedObjectContext];
            cityObj.name        = [[city objectForKey:@"city"] objectForKey:@"name"];
            cityObj.primaryKey  = [[city objectForKey:@"city"] objectForKey:@"id"];
            NSError *saveError;
            [self.dbManager saveContext:saveError];
            
        }
    }
}

- (void)deleteBaseCities
{
    for (City *city in [self getCities])
    {
        [self.dbManager.managedObjectContext deleteObject:city];
    }
}

- (City *)getCityWithName:(NSString *)name
{
    // Request creation
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:self.dbManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // Predicate
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self.name == %@", name];
    [fetchRequest setPredicate:predicate];
    
    // Start request
    NSError *error;
    NSArray *fetchedObjects = [self.dbManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count])
    {
        return [fetchedObjects objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Save and rollback

-(BOOL)saveContext:(NSError *)error
{
    return [self.dbManager saveContext:error];
}

-(void)rollback
{
    [self.dbManager.managedObjectContext rollback];
}

#pragma mark - Get methods

- (NSArray *)getCities
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:self.dbManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.dbManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}
@end
