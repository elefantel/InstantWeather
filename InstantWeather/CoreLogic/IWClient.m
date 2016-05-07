//
//  IWClient.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/02.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import "IWClient.h"

@implementation IWClient

+ (instancetype)sharedClient {
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
 
    return _sharedClient;
}

- (NSManagedObjectContext *) managedObjectContext {
    return [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
}

- (void) setupEntityMappingForObjectStore: (RKManagedObjectStore *) managedObjectStore withObjectManager: (RKObjectManager *) objectManager {
    RKEntityMapping * weatherConditionMapping = [RKEntityMapping mappingForEntityForName:@"WeatherCondition" inManagedObjectStore:managedObjectStore];
    weatherConditionMapping.identificationAttributes = @[@"city"];
    [weatherConditionMapping addAttributeMappingsFromDictionary:
                    @{@"name": @"city",
                    @"dt": @"time",
                    @"coord.lat": @"latitudeCoordinate",
                    @"coord.lon": @"longitudeCoordinate",
                    @"main.temp": @"temperature",
                    @"main.temp_min": @"minimumTemperature",
                    @"main.temp_max": @"maximumTemperature",
                    @"weather": @"weatherDescription",
                    }];
    
    RKResponseDescriptor * weatherConditionResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:weatherConditionMapping
                                             method:RKRequestMethodGET
                                        pathPattern:nil
                                            keyPath:nil
                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
    ];

    [objectManager addResponseDescriptor:weatherConditionResponseDescriptor];
}

- (void) setupClientDatabaseForAPI:(NSURL *)APIbaseURL {
    // Initialize RestKit using API base address
    RKObjectManager * objectManager = [RKObjectManager managerWithBaseURL:APIbaseURL];
    
    // Initialize Core Data's managed object model from the bundle
    NSManagedObjectModel * managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Initialize RestKit's managed object store
    RKManagedObjectStore * managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Complete Core Data stack initialization via RestKit
    [managedObjectStore createPersistentStoreCoordinator];
    NSString * persistentStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"InstantWeatherDB.sqlite"];
    NSError * error;
    
    if (!persistentStorePath) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", persistentStorePath, error);
    }
    
    NSPersistentStore * persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:persistentStorePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
        
    // Create RestKit's managed object contexts
    [managedObjectStore createManagedObjectContexts];
     
    // Configure a managed object cache
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    [self setupEntityMappingForObjectStore:managedObjectStore withObjectManager:objectManager];
}

- (void)requestWeatherConditionForCoordinate:(CLLocationCoordinate2D)coordinate success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock {
    NSDictionary *APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    NSString *APIKey = [APIConfig objectForKey:@"APIKey"];
    NSString *requestPath = [[NSString alloc] initWithFormat:@"?lat=%f&lon=%f&appid=%@",coordinate.latitude, coordinate.longitude, APIKey];
    
    //Manager performs web request, maps JSON file to Core Data entity and saves entity in Core Data.
	[[RKObjectManager sharedManager]
     		getObjectsAtPath:requestPath
		      parameters:nil
        		 success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                            {
                            //HTTP status 200:OK
                            RKLogInfo(@"Loading data from API successful.");
                            successBlock();
                        	}
        		  failure: ^(RKObjectRequestOperation *operation, NSError *error)
                            {
                            //Log description of HTTP error codes
                            RKLogError(@"Loading from API failed. %@", error.localizedDescription);
                            failureBlock(error);
                        	}
     ];
}
@end
