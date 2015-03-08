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

//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.labelteste.text = self.itemSelecionado.latitude;
//    _AtualizarPosicao=0;
//    [super viewDidLoad];
//    //CLLocationManager *locationManager;
//    
//    //Alocar memória para o locationManager
//    self.locationManager = [[CLLocationManager alloc]init];
//    
//    //Mostrar ao locationManager o quão exata deve ser a localização encontrada
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    
//    //Determinar que a propriedade delegate do locationManager seja a instância da ViewController
//    [self.locationManager setDelegate:self];
//    
//    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//    {
//        [self.locationManager requestAlwaysAuthorization];
//    }
//    
//    
//    //Dizer ao locationManager para começar a procurar pela localização imediatamente
//    [self.locationManager startUpdatingLocation];
//    // Do any additional setup after loading the view, typically from a nib.
//    
//   
//}
//
//
//
//
//-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    MKPointAnnotation *pm = [[MKPointAnnotation alloc]init];
//    
//    NSLog(@"%@", [locations lastObject]);
//    //Encontrar as coordenadas de localização atual
//    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
//    
//    //Determinar região com as coordenadas de localização atual e os limites N/S e L/O no zoom em metros
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
//    
//    //    //Mudar a região atual para visualização de forma animada
//    if(_AtualizarPosicao==0)
//    {
//        // [_Mapa removeAnnotations:[_Mapa annotations]];
//        [_MapView setRegion:region animated:YES ];
//        
//        
//        [pm setCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude)];
//        pm.title = [NSString stringWithFormat:@"Posicao Atual"];
//        [_MapView addAnnotation:pm];
//        _AtualizarPosicao=1;
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

//----------------------------------------------------
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

    
    
    
    //    PointMarker *ps = [[PointMarker alloc] init];
    //    [_mapView addAnnotation:ps];
    //    [_mapView selectAnnotation:ps animated: YES];
    //
    
    [super viewDidLoad];
    
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(loc.latitude, loc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@"Location"];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake([self.itemSelecionado.latitude doubleValue],[self.itemSelecionado.longitude doubleValue]) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    [self traceRoute:srcMapItem to:distMapItem];
    [_locationManager startUpdatingLocation];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"disappear");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)NearestPS {
    //Take Nearest PS

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



/*
 *  Botão para calcular a rota até o
 * pronto socorro mais próximo
 *
 *
 */



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
        [annotationView setImage:[UIImage imageNamed:@"ps.png"]];
        //nao deixa legenda encima da imagem
        annotationView.centerOffset = CGPointMake(0,-annotationView.frame.size.height*0.5);
        return annotationView;
    }
    return nil;
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    
//   // self.nomeLabel.text = [view.annotation title];
//  //  self.endereco.text = [[view annotation]subtitle];
//    if ([view.annotation isKindOfClass:[MKUserLocation class]])
//    {
//       // [_rotaBotao setHidden:YES];
//       // [_rota setHidden:YES];
//        
//       // self.telefoneLabel.text = nil;
//     //   self.distanciaLabel.text = nil;
//    }
//    else{
//        
//        self.telefoneLabel.text = [amaMaisProxima telefone];
//        self.distanciaLabel.text = [NSString stringWithFormat:@"%.2f KM", [amaMaisProxima distanciaMapa]];
//    }
//    
//    self.blurViewOutlet.hidden = NO;
//    //view.pinColor = MKPinAnnotationColorGreen;
//    
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[view.annotation coordinate] addressDictionary:nil];
//    
//    
//}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    
    
}


@end
