//
//  IWManager.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/02.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import "IWManager.h"
#import "IWClient.h"
#import "IWDataController.h"
#import "IWViewController.h"
#import "LoadingViewController.h"

@interface IWManager () <CLLocationManagerDelegate>
@end

@implementation IWManager
{
__strong CLLocationManager *_locationManager;
BOOL _isWeatherUpdated;
}

-(instancetype)init {
    
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }

    return self;
}

- (void) updateLocation {
    
     if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
     }
}

- (void) displayError:(NSError *)error {
        NSString * alertTitle = NSLocalizedString(@"InstantWeather Error", nil);
        NSString * alertMessage = [NSString localizedStringWithFormat:NSLocalizedString(@"%@", nil), [error localizedDescription]];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];

        [errorAlert show];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (![locations count] || _isWeatherUpdated) {
        return;
    }
 
    [manager stopUpdatingLocation];
    _isWeatherUpdated = YES;
 
    CLLocation *currentLocation = [locations objectAtIndex:0];
 
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ([placemarks count]) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocationDegrees latitude = placemark.location.coordinate.latitude;
            CLLocationDegrees longitude = placemark.location.coordinate.longitude;
            self.location = CLLocationCoordinate2DMake(latitude, longitude);
            NSDictionary *locationUpdateInfo = @{
                               @"latitude": @(self.location.latitude),
                               @"longitude": @(self.location.longitude)
                               };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IWLocationChangeNotification object:self userInfo:locationUpdateInfo];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self updateLocation];
    }
}

@end
