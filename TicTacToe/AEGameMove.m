//
//  AEGameMove.m
//  TicTacToe
//
//  Created by Alex on 7/16/16.
//  Copyright © 2016 AE. All rights reserved.
//

#import "AEGameMove.h"

@implementation AEGameMove

-(id)copyWithZone:(NSZone *)zone
{
    AEGameMove *copy = [[AEGameMove allocWithZone:zone] init];

    copy.index = self.index;
    copy.player = self.player;
    copy.result = self.result;

    return copy;
}

-(instancetype)initWithIndex:(AEGameCell)index forPlayer:(AEPlayer)player
{
    self = [super init];

    if (self)
    {
        self.index = index;
        self.player = player;
    }

    return self;
}

@end
