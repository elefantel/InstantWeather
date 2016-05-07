//
//  WeatherCondition+CoreDataProperties.h
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/03.
//  Copyright © 2016 OpenCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherCondition.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCondition (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSNumber *latitudeCoordinate;
@property (nullable, nonatomic, retain) NSNumber *longitudeCoordinate;
@property (nullable, nonatomic, retain) NSNumber *maximumTemperature;
@property (nullable, nonatomic, retain) NSNumber *minimumTemperature;
@property (nullable, nonatomic, retain) NSNumber *temperature;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) id weatherDescription;

@end

NS_ASSUME_NONNULL_END
