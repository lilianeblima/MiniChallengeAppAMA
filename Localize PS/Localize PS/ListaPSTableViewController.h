//
//  ListaPSTableViewController.h
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AMA.h"
#import "ListaAMA.h"
#import "PSTableViewCell.h"

@interface ListaPSTableViewController : UITableViewController<CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *armazenar;
@property NSString * latiduteUM;
@property NSString *longitudeUM;





@end
