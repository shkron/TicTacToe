//
//  AEGameState.m
//  TicTacToe
//
//  Created by Alex on 7/16/16.
//  Copyright © 2016 AE. All rights reserved.
//

#import "AEGameState.h"

@interface AEGameState () 

@property (nonatomic, strong) NSArray *board;
@property (nonatomic, assign) AEGameResult gameResult;

@end

@implementation AEGameState

-(instancetype)initWithGameBoard:(NSArray *)board
{
    self = [super init];

    if (self)
    {
        self.board = board;
    }

    return self;
}

-(BOOL)isEndOfGame
{
    NSMutableArray *winningCombinations = [NSMutableArray new];

    //horizontal
    [winningCombinations addObject:@[self.board[AEGameCellOne],self.board[AEGameCellTwo],self.board[AEGameCellThree]]];
    [winningCombinations addObject:@[self.board[AEGameCellFour],self.board[AEGameCellFive],self.board[AEGameCellSix]]];
    [winningCombinations addObject:@[self.board[AEGameCellSeven],self.board[AEGameCellEight],self.board[AEGameCellNine]]];

    //vertical
    [winningCombinations addObject:@[self.board[AEGameCellOne],self.board[AEGameCellFour],self.board[AEGameCellSeven]]];
    [winningCombinations addObject:@[self.board[AEGameCellTwo],self.board[AEGameCellFive],self.board[AEGameCellEight]]];
    [winningCombinations addObject:@[self.board[AEGameCellThree],self.board[AEGameCellSix],self.board[AEGameCellNine]]];

    //diagonal
    [winningCombinations addObject:@[self.board[AEGameCellOne],self.board[AEGameCellFive],self.board[AEGameCellNine]]];
    [winningCombinations addObject:@[self.board[AEGameCellThree],self.board[AEGameCellFive],self.board[AEGameCellSeven]]];

    AEGameMove *attackMove;
    AEGameMove *defenceMove;
    for (NSArray *combinationToCheck in winningCombinations) {

        int crosses = 0;
        int noughts = 0;

        AEGameMove *availableMove;
        for (AEGameMove *move in combinationToCheck) {

            switch (move.player) {
                case AEPlayerO:
                    noughts++;
                    break;
                case AEPlayerX:
                    crosses++;
                    break;

                default:
                    availableMove = move;
                    break;
            }


        }

        //win match
        if (noughts == 3) {
            if (self.currentPlayer == AEPlayerO) self.gameResult = AEGameResultWin;
            else self.gameResult = AEGameResultLoss;
            return YES;
        }else if (crosses == 3){
            if (self.currentPlayer == AEPlayerX) self.gameResult = AEGameResultWin;
            else self.gameResult = AEGameResultLoss;
            return YES;
        }

        //pre-win situation
        if (noughts == 2 && crosses == 0) {
            if (self.currentPlayer == AEPlayerO) availableMove.result = AEGameResultWinning;
            else availableMove.result = AEGameResultLoosing;
            attackMove = availableMove;
        }else if (crosses == 2 && noughts == 0){
            if (self.currentPlayer == AEPlayerX) availableMove.result = AEGameResultWinning;
            else availableMove.result = AEGameResultLoosing;
            defenceMove = availableMove;
        }


    }

    if (attackMove)
    {
        self.currentMove = attackMove;
        self.gameResult = attackMove.result;
        return YES;
    }
    else if (defenceMove)
    {
        self.currentMove = defenceMove;
        self.gameResult = defenceMove.result;
        return YES;
    }

    return NO;
}

-(NSArray *)availableMoves
{
    return  [self.board filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"player == 0"]];
}

-(void)successorStateWithMove:(AEGameMove *)move
{
    AEGameMove *boardMove = self.board[move.index];
    boardMove.player = self.currentPlayer;
    self.currentMove = boardMove;

    [self switchPlayer];
}

-(void)switchPlayer
{
    switch (self.currentPlayer) {
        case AEPlayerO:
            self.currentPlayer = AEPlayerX;
            break;
        case AEPlayerX:
            self.currentPlayer = AEPlayerO;
            break;

        default:
            break;
    }
}

-(AEGameResult)evaluateWithPlayer:(AEPlayer)player
{
    if (!([[self availableMoves] count] > 0))
    {
        return self.gameResult = AEGameResultTie;
    }

    if (self.currentPlayer == player) return self.gameResult;
    else return -self.gameResult;
}

//computer logic
- (AEGameResult)alphaBetaWithState:(AEGameState *)state
                            player:(AEPlayer)player
                             depth:(NSInteger)depth
                             alpha:(NSInteger)alpha
                              beta:(NSInteger)beta
{
    if (depth == 0 || [state isEndOfGame]){
         return [state evaluateWithPlayer:player];
    }

    //move to fifth cell if available
    if (depth == 8 && [state.board[AEGameCellFive] player] == AEPlayerNone)
    {
        self.currentMove = state.board[AEGameCellFive];
        return AEGameResultWinning;
    }

    NSArray *moves = [state availableMoves];

    //pre-select odd cells to save calculation time
    if (state.currentMove.index % 2 == 0)
    {
        moves = [moves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"modulus:by:(index, 2) == 0"]];
    }

    for (AEGameMove *move in moves) {

        NSInteger score = -[self alphaBetaWithState:state
                                             player:3 - player  // number 3 needed to switch between players using AEPlayer enum
                                              depth:depth-1
                                              alpha:-beta
                                               beta:-alpha];
        move.player = player;
        self.currentMove = move;
        move.player = AEPlayerNone;

        if (score > alpha){
            alpha = score;
        }

        if (alpha >= beta) {
            break; // prune negative branch.
        }

    }

    return alpha;
}

@end
