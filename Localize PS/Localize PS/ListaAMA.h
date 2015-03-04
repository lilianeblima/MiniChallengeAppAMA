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
{
    NSMutableArray *AllAMA;
}

@property NSMutableArray *AllAMA;

-(id) init;
+ (id)ItensCompartilhado;
- (AMA *) itenForIndex: (NSInteger)index;
- (void) removeItem : (NSInteger)index;
-(void)exibirInfo;


@end



