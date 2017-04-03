//
//  UIAlertController+Window.h
//  weather
//
//  Created by Junejha, Kavesh (Contractor) on 4/2/17.
//  Copyright © 2017 Junejha, Kavesh (Contractor). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end
