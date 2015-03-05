//
//  PSTableViewCell.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *HEndereco;
@property (weak, nonatomic) IBOutlet UILabel *HNome;
@property (weak, nonatomic) IBOutlet UILabel *HRegiao;
@property (weak, nonatomic) IBOutlet UILabel *HHorario;
@property (weak, nonatomic) IBOutlet UILabel *HTelefone;

@end
