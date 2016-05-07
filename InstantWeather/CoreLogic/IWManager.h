//
//  IWManager.h
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/02.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

#define IWDefineNotification(n) static NSString* const n = @#n;
IWDefineNotification(IWLocationChangeNotification);

@interface IWManager : NSObject
@property(nonatomic) CLLocationCoordinate2D location;

- (void)updateLocation;

@end
