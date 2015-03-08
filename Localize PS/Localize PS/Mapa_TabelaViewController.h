//
//  Mapa_TabelaViewController.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 06/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MKAnnotation.h"
#import "PointMarker.h"
#import "AMA.h"

@interface Mapa_TabelaViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
     MKRoute *rota;
    bool searching;
    CLLocationCoordinate2D loc;
}

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property AMA *itemSelecionado;
@property bool searching;
@property int AtualizarPosicao;
@property CLLocationCoordinate2D *loc;
@property (weak, nonatomic) IBOutlet UILabel *labelteste;
@property MKPointAnnotation *pointMarker;
@property CLLocationManager *locationManager;
- (IBAction)BAtualizar:(id)sender;
+ (instancetype)sharedInstance;
@property (weak, nonatomic) IBOutlet UILabel *LTempo;
@property (weak, nonatomic) IBOutlet UIButton *batualiza;

- (IBAction)BLocHosp:(id)sender;

@end
