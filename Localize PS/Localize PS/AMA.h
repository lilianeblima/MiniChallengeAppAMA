//
//  AMA.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMA : NSObject
{
    NSString *nome;
    NSString *endereco;
    NSString *regiao;
    NSString *latitude;
    NSString *longitude;
    NSString *Hfuncionamento;
    NSString *telefone;
  
}

@property NSString *nome;
@property NSString *endereco;
@property NSString *regiao;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *Hfuncionamento;
@property NSString *telefone;

- (id) init;



@end
