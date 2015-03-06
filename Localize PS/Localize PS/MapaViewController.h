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
#import "PointMarker.h"
#import "Place.h"
#import "ListaAMA.h"


@interface MapaViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    bool placesLocated;
    bool searching;
    CLPlacemark *thePlacemark;
    ListaAMA *amas;
    AMA *auxiliar;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

- (IBAction)mostraRota:(id)sender;
- (IBAction)localizacaoAtual:(id)sender;
- (IBAction)atualizarPS:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *atualizarPS;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurViewOutlet;


@property MKPointAnnotation *pointMarker;

@property NSMutableArray *searchQuery;
@property PointMarker *routeDestination;

@property (weak, nonatomic) IBOutlet UIButton *voltarNav;

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanciaLabel;

+ (instancetype)sharedInstance;
- (IBAction)voltarNav:(id)sender;
- (void)searchLocations: (MKCoordinateRegion)region;

- (IBAction)rotaBotao:(id)sender;


@end
