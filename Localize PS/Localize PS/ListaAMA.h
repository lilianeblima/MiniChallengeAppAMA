//
//  ListaAMA.h
//  Localize PS
//
//  Created by Liliane Bezerra Lima on 04/03/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMA.h"

@interface ListaAMA : NSObject

@property NSMutableArray *AllAMA;

-(id) init;
-(void)nomes;
-(AMA*)retorno:(NSNumber*)i;
+ (id)ItensCompartilhado;
- (AMA *) amaForIndex: (NSInteger)index;
-(void)exibirInfo;

@end



