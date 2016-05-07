//
//  IWDataController.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/03.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import "IWDataController.h"
#import "IWClient.h"

@implementation IWDataController


/*
Weather data JSON is mapped to entity and saved in Core Data. Here we retrieve that info from database.
Advantage of this is that we can view the last saved weather condition in case there is no internet connection currently.
*/

- (WeatherCondition *) fetchWeatherCondition {
    NSManagedObjectContext *context = [[IWClient sharedClient] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"WeatherCondition"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        return  nil;
        }
    
    WeatherCondition *weatherCondition = [fetchedObjects firstObject];
    
    return weatherCondition;
}

@end
