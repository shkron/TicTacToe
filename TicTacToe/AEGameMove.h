//
//  AEGameMove.h
//  TicTacToe
//
//  Created by Alex on 7/16/16.
//  Copyright © 2016 AE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AEPlayer) {
    AEPlayerNone = 0,
    AEPlayerO,
    AEPlayerX
};

typedef NS_ENUM(NSInteger, AEGameResult) {
    AEGameResultLoss = -2,
    AEGameResultLoosing,
    AEGameResultTie,
    AEGameResultWinning,
    AEGameResultWin
};

typedef NS_ENUM(NSInteger, AEGameCell) {
    AEGameCellOne = 0,
    AEGameCellTwo,
    AEGameCellThree,
    AEGameCellFour,
    AEGameCellFive,
    AEGameCellSix,
    AEGameCellSeven,
    AEGameCellEight,
    AEGameCellNine
};

@interface AEGameMove : NSObject

@property (nonatomic, assign) AEGameCell index;
@property (nonatomic, assign) AEPlayer player;
@property (nonatomic, assign) AEGameResult result;




-(id) copyWithZone: (NSZone *) zone;
-(instancetype)initWithIndex:(AEGameCell)index forPlayer:(AEPlayer)player;

@end
