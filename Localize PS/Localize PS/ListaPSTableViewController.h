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
{
    AMA *ama,*ama2, *itemSelecionado;
    CLLocationManager *coordenadaSelecionada;
    ListaAMA *listaAma;
    CLLocationCoordinate2D loc;
    NSArray *locali;
}

@property CLLocationManager *locationManager;







@end
