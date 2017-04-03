//
//  WeatherViewConroller.m
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
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

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"text : %@",searchBar.text);
    [fetch getCurrentWeatherForCity:_searchBar.text isCelsius:!_TempInFSwitch.isOn  completionBlock:^(Weather* weather){
        
        _lblCondition.text =  weather.condition;
        _lblMinTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMin];
        _lblMaxTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.temperatureMax];
        _lblCurrentTemp.text =   [NSString stringWithFormat:@"%d\u00B0",weather.currentTemp];
        
        
        [fetch getWeatherIcon:weather.iconID];
        
    }];
 
    //(Weather* weather)
    
}

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
            
        }];
    }
    
}

-(void)setWeatherImage:(id)img{
    
    _weatherConditionImgView.image  = img;
}


- (IBAction)switchTapped:(id)sender{
    
    if (_TempInFSwitch.on) {
        [self CovertTempToF:sender];
    }
    else{
        [self CovertTempToCelcius:_lblMaxTemp.text  :_lblMinTemp.text :_lblCurrentTemp.text ];
    }
}

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

//(celsius * 1.8) + 32


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
