//
//  xxiivvViewController.h
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xxiivvViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *feedbackView;
@property (strong, nonatomic) IBOutlet UIView *lessonView;
@property (strong, nonatomic) IBOutlet UIView *choicesView;
@property (strong, nonatomic) IBOutlet UIView *optionsView;
@property (strong, nonatomic) IBOutlet UIView *lessonProgressView;
@property (strong, nonatomic) IBOutlet UIImageView *lessonProgressBar;
@property (strong, nonatomic) IBOutlet UIView *optionSelector;

@property (weak, nonatomic) IBOutlet UIScrollView *mainOptionView;
@property (strong, nonatomic) IBOutlet UILabel *lessonEnglishLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessonEnglishCaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessonEnglishAnswerLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *languageSelectionView;

- (IBAction)lessonModeToggle:(id)sender;
- (IBAction)lessonCaseToggle:(id)sender;

@end

CGRect screen;
float screenMargin;
float screenButtonWidth;
float screenButtonHeight;

int userLesson;
int userLessonHiragana;
int userLessonKatakana;

int choiceSolution;

int modeIsCapitalized;
int modeIsLanguage;
