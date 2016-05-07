//
//  IWDataController.h
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/03.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCondition.h"

@interface IWDataController : NSObject

- (WeatherCondition *) fetchWeatherCondition;
@end
