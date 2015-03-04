//
//  ListaPSTableViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/4/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ListaPSTableViewController.h"


@interface ListaPSTableViewController ()
{
    AMA *PS;
    ListaAMA *ListaPS;
    int indexArrayPlist;
}

@end

@implementation ListaPSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indexArrayPlist = 1;
    
    //Inicializando as variaveis
    PS = [[AMA alloc]init];
    ListaPS = [ListaAMA ItensCompartilhado];
    
    
    //Pegando os valores da Plist
    
    
    
   
    NSString *Hosp;
    
    for (indexArrayPlist =1; indexArrayPlist<4; indexArrayPlist++) {
         NSString* String_indexArrayPlist = [NSString stringWithFormat:@"%i", indexArrayPlist];
        Hosp = [@"Ama" stringByAppendingString: String_indexArrayPlist];
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
             [ListaPS.AllAMA addObject:PS];
             
             
            // NSLog(@"Endereco = %@",[obj valueForKey:@"Endereco"]);
             NSLog(@"%@", PS.endereco);
         }];
        
       // NSLog(@"%@",ListaPS.AllAMA);


    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
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
    //return [ListaPS.AllAMA count];
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
