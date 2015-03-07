//
//  MapaViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "MapaViewController.h"


@implementation MapaViewController

-(void)viewDidLoad{
    
    amas = [ListaAMA ItensCompartilhado];
    auxiliar = [[AMA alloc]init];
    
    searching = NO;
    [self.blurViewOutlet setHidden:YES];
    
    [self.mapView setDelegate:self];
    
    //Pega instancia
    _locationManager = [[CLLocationManager alloc] init];
    
    
    //Define precisão do GPS
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    //Define que o delegate sera esta clase
    [_locationManager setDelegate: self];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //Começa monitorar localização
    [_locationManager startUpdatingLocation];
    
    [_atualizarPS setHidden:YES];     // ocultar voltarNav
    
    loc = [[_locationManager location]coordinate];
    [self calculoDistancia: loc];
    
    PointMarker *ps = [[PointMarker alloc] init];
    [_mapView addAnnotation:ps];
    [_mapView selectAnnotation:ps animated: YES];
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//- (void)findDirectionsFrom:(MKMapItem *) source to: (MKMapItem *) destination {
//    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//    
//    request.source = source;
//    
//    request.transportType = MKDirectionsTransportTypeWalking;
//    
//    request.destination = destination;
//    
//    
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//    
//    [directions calculateDirectionsWithCompletionHandler:
//     ^(MKDirectionsResponse *response, NSError *error) {
//         
//         //stop loading animation here
//         
//         if (error) {
//             NSLog(@"Error is %@",error);
//         } else {
//             //do something about the response, like draw it on map
//             MKRoute *route = [response.routes firstObject];
//             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
//         }
//     }];
//    
//}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D location = [ [locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 800, 800);
    
    if (!searching) {
        searching = YES;
        [_mapView setRegion:region animated:YES];
        searching = NO;
    }
}

/*
 * Funcão para desenhar a Rota no Mapa
 *
*/
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
}

/*
 * Ao tocar na Tela:
 * - Para de atualizar localização
 * - Mostrar Botão de atualizar localização
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_locationManager stopUpdatingLocation];
    [_atualizarPS setHidden:NO];     // mostrar voltarNav
}

/*
 * Botão para atualizar achar Posição atual no mapa
 *  - Ao clicar ele mesmo se esconde
 *
*/
- (IBAction)atualizarPS:(id)sender {
    [_locationManager startUpdatingLocation];
    [_atualizarPS setHidden:YES];
}





- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            MKAnnotationView* annotationView = aV;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
    }
}


/* 
 *  Calcula as distancias de todos os Prontos Socorros
 * setando a distância em cada um.
 *  Todos os prontos socorros estão guardados em um 
 * objeto do tipo ListaAMA e são ordenados de acordo
 *  com a distancia, oque tive a distância mais próxima
 *  da posição atual ficara na posicão 0 do vetor.
*/
- (void) calculoDistancia : (CLLocationCoordinate2D) loc{
    CLLocation *inicial = [[CLLocation alloc] initWithLatitude:loc.latitude longitude: loc.longitude];
    CLLocationDistance distancia;
    CLLocation *coordenadas;
    
    for (int i=0; i < [amas.AllAMA count]; i++){
        auxiliar = [amas.AllAMA objectAtIndex:i];
        coordenadas = [[CLLocation alloc] initWithLatitude:[auxiliar.latitude doubleValue]  longitude: [auxiliar.longitude doubleValue]];
        distancia = [inicial distanceFromLocation: coordenadas];
        [auxiliar setDistanciaMapa:distancia/1000];
    }
    

}

- (IBAction)rotaBotao:(id)sender {
    AMA *amaMaisProxima = [[AMA alloc]init];
    amaMaisProxima = [amas.AllAMA lastObject];
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Location"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([amaMaisProxima.latitude doubleValue],[amaMaisProxima.longitude doubleValue]) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    CLLocationCoordinate2D crd = CLLocationCoordinate2DMake([amaMaisProxima.latitude doubleValue], [amaMaisProxima.longitude doubleValue]);
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
    
    NSArray *arrRoutes = [response routes];
    [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       rota = obj;
       MKPolyline *line = [rota polyline];
       [_mapView addOverlay:line level:MKOverlayLevelAboveRoads];
       
       NSArray *steps = [rota steps];
      [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

    }];
    }];
    NSInteger t = round(rota.expectedTravelTime/60);
    NSString *tempo = [NSString stringWithFormat:@"Tempo previsto: %ld min",(long)t];
        NSLog(@"tempo %@", tempo);
    
    PointMarker *pin = [[PointMarker alloc] initWithCoordinate:crd title: [amaMaisProxima nome] Subtitle: [amaMaisProxima endereco]];
    [_mapView addAnnotation:pin];
    [_mapView selectAnnotation:pin animated:YES];
    }];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(crd, 800, 800);

    [_mapView setRegion : region animated:YES];

}

#pragma mark dd

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
       
        //Mudar Nome do annotation de Localização do Usuário
        ((MKUserLocation *)annotation).title = @"Sua localização atual";
        
        return nil;  //return nil to use default blue dot view
    }
   if ([annotation isKindOfClass:[PointMarker class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        if ( annotationView == nil){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: identifier];
        }
        else
            annotationView.annotation = annotation;
        
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    self.nomeLabel.text = [view.annotation title];
    self.telefoneLabel.text = [view.annotation subtitle];
    self.distanciaLabel.text = [view.annotation subtitle];
    
    self.blurViewOutlet.hidden = NO;
    //view.pinColor = MKPinAnnotationColorGreen;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[view.annotation coordinate] addressDictionary:nil];
    
    //self.routeDestination = [[PointMarker alloc] initWithCoordinate:placemark.coordinate title:[view.annotation title] Subtitle:@""];
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view {
    
    self.routeDestination = nil;
    self.blurViewOutlet.hidden = YES;
    
}



@end
