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
    bool searching;
    ListaAMA *amas;
    AMA *amaMaisProxima;
    CLLocationCoordinate2D loc;
    MKRoute *rota;

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

- (IBAction)atualizarPS:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *atualizarPS;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurViewOutlet;


@property MKPointAnnotation *pointMarker;

@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanciaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endereco;


- (IBAction)rotaBotao:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rotaBotao;
@property (weak, nonatomic) IBOutlet UILabel *rota;
- (IBAction)cancelarRota:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelarRota;
- (IBAction)mostrarPS:(id)sender;

-(void) calculoDistancia: (CLLocationCoordinate2D)loc;


@end
