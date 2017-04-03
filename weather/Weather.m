//
//  Weather.m
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                  isCurrentWeather:(BOOL)isCurrentWeather{
    self = [super init];
    
    if (self) {
        /*
         * Parse weather data from the API into this weather
         * object. Error check each field as there is no guarantee
         * that the same data will be available for every location
         */
        
        _dateOfForecast = [self utcToLocalTime:[NSDate
                                                dateWithTimeIntervalSince1970:
                                                [dictionary[@"dt"] doubleValue]]];
        
        
        NSLog(@"dict : %@",dictionary);
        
        // use the bool to determine which data format to parse
        if (isCurrentWeather) {
            int temperatureMin =
            [dictionary[@"main"][@"temp_min"] intValue];
            if(temperatureMin) {
                _temperatureMin = temperatureMin;
            }
            
            int temperatureMax =
            [dictionary[@"main"][@"temp_max"] intValue];
            if (temperatureMax) {
                _temperatureMax = temperatureMax;
            }
            int currentTemp =
            [dictionary[@"main"][@"temp"] intValue];
            if (currentTemp) {
                _currentTemp = temperatureMax;
            }
            
            int humidity =
            [dictionary[@"main"][@"humidity"] intValue];
            if (humidity) {
                _humidity = humidity;
            }
            
            float windSpeed =
            [dictionary[@"wind"][@"speed"] floatValue];
            if (windSpeed) {
                _windSpeed = windSpeed;
            }
            int date =
            [dictionary[@"dt"] intValue];
            if (date) {
                _date = date;
            }
            int SunsetTime =
            [dictionary[@"sys"][@"sunset"] intValue];
            if (SunsetTime) {
                _sunset = SunsetTime;
            }
            
            
        }
        else {
            int temperatureMin =
            [dictionary[@"temp"][@"min"] intValue];
            if (temperatureMin) {
                _temperatureMin = temperatureMin;
            }
            
            int temperatureMax =
            [dictionary[@"temp"][@"max"] intValue];
            if (temperatureMax) {
                _temperatureMax = temperatureMax;
            }
            int currentTemp =
            [dictionary[@"main"][@"temp"] intValue];
            if (currentTemp) {
                _currentTemp = temperatureMax;
            }
            
            int humidity =
            [dictionary[@"humidity"] intValue];
            if (humidity) {
                _humidity = humidity;
            }
            
            float windSpeed =
            [dictionary[@"speed"] floatValue];
            if (windSpeed) {
                _windSpeed = windSpeed;
            }
            int date =
            [dictionary[@"dt"] intValue];
            if (date) {
                _date = date;
            }
            
            int SunsetTime =
            [dictionary[@"sys"][@"sunset"] intValue];
            if (SunsetTime) {
                _sunset = SunsetTime;
            }
            
        }
        
        /*
         * weather section of the response is an array of
         * dictionary objects. The first object in the array
         * contains the desired weather information.
         * this JSON is formatted the same for both requests
         */
        NSArray* weather = dictionary[@"weather"];
        if ([weather count] > 0) {
            NSDictionary* weatherData = [weather objectAtIndex:0];
            if (weatherData) {
                NSString *status = weatherData[@"main"];
                if (status) {
                    _status = status;
                }
                
                int statusID = [weatherData[@"id"] intValue];
                if (statusID) {
                    _statusID = statusID;
                }
                
                NSString *condition = weatherData[@"description"];
                if (condition) {
                    _condition = condition;
                }
                
                NSString *iconID = weatherData[@"icon"];
                if (condition) {
                    _iconID = iconID;
                }
            }
        }
        
    }
    
    return self;
}

/**
 * Takes a unic UTC timestamp and converts it
 * to an NSDate formatted in the device’s local
 * timezone
 *
 * @param date Date to be converted
 *
 * @return Converted date
 */
-(NSDate *)utcToLocalTime:(NSDate*)date {
    NSTimeZone *currentTimeZone =
    [NSTimeZone defaultTimeZone];
    NSInteger secondsOffset =
    [currentTimeZone secondsFromGMTForDate:date];
    return [NSDate dateWithTimeInterval:
            secondsOffset sinceDate:date];
}


@end
