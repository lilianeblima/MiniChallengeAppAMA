//
//  ListaPSTableViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaPSTableViewController.h"
#import "PSTableViewCell.h"
#import "ListaAMA.h"


@interface ListaPSTableViewController ()
{
    AMA *ama;
    ListaAMA *listaAma;
    CLLocationCoordinate2D loc;
    NSArray *locali;
    //CLLocationManager *locationManager;
    
    
}

@end

@implementation ListaPSTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //locationManager = [[CLLocationManager alloc]init];
    //Inicializando as variaveis
    ama = [[AMA alloc]init];
    listaAma = [[ListaAMA alloc]init];
    //loc = [[CLLocationCoordinate2D alloc]init];
    
    
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
    
    
    
    
    
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"%@",error.localizedDescription);
    
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Erro" message:@"Falha em localizar sua localização" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}





-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"So Aki");
    //NSLog(@"AKIII%@", [locations lastObject]);
    _armazenar = [locations lastObject];
    //NSLog(@"EITA%@",[self.locationManager.location].coordinate]);
    
    //[self.locationManager.location];
    //[self.locationManager.location.coordinate];
    
    [_locationManager stopUpdatingLocation];
    
    
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = _armazenar;
    
    
    
    if (currentLocation != nil) {
        
        
        
        //  latiduteUM = [currentLocation.coordinate.latitude];
        // longitudeUM = [currentLocation.coordinate.longitude];
        
        
        NSString *lo = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
        
        NSString *lat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        // NSLog(@"Lat= %@",lat);
        //  NSLog(@"Lo= %@", lo);
    }
    
}

-(double)CalculoDistancia :(double)LatitudeUm :(double)LatitudeDois :(double)LongitudeUm :(double)LongitudeDois
{
    
    double distancia;
    double Pi = 3.1415926536;
    
    distancia = ((acos(cos((90 - LatitudeUm)* Pi/180)*cos((90 - LatitudeDois) * Pi/180)+ sin((90 - LatitudeUm)* Pi/180)*sin((90 - LatitudeDois)* Pi/180) * cos(ABS(((360 + LongitudeUm)* Pi/180) - ((360 + LongitudeDois)* Pi/180)))))*6371.004) * 1000;
    
    return distancia;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [listaAma.AllAMA count];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSTableCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[PSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PSTableCell"];
    }
    
    double dist;
    
    double latdouble = [ama.latitude doubleValue];
    double lotdouble = [ama.longitude doubleValue];
    
        NSLog(@"LongD=%f",lotdouble);
        NSLog(@"LatD=%f",latdouble);
    
        NSLog(@"LatS%@",ama.latitude);
        NSLog(@"LonS%@",ama.longitude);
    
    dist = [self CalculoDistancia:-23.545791 :latdouble :-46.65215 :lotdouble];
    
    
    // ama = [retorno:indexPath.row];
    ama = [listaAma.AllAMA objectAtIndex:indexPath.row];
    
    //  [ama setDistancia:[NSNumber numberWithDouble:[self.CalculoDistancia :_LatitudeUm :-23.5328287 :_LongitudeUm :-46.6666176]]];
    
    [ama setDistancia:[NSNumber numberWithDouble:dist]];
    
    
    
    cell.HNome.text = ama.nome;
    cell.HTelefone.text = ama.telefone;
    cell.HEndereco.text = ama.endereco;
    cell.HRegiao.text = ama.regiao;
    //cell.HHorario.text = ama.is24hrs;
    cell.HHorario.text = [NSString stringWithFormat:@"%@", ama.distancia ];
    //
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    long row1 = [fromIndexPath row];
    
    long row2 = [toIndexPath row];
    
    
    
    id temp = [listaAma.AllAMA objectAtIndex:row1];
    
    [listaAma.AllAMA removeObjectAtIndex:row1];
    
    [listaAma.AllAMA insertObject:temp atIndex:(row2)];
    
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
