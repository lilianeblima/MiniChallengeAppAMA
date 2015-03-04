//
//  MapaViewController.h
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MKAnnotation.h"

@interface MapaViewController : UIViewController <MKMapViewDelegate>
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
