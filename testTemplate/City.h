//
//  City.h
//  testTemplate
//
//  Created by cdebortoli on 28/10/2013.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forecast;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * primaryKey;
@property (nonatomic, retain) NSSet *forescasts;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addForescastsObject:(Forecast *)value;
- (void)removeForescastsObject:(Forecast *)value;
- (void)addForescasts:(NSSet *)values;
- (void)removeForescasts:(NSSet *)values;

@end
