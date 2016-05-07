//
//  IWAppDelegate.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/01.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import "IWAppDelegate.h"
#import "IWClient.h"

@interface IWAppDelegate ()

@end

@implementation IWAppDelegate

NSString *const IWClientAPIBaseURL = @"http://api.openweathermap.org/data/2.5/weather";
NSString *const IWClientAPIKey = @"53f9d8e4213222cf517d86dc406d67fc";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSMutableDictionary *APIConfig;
    APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    
    if (APIConfig == nil) {
        APIConfig = [[NSMutableDictionary alloc] init];
        [APIConfig setObject: IWClientAPIBaseURL forKey:@"APIBaseURL"];
        [APIConfig setObject: IWClientAPIKey forKey:@"APIKey"];
        [[NSUserDefaults standardUserDefaults] setObject:APIConfig forKey:@"APIConfig"];
    }
    
    [[IWClient sharedClient] setupClientDatabaseForAPI:[NSURL URLWithString:[APIConfig objectForKey:@"APIBaseURL"]]];
    return YES;
}

@end
