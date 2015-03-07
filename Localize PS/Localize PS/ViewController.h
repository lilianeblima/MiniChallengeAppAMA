//
//  ViewController.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    
NSArray *query;

}

+ (instancetype)singleton;


- (IBAction)mostraMapa:(id)sender;
- (IBAction)mostraListaPS:(id)sender;

@end

