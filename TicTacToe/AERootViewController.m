//
//  ViewController.m
//  TicTacToe
//
//  Created by Alex on 7/14/16.
//  Copyright © 2016 AE. All rights reserved.
//

#import "AERootViewController.h"
#import "AEGameState.h"

@interface AERootViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;
@property (weak, nonatomic) IBOutlet UIImageView *imageView8;
@property (weak, nonatomic) IBOutlet UIImageView *imageView9;

@property (nonatomic, strong) AEGameState *currentGameState;
@property (nonatomic, assign) BOOL isGameOver;


@end

@implementation AERootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetGame];
}

-(void)resetGame
{
    NSMutableArray *board = [NSMutableArray arrayWithCapacity:9];
    for (NSInteger i=0; i<9;i++)
    {
        [self updateBoardCell:i forPlayer:AEPlayerNone];

        AEGameMove *initialMove = [[AEGameMove alloc] initWithIndex:i forPlayer:AEPlayerNone];
        [board addObject:initialMove];
    }

    self.currentGameState = [[AEGameState alloc] initWithGameBoard:board];
    self.currentGameState.currentPlayer = AEPlayerX; //user plays first
    self.isGameOver = NO;
}

- (IBAction)onResetGameButtonPressed:(UIBarButtonItem *)sender {
    [self resetGame];
}

- (IBAction)onCellTapped:(UITapGestureRecognizer *)sender {

    [self updateBoardCell:sender.view.tag forPlayer:self.currentGameState.currentPlayer];

    if (self.isGameOver) return; //terminating is game ended


//    [self.currentGameState alphaBetaWithState:self.currentGameState player:self.currentGameState.currentPlayer depth:[[self.currentGameState availableMoves] count] alpha:AEGameResultLoss beta:AEGameResultWin];
    [self.currentGameState asyncLogicWithCallback:^(AEGameResult result) {
        [self updateBoardCell:self.currentGameState.currentMove.index forPlayer:self.currentGameState.currentPlayer];
    }];
    

//    [self updateBoardCell:self.currentGameState.currentMove.index forPlayer:self.currentGameState.currentPlayer];

}

-(void)showGameResult:(AEGameResult)gameResult
{
    if (self.currentGameState.currentPlayer == AEPlayerO) {
        gameResult = -gameResult;
    }


    switch (gameResult) {
        case AEGameResultLoss:
        {
            self.isGameOver = YES;
            [self resultAlertWithTitle:@"You Lost" andMessage:@"Try again?"];
        }
            break;
        case AEGameResultTie:
        {
            self.isGameOver = YES;
            [self resultAlertWithTitle:@"Game tied" andMessage:@"Try again?"];
        }
            break;
        case AEGameResultWin:
        {
            self.isGameOver = YES;
            [self resultAlertWithTitle:@"Game Won" andMessage:@"Shouldn't have happened :D"];
        }
            break;

        default:
            break;
    }
}

-(void)updateBoardCell:(AEGameCell)cell forPlayer:(AEPlayer)player
{
    UIImageView *currentImageView;

    switch (cell) {
        case AEGameCellOne:
            currentImageView = self.imageView1;
            break;
        case AEGameCellTwo:
            currentImageView = self.imageView2;
            break;
        case AEGameCellThree:
            currentImageView = self.imageView3;
            break;
        case AEGameCellFour:
            currentImageView = self.imageView4;
            break;
        case AEGameCellFive:
            currentImageView = self.imageView5;
            break;
        case AEGameCellSix:
            currentImageView = self.imageView6;
            break;
        case AEGameCellSeven:
            currentImageView = self.imageView7;
            break;
        case AEGameCellEight:
            currentImageView = self.imageView8;
            break;
        case AEGameCellNine:
            currentImageView = self.imageView9;
            break;

        default:
            break;
    }


    currentImageView.image = [self getImageForPlayer:player];
    currentImageView.userInteractionEnabled = player == AEPlayerNone;

    if (player > AEPlayerNone){

        AEGameMove *moveToApply = [[AEGameMove alloc] initWithIndex:cell forPlayer:player];
        [self.currentGameState successorStateWithMove:moveToApply];

        NSInteger depth = [[self.currentGameState availableMoves] count];
        if (depth == 0 || [self.currentGameState isEndOfGame]){
            [self showGameResult:[self.currentGameState evaluateWithPlayer:self.currentGameState.currentPlayer]];

        }
    }
}

- (UIImage *)getImageForPlayer:(AEPlayer)player
{
    switch (player) {
        case AEPlayerO:
            return [UIImage imageNamed:@"O"];
            break;
        case AEPlayerX:
            return [UIImage imageNamed:@"X"];
            break;

        default:
            return nil;
            break;
    }
}

- (void)resultAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(title,nil)
                                                                   message:NSLocalizedString(message,nil)
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Try again",nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self resetGame];
                                                   }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
