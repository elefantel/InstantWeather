//
//  WeatherCondition+CoreDataProperties.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/03.
//  Copyright © 2016 OpenCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherCondition+CoreDataProperties.h"

@implementation WeatherCondition (CoreDataProperties)

@dynamic city;
@dynamic latitudeCoordinate;
@dynamic longitudeCoordinate;
@dynamic maximumTemperature;
@dynamic minimumTemperature;
@dynamic temperature;
@dynamic time;
@dynamic weatherDescription;

@end
