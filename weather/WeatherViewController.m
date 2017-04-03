//
//  WeatherViewConroller.m
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Juneja, Kavish (Contractor). All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end


@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     fetch = [[WeatherFetcher alloc]init];
    fetch.delegate=self;
    
    
    // Getting the last searched city from NSUSerDefaults and fetching the weather for that city.
    
    NSUserDefaults *lastWeather = [NSUserDefaults standardUserDefaults];
    NSString*lastSearchedCity = [lastWeather stringForKey:@"LastSeachedCity"];
    
    if (lastSearchedCity!=nil && lastSearchedCity.length>0) {
        _searchBar.text = lastSearchedCity;
        [self didTapOnSearchIcon:_searchBar.text];
    }
    else{
        NSString*lastSearchedCity = [lastWeather stringForKey:@"LastSeachedLatLong"];
        NSArray *arrLatLong = [lastSearchedCity componentsSeparatedByString:@","];
        NSString *lat = [arrLatLong objectAtIndex:0];
        NSString *long1 = [arrLatLong objectAtIndex:1];
        _searchBar.text=@"";
        _txtfieldLat.text = lat;
        _txtfieldLong.text = long1;
        
        [self didTapOnSearchIcon:_searchBar];
    }
   
    
}


/**
 * Action handler for user and sets the labels
 * @param searchBar name
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"text : %@",searchBar.text);
    [fetch getCurrentWeatherForCity:_searchBar.text isCelsius:!_TempInFSwitch.isOn  completionBlock:^(Weather* weather){
        
        _lblCondition.text =  weather.condition;
        _lblMinTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMin];
        _lblMaxTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMax];
        _lblCurrentTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.currentTemp];
        
        [[NSUserDefaults standardUserDefaults] setObject:_searchBar.text forKey:@"LastSeachedCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LastSeachedLatLong"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _txtfieldLong.text = @"";
        _txtfieldLat.text = @"";

        
        [fetch getWeatherIcon:weather.iconID];
        
    }];
     
}


/**
 * Action handler for user.  When he taps on search icon in app. If the search bar is already having content then that value is taken up rather than in the lat long text fields.
 * @param sender name
 */

-(IBAction)didTapOnSearchIcon:(id)sender{
    
    if (_searchBar.text.length>0) {
        [self searchBarSearchButtonClicked:_searchBar];
    }
    else{
        
        [fetch getCurrentWeather:[_txtfieldLat.text floatValue] longitude:[_txtfieldLong.text floatValue] completionBlock:^(Weather* weather){

            _lblCondition.text =  weather.condition;
            _lblMinTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMin];
            _lblMaxTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMax];
            _lblCurrentTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.currentTemp];
            
            [fetch getWeatherIcon:weather.iconID];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@,%@",_txtfieldLat.text,_txtfieldLong.text]forKey:@"LastSeachedLatLong"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LastSeachedCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }];
    }
    
}
/**
 * Setter for image for weather. Since this class is delegate for weatherFetcher this method is imlemented.
 * @param img name
 */


-(void)setWeatherImage:(id)img{
    
    _weatherConditionImgView.image  = img;
}

/**
 * Setter for clearing all data if no result found. Since this class is delegate for weatherFetcher this method is imlemented.
 */

-(void)clearAlltext{
    
    _lblCondition.text =  @"";
    _lblMinTemp.text =   @"";
    _lblMaxTemp.text =   @"";
    _lblCurrentTemp.text =   @"";
}


/**
 * When switch is turned off/ on this method is called.
 * @param sender name
 */

- (IBAction)switchTapped:(id)sender{
    
    if (_TempInFSwitch.on) {
        [self CovertTempToF:sender];
    }
    else{
        [self CovertTempToCelcius:_lblMaxTemp.text  :_lblMinTemp.text :_lblCurrentTemp.text ];
    }
}

/**
 * Method to Covert Temperature in fahrenheite To Celcius
 * @param max temp
 * @param min temp
 * @param current temp
 */

- (void)CovertTempToCelcius:(NSString*)max :(NSString*)min :(NSString*)current {
    float fahrenheitMax = [_lblMaxTemp.text doubleValue];
    float celsius = (fahrenheitMax - 32) / 1.8;
    NSString *resultString = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",celsius];
    _lblMaxTemp.text = resultString;
    
    float fahrenheitMin = [_lblMinTemp.text doubleValue];
    float celsiusMin = (fahrenheitMin - 32) / 1.8;
    NSString *resultStringMin = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",celsiusMin];
    _lblMinTemp.text = resultStringMin;
    
    float fahrenheitCurrent = [_lblCurrentTemp.text doubleValue];
    float celsiusCurrent = (fahrenheitCurrent - 32) / 1.8;
    NSString *resultStringCurrent = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",celsiusCurrent];
    _lblCurrentTemp.text = resultStringCurrent;

}


/**
 * Method to Covert Temperature in Celcius To fahrenheite
 * @param sender name
 */


- (void)CovertTempToF:(id)sender {
    float celciusMax = [_lblMaxTemp.text doubleValue];
    float fahrenheiteMax = (celciusMax * 1.8) + 32;
    NSString *resultString = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",fahrenheiteMax];
    _lblMaxTemp.text = resultString;
    
    float celciusMin = [_lblMinTemp.text doubleValue];
    float fahrenheiteMin = (celciusMin * 1.8) + 32;
    NSString *resultStringMin = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",fahrenheiteMin];
    _lblMinTemp.text = resultStringMin;
    
    float celciusCurrent = [_lblCurrentTemp.text doubleValue];
    float fahrenheiteCurrent = (celciusCurrent * 1.8) + 32;
    NSString *resultStringCurrent = [[NSString alloc] initWithFormat:@"%4.2f\u00B0",fahrenheiteCurrent];
    _lblCurrentTemp.text = resultStringCurrent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
