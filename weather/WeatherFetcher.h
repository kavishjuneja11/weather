//
//  WeatherFetcher.h
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@protocol weatherViewControllerDelegate <NSObject>

-(void)setWeatherImage:(id)img;

@end

@interface WeatherFetcher : NSObject

/**
 * Returns weekly forecasted weather conditions
 * for the specified lat/long
 *
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param completionBlock Array of weather results
 */
- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude
         completionBlock:(void (^)(NSArray *))completionBlock;

/**
 * Returns realtime weather conditions
 * for the specified lat/long
 *
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param completionBlock Weather object
 */
- (void)getCurrentWeather:(float)latitude longitude:(float)longitude
          completionBlock:(void (^)(Weather *))completionBlock;

/**
 * Returns realtime weather conditions
 * for the specified lat/long
 * @param cityName name
 * @param completionBlock Weather object
 */

- (void)getCurrentWeatherForCity:(NSString*)cityName isCelsius:(BOOL)isCelsius completionBlock:(void (^)(Weather *))completionBlock;

-(void)getWeatherIcon:(id)iconId;

@property (nonatomic, weak) id<weatherViewControllerDelegate> delegate;

@end
