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
    NSNumber *latitude;
    NSNumber *longitude;
    Boolean Hfuncionamento;
    NSString *telefone;
  
}

@property NSString *nome;
@property NSString *endereco;
@property NSString *regiao;
@property NSNumber *latitude;
@property NSNumber *longitude;
@property Boolean Hfuncionamento;
@property NSString *telefone;

- (id) init;
- (void) Hosp:(NSString *)n : (NSString *)e : (NSString *)r : (NSNumber *)lat : (NSNumber *)lon : (Boolean)f : (NSString *)t;


@end
