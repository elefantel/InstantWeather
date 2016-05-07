//
//  IWClient.h
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/02.
//  Copyright © 2016 OpenCode. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface IWClient : NSObject
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedClient;
- (void) setupClientDatabaseForAPI:(NSURL *)APIbaseURL;
- (void)requestWeatherConditionForCoordinate:(CLLocationCoordinate2D)coordinate success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;
@end
