//
//  WeatherViewController.h
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Juneja, Kavish (Contractor). All rights reserved.
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
@property (strong, nonatomic) IBOutlet UISwitch *TempInFSwitch;
@property(retain,strong) IBOutlet UIView *containerView;

@property(nonatomic,assign)id <weatherViewControllerDelegate> weatherViewControllerDelegateObj;

/**
 * Action handler for user and sets the labels
 * @param sender name
 */
-(IBAction)didTapOnSearchIcon:(id)sender;

/**
 * Value changed handler method for UISwitch
 * @param sender name
 */
- (IBAction)switchTapped:(id)sender;

@end

