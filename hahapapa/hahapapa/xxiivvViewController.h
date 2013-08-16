//
//  xxiivvViewController.h
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xxiivvViewController : UIViewController

	@property (strong, nonatomic) IBOutlet UIView *lessonView;
	@property (strong, nonatomic) IBOutlet UIView *choicesView;
	@property (strong, nonatomic) IBOutlet UIView *optionsView;
	@property (strong, nonatomic) IBOutlet UIView *lessonProgressView;
	@property (strong, nonatomic) IBOutlet UIImageView *lessonProgressBar;
	@property (strong, nonatomic) IBOutlet UILabel *lessonEnglishLabel;
	@property (strong, nonatomic) IBOutlet UILabel *lessonTypeLabel;
	@property (strong, nonatomic) IBOutlet UIButton *lessonModeToggle;
	- (IBAction)lessonModeToggle:(id)sender;

@end

CGRect screen;
float screenMargin;
float screenButtonWidth;
float screenButtonHeight;

int userLesson;
int userLessonMode;
int userLessonHiragana;
int userLessonKatakana;

int choiceSolution;