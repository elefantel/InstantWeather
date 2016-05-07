//
//  IWViewController.m
//  InstantWeather
//
//  Created by Mpendulo Ndlovu on 2016/05/01.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IWViewController.h"
#import "IWManager.h"
#import "LoadingViewController.h"
#import "IWClient.h"
#import "IWDataController.h"

@interface IWViewController ()

@end

@implementation IWViewController {
    __weak IBOutlet UIImageView *_iconImageView;
    __weak IBOutlet UILabel *_cityLabel;
    __weak IBOutlet UILabel *_descriptionLabel;
    __weak IBOutlet UILabel *_temperatureLabel;
    __weak IBOutlet UILabel *_maximumTemperatureLabel;
    __weak IBOutlet UILabel *_minimumTemperatureLabel;
    __weak IBOutlet UILabel *_timeLabel;
    IBOutlet UIView *_backgroundImageView;
    IWManager *_weatherManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDisplayForNewLocation:) name:IWLocationChangeNotification object:nil];
    _weatherManager = [IWManager new];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onRefreshButtonPress:(id)sender {
    //[_weatherManager updateLocation];
    CLLocationDegrees lat = -33.8500000;
    CLLocationDegrees lon = 18.5833330;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat,lon);
    [self updateDisplayWithWeatherConditionForLocation:location];
}

- (void)updateDisplayForNewLocation:(NSNotification *)notification {
    NSDictionary * locationNotification = [notification userInfo];
    CLLocationDegrees lat = [locationNotification[@"latitude"] floatValue];
    CLLocationDegrees lon = [locationNotification[@"longitude"] floatValue];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat,lon);
    [self updateDisplayWithWeatherConditionForLocation:location];
}

- (void) updateDisplayWithWeatherConditionForLocation:(CLLocationCoordinate2D)location {
    [LoadingViewController displayLoadingView];
    
    [[IWClient sharedClient] requestWeatherConditionForCoordinate:location
    success:^ {
        IWDataController *weatherDataController;
        WeatherCondition *weatherCondition;
        
        weatherDataController = [IWDataController new];
        weatherCondition = [weatherDataController fetchWeatherCondition];
        [LoadingViewController removeLoadingView];
        
        [self displayWeatherCondition:weatherCondition];
    }
    failure:^(NSError *error) {
        [LoadingViewController removeLoadingView];
        [self displayError:error];
    }];
}

- (void) displayError:(NSError *)error {
        NSString * alertTitle = NSLocalizedString(@"InstantWeather Error", nil);
        NSString * alertMessage = [NSString localizedStringWithFormat:NSLocalizedString(@"%@", nil), [error localizedDescription]];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];

        [errorAlert show];
}

- (void)displayWeatherCondition:(WeatherCondition *)weatherCondition {
    [_backgroundImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    _cityLabel.text = [weatherCondition city];
    _temperatureLabel.text = [@([[weatherCondition temperature] integerValue] - 273) stringValue];
    
    _maximumTemperatureLabel.text = [@([[weatherCondition maximumTemperature] integerValue] - 273) stringValue];
    _minimumTemperatureLabel.text = [@([[weatherCondition minimumTemperature] integerValue] - 273) stringValue];

    NSString *dateString = [NSDateFormatter localizedStringFromDate:[weatherCondition time]
                                                      dateStyle:kCFDateFormatterMediumStyle
                                                      timeStyle:kCFDateFormatterShortStyle];
    _timeLabel.text = dateString;
    
    NSDictionary *weatherDescriptionDictionary = [[weatherCondition weatherDescription] firstObject];
    _descriptionLabel.text = [NSString stringWithFormat:@"%@",[weatherDescriptionDictionary objectForKey:@"description"]];
    _iconImageView.image = [UIImage imageNamed:[weatherDescriptionDictionary objectForKey:@"icon"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
