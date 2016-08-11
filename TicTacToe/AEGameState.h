//
//  AEGameState.h
//  TicTacToe
//
//  Created by Alex on 7/16/16.
//  Copyright © 2016 AE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEGameMove.h"

@interface AEGameState : NSObject

@property (nonatomic, assign) AEPlayer currentPlayer;
@property (nonatomic, copy) AEGameMove *currentMove;

-(instancetype)initWithGameBoard:(NSArray *)board;
-(BOOL)isEndOfGame;
-(NSArray *)availableMoves;
-(void)successorStateWithMove:(AEGameMove *)move;
-(AEGameResult)evaluateWithPlayer:(AEPlayer)player;

- (AEGameResult)alphaBetaWithState:(AEGameState *)state
                            player:(AEPlayer)player
                             depth:(NSInteger)depth
                             alpha:(NSInteger)alpha
                              beta:(NSInteger)beta;

-(void)asyncLogicWithCallback:(void(^)(AEGameResult result))callback;

@end
