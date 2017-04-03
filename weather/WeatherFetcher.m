//
//  WeatherFetcher.m
//  weather
//
//  Created by Juneja, Kavish (Contractor) on 4/2/17.
//  Copyright © 2017 Juneja, Kavish (Contractor). All rights reserved.
//

#import "WeatherFetcher.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "UIAlertController+Window.h"

@implementation WeatherFetcher
@synthesize delegate ;


/**
 * Returns weather condition by taking the input as URL. Interface method to AFnetworking.
 * @param URL Location latitude
 */

- (void)fetchWeatherFromProvider:(NSString*)URL completionBlock:
(void (^)(NSDictionary *))completionBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    [manager GET:URL parameters:nil success:
     ^(AFHTTPRequestOperation* operation, id responseObject) {
         if (responseObject) {
             completionBlock(responseObject);
             
         } else {
             // handle no results
              completionBlock([NSDictionary dictionaryWithObjectsAndKeys:@"No Result Found!",@"Error", nil]);
         }
     } failure:^(AFHTTPRequestOperation*
                 operation, NSError *error) {
         // handle error
         
         if (error.code==-1011) {
              completionBlock([NSDictionary dictionaryWithObjectsAndKeys:@"No Results Found!",@"Error", nil]);
         }
         else{
         
          completionBlock([NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription],@"Error", nil]);
         }
     }
     ];
}

/**
 * Returns weekly forecasted weather conditions
 * for the specified lat/long
 *
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param completionBlock Array of weather results
 */

- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude
         completionBlock:(void (^)(NSArray *))completionBlock {
    
    
    // formulate the url to query the api to get the 7 day
    // forecast. cnt=7 asks the api for 7 days. units = imperial
    // will return temperatures in Farenheit
    NSString* url = [NSString stringWithFormat:
                     @"http://api.openweathermap.org/data/2.5/forecast/daily?units=imperial &cnt=7&lat=%f&lon=%f&APPID=%@", latitude, longitude,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APPID"]];
    
    
    // escape the url to avoid any potential errors
    
    url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an array of weather objects (one for each day)
         
         NSMutableArray *weeklyWeather =
         [[NSMutableArray alloc] init];
         
         for(NSDictionary* weather in weatherData[@"list"]) {
             // pass false since the weather is a future forecast
             // this lets the init function know which format of
             // data to parse
             Weather* day = [[Weather alloc] initWithDictionary:weather isCurrentWeather:FALSE];
             
             [weeklyWeather addObject:day];
         }
         
         completionBlock(weeklyWeather);
     }];
}

/**
 * Returns realtime weather conditions
 * for the specified lat/long
 *
 * @param latitude Location latitude
 * @param longitude Location longitude
 * @param completionBlock Weather object
 */

- (void)getCurrentWeather:(float)latitude longitude:(float)longitude
          completionBlock:(void (^)(Weather *))completionBlock {
    // formulate the url to query the api to get current weather
    NSString* url = [NSString stringWithFormat:@"%@units=imperial&cnt=7&lat=%f&lon=%f&APPID=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"weatherBaseURL"], latitude, longitude,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APPID"]];
    
    // escape the url to avoid any potential errors
     url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an weather object by initializing it with
         // data from the API
         
         
         // Checking errors
         BOOL isHavingError = NO;
         NSString *errorStr = nil;
         
         for (NSString*str in [weatherData allKeys]) {
             
             if ([str isEqualToString:@"Error"]) {
                 isHavingError = YES;
                 errorStr = weatherData[@"Error"];
                 break;
             }
         }
         
         if (isHavingError) {
             [self showAlertViewController:errorStr];
         }
         else{
             completionBlock([[Weather alloc] initWithDictionary:weatherData isCurrentWeather:TRUE]);
         }
         
     }];
}

/**
 * Returns realtime weather conditions
 * for the specified lat/long
 * @param cityName name
 * @param completionBlock Weather object
 */

- (void)getCurrentWeatherForCity:(NSString*)cityName isCelsius:(BOOL)isCelsius completionBlock:(void (^)(Weather *))completionBlock {
    // formulate the url to query the api to get current weather
    
    NSString* url = nil;
    
    if (isCelsius) {
        url = [NSString stringWithFormat:@"%@units=metric&cnt=7&q=%@&APPID=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"weatherBaseURL"], cityName,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APPID"]];
    }
    else{
    
        url = [NSString stringWithFormat:@"%@units=imperial&cnt=7&q=%@&APPID=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"weatherBaseURL"], cityName,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APPID"]];
    }
    
    // escape the url to avoid any potential errors
    url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    // call the fetch function fetchWeatherFromProvider
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an weather object by initializing it with
         // data from the fetchWeatherFromProvider
         
         BOOL isHavingError = NO;
         NSString *errorStr = nil;
         
         for (NSString*str in [weatherData allKeys]) {
             
             if ([str isEqualToString:@"Error"]) {
                 isHavingError = YES;
                 errorStr = weatherData[@"Error"];
                 break;
             }
         }
         
         if (isHavingError) {
             [self showAlertViewController:errorStr];
         }
         else{
             completionBlock([[Weather alloc] initWithDictionary:weatherData isCurrentWeather:TRUE]);
         }
         
     }]; 
}


/**
 * Returns weather icon
 * @param iconId name
 */

-(void)getWeatherIcon:(id)iconId{
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://openweathermap.org/img/w/%@.png",iconId]]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setWeatherImage:)]) {
            [self.delegate setWeatherImage:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        
        [self showAlertViewController:[error localizedDescription]];
    }];
    [requestOperation start];
    
}

/**
 * Common method to show alert view
 * @param errorStr - String having error Value
 */


-(void)showAlertViewController:(NSString*)errorStr{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message: errorStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Error:%@", errorStr);
        
    }]];
    
    [alert show];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWeatherImage:)]) {
        [self.delegate clearAlltext];
    }

    
}


@end
