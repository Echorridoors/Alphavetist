//
//  xxiivvViewController.m
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvViewController.h"
#import "xxiivvTemplates.h"
#import "xxiivvLessons.h"
#import <QuartzCore/QuartzCore.h>

@interface xxiivvViewController (){
	Template *template;
	Lesson *lesson;
}

@end


@implementation xxiivvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)start {
	[self lessonStart];
	[self templateStart];

	[self userStart];
	[self gameStart];
}

# pragma mark Game States -

-(void)gameStart {
	
	NSLog(@"- Game | Start");
	
	[self gameChoicesRemove];
	[self gamePrepare];
}

-(void)gamePrepare {
	
	NSLog(@"- Game | Prepare");
	
	[self gameChoicesGenerate];
	[self gameReady];
	
}

-(void)gameReady {
	
	self.lessonEnglishLabel.text = gameLessonsArray[userLesson][0];
	
	NSLog(@"- Game | Ready");
	
	[self templateReadyAnimate];
	
}

-(void)gamePlay {
	NSLog(@"- Game | Play");
	
}

-(void)gameFinished {
	NSLog(@"> Game | Finished");
	
}

# pragma mark Choices -

-(void)gameChoicesGenerate
{
	
	for (UIView *subview in [self.choicesView subviews]) {
		[subview removeFromSuperview];
	}
	
	// Create answer
	choiceSolution = (arc4random() % 6);
	NSString *choiceSolutionString = gameLessonsArray[userLesson][1];
	NSLog(@"> Less | Solution %d %@",choiceSolution, choiceSolutionString);
	
	// Create wrongs
	NSArray* choiceWrongString = [self gameChoiceCreate];
	
	
	for(int i = 0; i < 6; i++){
		UIButton *button = [[UIButton alloc] init];
		[button addTarget:self action:NSSelectorFromString(@"gameChoiceSelected:") forControlEvents:UIControlEventTouchDown];
		button.frame = [template choiceButton:i].frame;
		button.tag = [template choiceButton:i].tag;
		button.titleLabel.font = [template choiceButton:i].titleLabel.font;
		button.titleLabel.textColor = [template choiceButton:i].titleLabel.textColor;
		button.contentEdgeInsets = [template choiceButton:i].contentEdgeInsets;
		button.alpha = 0;
		[button.layer addSublayer:[template bottomBorder]];
		[button setTitle: [lesson lessonContent][i][1] forState: UIControlStateNormal];
		if(i == choiceSolution){
			[button setTitle:choiceSolutionString forState:UIControlStateNormal];
		}
		else{
			[button setTitle:choiceWrongString[i] forState:UIControlStateNormal];
		}
		
		
		[button setBackgroundColor:[self gameChoiceColour:button.titleLabel.text]];
		
		[self.choicesView addSubview:button];
	}
}

-(void)gameChoicesRemove {
	NSLog(@"> Game | Choice Remove");
	
	for (UIView *subview in [self.choicesView subviews]) {
		[subview removeFromSuperview];
	}
}

-(void)gameChoiceCorrect {
	NSLog(@"> Game | Choice Correct");
	userLesson += 1;
	NSLog(@"> Game | Start Lesson: %d", userLesson);
	
}

-(void)gameChoiceIncorrect {
	NSLog(@"> Game | Choice Incorrect");
	userLesson = 0;
	
}


-(NSMutableArray*)gameChoiceCreate {
	NSMutableArray *randSequence = [[NSMutableArray alloc] initWithCapacity:6];
	for (int ii = 1; ii < userLesson+10; ++ii){
		[randSequence addObject:[NSNumber numberWithInt:ii]];
	}
	for (int ii = 7; ii > 0; --ii){
		int r = arc4random() % (ii + 1);
		[randSequence exchangeObjectAtIndex:ii withObjectAtIndex:r];
	}
	NSMutableArray *choiceWrongString = [[NSMutableArray alloc] initWithCapacity:6];
	int mod = 0;
	for (NSString* key in randSequence) {
		int k = [key intValue] + mod;
		if( k == userLesson ){
			mod = 1;
			k += 1;
		}
		[choiceWrongString addObject:gameLessonsArray[k][1]];
	}
	return choiceWrongString;
}


-(UIColor*)gameChoiceColour:(NSString*)letter {

	NSLog(@"LETTER %@",letter);
	
	for (NSArray* key in gameLessonsArray) {
		if(![letter isEqual:key[1]]){
			continue;
		}
		
		if( [key[0] isEqual:@"ka"] ){
			return [UIColor blueColor];
		}
		
		
	}
	
	return [UIColor redColor];
}


-(void)gameChoiceSelected:(id)sender {
	
	int choiceId = ((UIView*)sender).tag;
	
	if(choiceId == choiceSolution){
		[self gameChoiceCorrect];	
	}
	else{
		[self gameChoiceIncorrect];
	}
	
	[self gameStart];
	
}

# pragma mark User -


-(void)userStart {
	NSLog(@"> User | Created");
	userLesson = 1;
	userLessonMode = 1;
}


# pragma mark Animation -

-(void)templateReadyAnimate {
	NSLog(@"> Anim | Ready");
	
	float barMaxLesson = [gameLessonsArray count];
	float barCurrentLesson = userLesson;
	
	self.lessonEnglishLabel.frame = CGRectMake(0, screenMargin, screen.size.width, screen.size.height/6);
	self.lessonEnglishLabel.alpha = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	self.lessonEnglishLabel.frame = CGRectMake(0, screenMargin, screen.size.width, screen.size.height/6);
	self.lessonEnglishLabel.alpha = 1;
	self.lessonProgressBar.frame = CGRectMake(3, 3, (screenButtonWidth-6)*(barCurrentLesson/barMaxLesson), (screenMargin/2) -6 );
	[UIView commitAnimations];
	
	NSLog(@"Progress %f", (screenButtonWidth-6)*(barCurrentLesson/barMaxLesson) );
	
	// Animate button fade
	int i = 0;
	for (UIView *subview in [self.choicesView subviews] ) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelay:i*0.1];
		[UIView setAnimationDuration:0.3];
		subview.alpha = 1;
		[UIView commitAnimations];
		i+=1;
	}
	
	
	
}



# pragma mark To clean -



-(void)lessonStart {
	NSLog(@"> Less | Start");
	lesson = [[Lesson alloc] init];
	gameLessonsArray = [lesson lessonContent];
}

-(void)templateStart {
	
	screen = [[UIScreen mainScreen] bounds];
	screenMargin = screen.size.width/8;
	screenButtonWidth = (screen.size.width - (4*(screenMargin/2)))/3;
	screenButtonHeight = ( (screen.size.height-(screen.size.height/2.5)) - (3*(screenMargin/2)) )/2 - (screenMargin/4);
	
	template = [[Template alloc] init];
	
	self.lessonView.frame = [template lessonViewFrame];
	self.lessonView.backgroundColor = [UIColor blackColor];
	
	self.lessonEnglishLabel.font = [template fontBig];
	self.lessonEnglishLabel.frame = CGRectMake(0, screenMargin, screen.size.width, screen.size.height/6);
	self.lessonEnglishLabel.textColor = [UIColor whiteColor];
	self.lessonEnglishLabel.text = @"na";
	
	self.lessonProgressView.frame = CGRectMake(screenMargin+screenButtonWidth, screenMargin*3, screenButtonWidth, screenMargin/2);
	self.lessonProgressView.backgroundColor = [UIColor whiteColor];
	
	self.lessonProgressBar.frame = CGRectMake(3, 3, screenButtonWidth-6, (screenMargin/2) -6 );
	self.lessonProgressBar.backgroundColor = [UIColor blackColor];
	
	self.lessonTypeLabel.textColor = [UIColor whiteColor];
	self.lessonTypeLabel.frame = CGRectMake(0, 0, screen.size.width, screenMargin*8);
	self.lessonTypeLabel.text = @"ひらがな";
	self.lessonTypeLabel = [template test2];
	
	self.choicesView.frame = [template choicesViewFrame];
	self.choicesView.backgroundColor = [UIColor blackColor];
	
}

@end
