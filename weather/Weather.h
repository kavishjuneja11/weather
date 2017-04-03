//
//  Weather.h
//  weather
//
//  Created by Juneja, Kavish (Contractor) on 4/2/17.
//  Copyright © 2017 Juneja, Kavish (Contractor). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

/// the date this weather is relevant to
@property (nonatomic, strong) NSDate *dateOfForecast;

/// the general weather status:
/// clouds, rain, thunderstorm, snow, etc...
@property (nonatomic, strong) NSString* status;

/// the ID corresponding to general weather status
@property (nonatomic) int statusID;

/// a more descriptive weather condition:
/// light rain, heavy snow, etc...
@property (nonatomic, strong) NSString* condition;

/// min/max temp in farenheit
@property (nonatomic) int temperatureMin;
@property (nonatomic) int temperatureMax;

/// current temp in farenheit
@property (nonatomic) int currentTemp;

/// current humidity level (perecent)
@property (nonatomic) int humidity;

/// current wind speed in mph
@property (nonatomic) float windSpeed;

/// current wind speed in mph
@property (nonatomic) NSString* iconID;

// date since 1970
@property (nonatomic) int date;

@property(nonatomic) int sunset;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                  isCurrentWeather:(BOOL)isCurrentWeather;

@end
