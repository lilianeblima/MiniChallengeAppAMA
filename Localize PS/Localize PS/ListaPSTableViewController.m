//
//  ListaPSTableViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaPSTableViewController.h"
#import "PSTableViewCell.h"


@interface ListaPSTableViewController ()
{
    AMA *PS, *auxiliar;
    ListaAMA *ListaPS;
    int i;
    NSMutableArray *teste;
}

@end

@implementation ListaPSTableViewController
@synthesize Lista;

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 1;
    
    //Inicializando as variaveis
    PS = [[AMA alloc]init];
    ListaPS = [ListaAMA ItensCompartilhado];
    teste = [[NSMutableArray alloc]init];
    
   Lista = [[NSMutableArray alloc] initWithCapacity:200];

    
    
    
    
    
    
   
    NSString *Hosp;
    
    for (i =1; i<4; i++)
    {
  //Bloco para pegar os dados da Plist
         NSString* String_i = [NSString stringWithFormat:@"%i", i];
        Hosp = [@"Ama" stringByAppendingString: String_i];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PS" ofType:@"plist"];
        NSDictionary *dicRoot = [NSDictionary dictionaryWithContentsOfFile:filePath ];
        NSArray *arrayList = [NSArray arrayWithArray:[dicRoot objectForKey:Hosp]];
        [arrayList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             
             [PS setNome:[obj valueForKey:@"Nome"]];
             [PS setEndereco:[obj valueForKey:@"Endereco"]];
             [PS setRegiao:[obj valueForKey:@"Regiao"]];
             [PS setHfuncionamento:[obj valueForKey:@"24hrs?"]];
             [PS setTelefone:[obj valueForKey:@"Telefone"]];
             
             NSLog(@"Endereco = %@",[obj valueForKey:@"Endereco"]);
             
             [ListaPS.AllAMA addObject:PS];
            // [Lista addObject:PS];
         }];
    }
        
        //[ListaPS.AllAMA addObject:PS];
        //  [teste insertObject:PS atIndex:indexArrayPlist];
        
        
        //[ListaPS.AllAMA insertObject:PS atIndex:indexArrayPlist];
        // [brokenCars insertObject:@"BMW F25" atIndex:0];
      //  [Lista addObject:PS];
       // [ListaPS.AllAMA addObject:PS];
      
       // NSLog(@"%@",ListaPS.AllAMA);
        


   

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //NSLog(@"DEBUG");
    //[ListaPS exibirInfo];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [ListaPS.AllAMA count];
    //return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSTableCell" forIndexPath:indexPath];
//    
//    if (cell == nil) {
//        cell = [[PSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PSTableCell"];
//    }
    
//
    
   // auxiliar = [Lista indexOfObject:indexPath.row];
    auxiliar = [ListaPS itenForIndex:indexPath.row];
    
    [[cell HEndereco] setText:auxiliar.endereco];
    
    auxiliar = nil;
    
    
    
//indexPath.row
//    
//    [[cell HEndereco] setText:ListaPS.AllAMA.Endereco];
//    
//    //auxiliar = [ListaPS itenForIndex:indexPath.row];
//    
    
    
    
    
    
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    PSTableViewCell *cell; = (PSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    
//    cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
//    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
//    cell.prepTimeLabel.text = [prepTime objectAtIndex:indexPath.row];
    
    
    
//    
//    
//    cell.textLabel.text = auxiliar.endereco;
//    //cell
//    
//   //cell.textLabel.H
//   // cell.textLabel.text = auxiliar.HEndereco;
//    
//   // cell.detailTextLabel.text = auxiliar.detalhe;
//    
//    auxiliar = nil;
//
//    
//    return cell;
    
    
    
    
    
    
    
    // Configure the cell...
    
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
    
    
    
    id temp = [ListaPS.AllAMA objectAtIndex:row1];
    
    [ListaPS.AllAMA removeObjectAtIndex:row1];
    
    [ListaPS.AllAMA insertObject:temp atIndex:(row2)];
    
    [ListaPS exibirInfo];
    
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
