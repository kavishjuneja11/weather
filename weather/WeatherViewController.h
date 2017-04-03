//
//  WeatherViewController.h
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherFetcher.h"

@interface WeatherViewController : UIViewController<UISearchBarDelegate,UITextFieldDelegate,weatherViewControllerDelegate >{
    
    WeatherFetcher *fetch;
}

@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)IBOutlet UIImageView *weatherConditionImgView;
@property(nonatomic,strong)IBOutlet UILabel *lblCondition;
@property(nonatomic,strong)IBOutlet UILabel *lblMaxTemp;
@property(nonatomic,strong)IBOutlet UILabel *lblMinTemp;
@property(nonatomic,strong)IBOutlet UILabel *lblCurrentTemp;
@property(nonatomic,strong)IBOutlet UITextField *txtfieldLat;
@property(nonatomic,strong)IBOutlet UITextField *txtfieldLong;
@property (retain, nonatomic) IBOutlet UISwitch *TempInFSwitch;
@property (retain, nonatomic) IBOutlet UILabel *lblDate;
@property(retain,strong) IBOutlet UIView *containerView;

@property(nonatomic,assign)id <weatherViewControllerDelegate> weatherViewControllerDelegateObj;


-(IBAction)didTapOnSearchIcon:(id)sender;
- (IBAction)switchTapped:(id)sender;

@end

