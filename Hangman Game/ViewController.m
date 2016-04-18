//
//  ViewController.m
//  Hangman Game
//
//  Created by Andrew Conrad on 4/14/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)       NSArray                     *wordListArray;
@property (nonatomic, strong)       NSMutableArray              *hangmanWordArray;
@property (nonatomic, weak)         IBOutlet UILabel            *displayHangmanWord;
@property (nonatomic, strong)       NSString                    *theAnswer;
@property (nonatomic, weak)         NSString                    *searchLetter;
@property (nonatomic, weak)         IBOutlet UIImageView        *hangmanImageView;
@property (nonatomic, strong)       NSArray                     *hangmanImageArray;

@end

@implementation ViewController

#pragma mark - Load CSV Into Array and Initialize

//magic code that reads the CSV into the array

- (NSString *)readBundleFileToString:(NSString *)filename ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (NSArray *)convertCSVStringToArray:(NSString *)csvString {
    NSString *cleanString = [[csvString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@","];
    return [cleanString componentsSeparatedByCharactersInSet:set];
}

int triesCounter = 0;

#pragma mark - New Game and Ititial Word called function

//Get the random word from the array, name it _theAnswer

- (void)getNewRandomWord {
    long wordNumber = arc4random_uniform((uint32_t)_wordListArray.count);
    NSString *currentWord = _wordListArray[wordNumber];
    NSLog(@"%@",currentWord);
    _theAnswer = [NSString stringWithFormat:@"%@",currentWord];
    
//Make a mutable array of the word chosen
    
    NSMutableArray *hangmanWordArray = [NSMutableArray array];
    for (int i = 0; i < [currentWord length]; i++) {
        NSString *ch = [currentWord substringWithRange:NSMakeRange(i, 1)];
        [hangmanWordArray addObject:ch];
    }
    
//Create the visual representation of the hangman word
    
    NSString *asteriskWord = @"";
    for (int h = 0; h < [currentWord length]; h++) {
        asteriskWord = [asteriskWord stringByAppendingString:@"*"];
    }
    _displayHangmanWord.text = [NSString stringWithFormat:@"%@",asteriskWord];
    
    //                      NEED TO DO
    //
    //Set hangman picture to blank here, also needs reset of all counters used across game
    
}

#pragma mark - Game Starting and Ended functions

- (void)gameOver {
    for (UIView *view in self.view.subviews) {
        if (view.tag != 99 && [view class] == [UIButton class]) {
            UIButton *button = (UIButton *)view;
            button.userInteractionEnabled = NO;
        }
    }
}

- (void)newGame {
    for (UIView *view in self.view.subviews) {
        if (view.tag != 99 && [view class] == [UIButton class]) {
            UIButton *button = (UIButton *)view;
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
            triesCounter = 0;
        }
    }
}

- (void)gameWon {
    for (UIView *view in self.view.subviews) {
        if (view.tag != 99 && [view class] == [UIButton class]) {
            UIButton *button = (UIButton *)view;
            button.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - Interactivity Methods

//New Game button

- (IBAction)startButtonPressed:(id)sender {
    [self getNewRandomWord];
    [self newGame];
    [_hangmanImageView setImage:[UIImage imageNamed:_hangmanImageArray[triesCounter]]];
    
}

//The actions each letter button takes when pressed

- (IBAction)letterButtonPressed:(UIButton *)button {

    //this for loop happens each time it is pressed
    
    for (int c = 0; c < [_theAnswer length]; c++) {
        
        NSString *revealingWord = _displayHangmanWord.text;
        NSString *searchLetter = [button.titleLabel.text lowercaseString];
        NSString *currentLetter = [_theAnswer substringWithRange:NSMakeRange(c, 1)];
        
        //this loop looks for right answers and acts upon them
        
        if ([searchLetter isEqualToString:currentLetter]) {
            revealingWord = [revealingWord stringByReplacingCharactersInRange:NSMakeRange(c, 1) withString:searchLetter];
            _displayHangmanWord.text = revealingWord;
            [button setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
            button.userInteractionEnabled = NO;

        }
    }
    
    //this loop looks for wrong answers and acts upon them
    
    if (button.currentTitleColor != [UIColor greenColor]) {
        triesCounter ++;
            [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            button.userInteractionEnabled = NO;
        
        [_hangmanImageView setImage:[UIImage imageNamed:_hangmanImageArray[triesCounter]]];
        
        
        
        //this loop checks for game loss condition
        
        if (triesCounter == 9) {
            [self gameOver];
        }
    }
    
    //Win condition
    
    if (_displayHangmanWord.text == _theAnswer) {
        [self gameWon];
        NSLog(@"YOU WON!!!! Click New Game to play again!");
    }

}




#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *wordListString = [self readBundleFileToString:@"6dcc5436-WordSetApple" ofType:@"csv"];
    _wordListArray = [self convertCSVStringToArray:wordListString];
    NSLog(@"%li",_wordListArray.count);
    [self getNewRandomWord];
    
    _hangmanImageArray = @[@"Hangman01", @"Hangman02", @"Hangman03", @"Hangman04", @"Hangman05", @"Hangman06", @"Hangman07", @"Hangman08", @"Hangman09", @"Hangman10"];
    [_hangmanImageView setImage:[UIImage imageNamed:_hangmanImageArray[triesCounter]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
