//
//  PSTableViewCell.m
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "PSTableViewCell.h"

@implementation PSTableViewCell

@synthesize HNome;
@synthesize HEndereco;
@synthesize HRegiao;
@synthesize HHorario;
@synthesize HTelefone;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
