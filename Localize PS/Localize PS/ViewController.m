//
//  ViewController.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "ViewController.h"
#import "MapaViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSearchViewSegue"]) {
        
        MapaViewController *MapaView = segue.destinationViewController;
        UIButton *btn = sender;
        
        if (![btn.titleLabel.text isEqual: @"I'm Lucky"]) {
            MapaView.searchQuery = (NSMutableArray*) query;
        }
        
    }
}

#pragma mark Category button actions


- (IBAction)mostraMapa:(id)sender {
//    query = @[@"theater"];
//    [self performSegueWithIdentifier:@"showSearchViewSegue" sender:sender];

}


- (IBAction)mostraListaPS:(id)sender {
}




@end