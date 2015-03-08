//
//  Mapa_TabelaViewController.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 06/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "Mapa_TabelaViewController.h"

@interface Mapa_TabelaViewController ()

@end

@implementation Mapa_TabelaViewController

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static Mapa_TabelaViewController *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)viewDidLoad{
    

    searching = NO;
  
    [self.MapView setDelegate:self];
    
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
   

    
    
    //chama a funcao calculoDistancia mandando a localização atual
    loc = [[_locationManager location]coordinate];

    
    [super viewDidLoad];
    
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Location"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([self.itemSelecionado.latitude doubleValue],[self.itemSelecionado.longitude doubleValue]) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    [self traceRoute:srcMapItem to:distMapItem];
    [_locationManager startUpdatingLocation];
    [self NearestPS];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)NearestPS {
    
    CLLocationCoordinate2D crd = CLLocationCoordinate2DMake([self.itemSelecionado.latitude doubleValue], [self.itemSelecionado.longitude doubleValue]);
    PointMarker *pin = [[PointMarker alloc] initWithCoordinate:crd title: self.itemSelecionado.nome Subtitle: self.itemSelecionado.endereco Distance:self.itemSelecionado.distancia];
    [_MapView addAnnotation:pin];
    [_MapView selectAnnotation:pin animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(crd, 800, 800);
    [_MapView setRegion : region animated:YES];
    
}

-(void)traceRoute:(MKMapItem *) source to: (MKMapItem *) destination {
    [_MapView removeOverlay:rota.polyline];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    [request setSource:source];
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            rota = obj;
            MKPolyline *line = [rota polyline];
            [_MapView addOverlay:line level:MKOverlayLevelAboveRoads];
            
            NSArray *steps = [rota steps];
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
            }];
        }];
        NSInteger t = round(rota.expectedTravelTime/60);
        NSString *tempo = [NSString stringWithFormat:@"Tempo: %ld min",(long)t];
        NSLog(@"tempo %@", tempo);
        [_LTempo setText:tempo];
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D location = [ [locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 800, 800);
    
    if (!searching) {
        searching = YES;
        [_MapView setRegion:region animated:YES];
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
 * Botão para atualizar achar Posição atual no mapa
 *  - Ao clicar ele mesmo se esconde
 *
 */
- (IBAction)BAtualizar:(id)sender {
    [_locationManager startUpdatingLocation];
    [self NearestPS];
    [_batualiza setHidden:YES];
    
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
-(IBAction)BLocHosp:(id)sender {

    [self NearestPS];
}



#pragma mark dd

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
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
        [annotationView setImage:[UIImage imageNamed:@"ps.png"]];
        //nao deixa legenda encima da imagem
        annotationView.centerOffset = CGPointMake(0,-annotationView.frame.size.height*0.5);
        return annotationView;
    }
    return nil;
}



@end
