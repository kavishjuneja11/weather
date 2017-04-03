//
//  UIAlertController+Window.h
//  weather
//
//  Created by Juneja, Kavish (Contractor) on 4/2/17.
//  Copyright © 2017 Juneja, Kavish (Contractor). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// Category created to show UIALertViewController on main Window.

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end
