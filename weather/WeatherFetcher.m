//
//  WeatherFetcher.m
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
//

#import "WeatherFetcher.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "AFHTTPRequestOperation.h"
#import "UIAlertController+Window.h"

@implementation WeatherFetcher
@synthesize delegate    ;

- (void)fetchWeatherFromProvider:(NSString*)URL completionBlock:
(void (^)(NSDictionary *))completionBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    [manager GET:URL parameters:nil success:
     ^(AFHTTPRequestOperation* operation, id responseObject) {
         if (responseObject) {
             completionBlock(responseObject);
             
         } else {
             // handle no results
              completionBlock([NSDictionary dictionaryWithObjectsAndKeys:@"No Result !",@"Error", nil]);
         }
     } failure:^(AFHTTPRequestOperation*
                 operation, NSError *error) {
         // handle error
          completionBlock([NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription],@"Error", nil]);
     }
     ];
}

- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude
         completionBlock:(void (^)(NSArray *))completionBlock {
    
    // formulate the url to query the api to get the 7 day
    // forecast. cnt=7 asks the api for 7 days. units = imperial
    // will return temperatures in Farenheit
    NSString* url = [NSString stringWithFormat:
                     @"http://api.openweathermap.org/data/2.5/forecast/daily?units=imperial &cnt=7&lat=%f&lon=%f&APPID=%@", latitude, longitude,@"db437132f1b0182cbea41194fc27ce53"];
    
    
    // escape the url to avoid any potential errors
    
    url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    
    // call the fetch function from Listing 4
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an array of weather objects (one for each day)
         // initialize them using the function from listing 7
         // and return the results to the calling controller
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

- (void)getCurrentWeather:(float)latitude longitude:(float)longitude
          completionBlock:(void (^)(Weather *))completionBlock {
    // formulate the url to query the api to get current weather
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?units=imperial&cnt=7&lat=%f&lon=%f&APPID=%@", latitude, longitude,@"db437132f1b0182cbea41194fc27ce53"];
    
    // escape the url to avoid any potential errors
     url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    // call the fetch function from Listing 4
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an weather object by initializing it with
         // data from the API using the init func from Listing 7
         
         
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

- (void)getCurrentWeatherForCity:(NSString*)cityName isCelsius:(BOOL)isCelsius completionBlock:(void (^)(Weather *))completionBlock {
    // formulate the url to query the api to get current weather
    
    NSString* url = nil;
    
    if (isCelsius) {
        url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?units=metric&cnt=7&q=%@&APPID=%@", cityName,@"db437132f1b0182cbea41194fc27ce53"];
    }
    else{
    
        url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?units=imperial&cnt=7&q=%@&APPID=%@", cityName,@"db437132f1b0182cbea41194fc27ce53"];
    }
    
    // escape the url to avoid any potential errors
    url = [url  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    // call the fetch function from Listing 4
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
         // create an weather object by initializing it with
         // data from the API using the init func from Listing 7
         
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


-(void)showAlertViewController:(NSString*)errorStr{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message: errorStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Error:%@", errorStr);
        
    }]];
    
    [alert show];
    
}


@end
