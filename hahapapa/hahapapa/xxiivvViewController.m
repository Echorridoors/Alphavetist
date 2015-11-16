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

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

AVAudioPlayer *audioPlayerSounds;

@interface xxiivvViewController(){
	Template *template;
	Lesson *lesson;
}

@end

@implementation xxiivvViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.languageSelectionView.delegate = self;
	self.mainOptionView.delegate = self;
	[self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)start
{
    modeIsLanguage = 0;
	modeIsAnswer = 0;
	modeIsCapitalized = 0;
    
	[self lessonStart];
	[self templateStart];

	[self userStart];
	[self gameStart];
}

# pragma mark Game States -

-(void)gameStart
{
	NSLog(@"- Game | Start");
	[self gameChoicesRemove];
	[self gamePrepare];
}

-(void)gamePrepare {
	
	NSLog(@"- Game | Prepare");
	
	[self gameChoicesGenerate];
	[self gameReady];
	
}

-(void)gameReady
{
	self.lessonEnglishLabel.text = [gameLessonsArray[userLesson][0] uppercaseString];
	self.lessonEnglishCaseLabel.text = gameLessonsArray[userLesson][0];
	self.lessonEnglishAnswerLabel.text = [NSString stringWithFormat:@"%@*",[gameLessonsArray[userLesson][0] uppercaseString] ];
	self.lessonEnglishCaseAnswerLabel.text = [NSString stringWithFormat:@"%@*",gameLessonsArray[userLesson][0] ];
	
	NSLog(@"- Game | Ready");
	
	[self templateReadyAnimate];
}

# pragma mark Choices -

-(void)gameChoicesGenerate {
	
	for (UIView *subview in [self.choicesView subviews]) {
		[subview removeFromSuperview];
	}
	
	// Create answer
	
	choiceSolution = (arc4random() % 9)+1;
	NSString *choiceSolutionString = gameLessonsArray[userLesson][modeIsCapitalized+1];
	NSLog(@"> Less | Solution %d %@",choiceSolution, choiceSolutionString);
	
	// Create wrongs
    
    NSArray* choiceWrongString = [self gameChoiceCreate:choiceSolutionString];
    
	for(int i = 1; i < 10; i++){
		UIButton *button = [[UIButton alloc] init];
		[button addTarget:self action:NSSelectorFromString(@"gameChoiceSelected:") forControlEvents:UIControlEventTouchDown];
		button.frame = [template choiceButton:i].frame;
		button.tag = [template choiceButton:i].tag;
		button.titleLabel.font = [template choiceButton:i].titleLabel.font;
		button.contentEdgeInsets = [template choiceButton:i].contentEdgeInsets;
		button.alpha = 0;
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		/* TODO
		if( [self.lessonTypeLabel.text isEqualToString:@"Morse"] ){
			button.titleLabel.adjustsFontSizeToFitWidth = TRUE;
			[button.titleLabel setMinimumScaleFactor:0.5];
			[button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
		}
		*/
		
		[button setTitle: [lesson lessonContent:modeIsLanguage][i][1] forState: UIControlStateNormal];
        if(i == choiceSolution){
            [button setTitle:choiceSolutionString forState:UIControlStateNormal];
			if( modeIsAnswer == 1 ){
				[button setBackgroundColor:[UIColor colorWithRed:0.45 green:0.87 blue:0.76 alpha:1]];
			}
		}
		else{
			[button setTitle:choiceWrongString[i] forState:UIControlStateNormal];
		}
		
		[self.choicesView addSubview:button];
	}
}

-(void)gameChoicesRemove {
	
	NSLog(@"> Game | Choice Remove");
	
	for (UIView *subview in [self.choicesView subviews]) {
		if(subview.tag != 100)
		[subview removeFromSuperview];
	}
}

-(void)gameChoiceCorrect {
	
	NSLog(@"> Game | Choice Correct");
	
	// TO DO
	if( userLesson == [gameLessonsArray count]-1 ){
		[self audioPlayerSounds:@"fx.completed.wav"];
		userLesson = 0;
		if( modeIsCapitalized == 1){
			modeIsCapitalized = 0;
		}
		else{
			modeIsCapitalized = 1;
		}
	}
	else{
		[self audioPlayerSounds:@"fx.click.wav"];
		userLesson += 1;
	}
	
	[self templateChoiceCorrectAnimation];
	
	NSLog(@"> Game | Start Lesson: %d", userLesson);
	
}

-(void)gameChoiceIncorrect
{
	NSLog(@"> Game | Choice Incorrect");
	
	[self audioPlayerSounds:@"fx.error.wav"];
	
	[self templateChoiceIncorrectAnimation];
	
	userLesson -= 6;
    if (userLesson < 0) {
        userLesson = 0;
    }
}


-(NSMutableArray*)gameChoiceCreate :(NSString*)answer
{
    // Limit Array to current lesson
    NSMutableArray *randSequence1 = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSArray *item;
    
    for (item in gameLessonsArray) {
        if( item[modeIsCapitalized+1] != answer ){
            [randSequence1 addObject:item];
        }
    }
    
    [randSequence1 removeObjectIdenticalTo:answer];
    
    for ( long i1 = [randSequence1 count] - 1; i1 > 0; --i1){
        int from = arc4random() % [randSequence1 count];
        int to = arc4random() % [randSequence1 count];
        [randSequence1 exchangeObjectAtIndex:from withObjectAtIndex:to];
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:11];
    
    // Add to return
    for ( uint count = 10; count > 0; --count){
        [returnArray addObject:randSequence1[count][modeIsCapitalized+1]];
    }
    
	return returnArray;
}

-(void)gameChoiceSelected:(UIButton*)sender
{
	int choiceId = (int)((UIView*)sender).tag;
	
	self.optionSelector.frame = CGRectMake([template choiceButton:choiceId].frame.origin.x, [template choiceButton:choiceId].frame.origin.y+(screen.size.height-screen.size.width), [template choiceButton:choiceId].frame.size.width, [template choiceButton:choiceId].frame.size.height);
	self.optionSelector.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	self.optionSelector.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
	[UIView commitAnimations];
    
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
	userLesson = 0;
	modeIsAnswer = 0;
	modeIsCapitalized = 0;
}

# pragma mark Interaction -

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int option = (int)(scrollView.contentOffset.x/screen.size.width);
	
	if( scrollView.tag == 801 ){
		int previousMode = modeIsCapitalized;
		if( option == 0 ){ modeIsCapitalized = 0; modeIsAnswer = 0; }
		if( option == 1 ){ modeIsCapitalized = 1; modeIsAnswer = 0; }
		if( option == 2 ){ modeIsCapitalized = 0; modeIsAnswer = 1; }
		if( option == 3 ){ modeIsCapitalized = 1; modeIsAnswer = 1; }
		if( previousMode != modeIsCapitalized ){
			[self lessonStart];
			[self gameStart];
		}
	}
	if( scrollView.tag == 802 ){
		modeIsLanguage = option;
		[self userStart];
		[self gameStart];
		[self gameStart];
	}
	
	NSLog(@"Option -> %d",option);
	
}

# pragma mark Template -

-(void)templateStart
{
	screen = [[UIScreen mainScreen] bounds];
	screenMargin = screen.size.width/8;
	screenButtonWidth = (screen.size.width - (4*(screenMargin/2)))/3;
	screenButtonHeight = ( (screen.size.height-(screen.size.height/2.5)) - (3*(screenMargin/2)) )/2 - (screenMargin/4);
	
	_optionSelector.frame = CGRectMake(0, 0, 0, 0);
	
	template = [[Template alloc] init];
	
	_lessonView.frame = [template lessonViewFrame];
	_lessonView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	
	_choicesView.frame = CGRectMake(0, screen.size.height-screen.size.width, screen.size.width, screen.size.width);
	
	// Case Selection View
	
	_mainOptionView.frame = CGRectMake(0, 0, screen.size.width, ((screen.size.height - _choicesView.frame.size.height)/3)*2 );
	_mainOptionView.contentSize = CGSizeMake(screen.size.width * 4, _mainOptionView.frame.size.height);
	
	_lessonEnglishLabel.frame = CGRectMake(0, 0, screen.size.width, _mainOptionView.frame.size.height);
	_lessonEnglishCaseLabel.frame = CGRectMake(screen.size.width, 0, screen.size.width, _mainOptionView.frame.size.height);
	_lessonEnglishAnswerLabel.frame = CGRectMake(screen.size.width * 2, 0, screen.size.width, _mainOptionView.frame.size.height);
	_lessonEnglishCaseAnswerLabel.frame = CGRectMake(screen.size.width * 3, 0, screen.size.width, _mainOptionView.frame.size.height);
	
	_feedbackView.frame = _mainOptionView.frame;
	
	// Language Selection View
	
	_languageSelectionView.frame = CGRectMake(0, _mainOptionView.frame.size.height, screen.size.width, ( screen.size.height - _mainOptionView.frame.size.height - _choicesView.frame.size.height ) );
	_languageSelectionView.contentSize = CGSizeMake(screen.size.width * [[lesson lessonsList] count], _languageSelectionView.frame.size.height);
	
	// Progress Bar View
	
	_lessonProgressView.frame = CGRectMake((screen.size.width/2)-(screenMargin*1.5), _mainOptionView.frame.size.height - screenMargin/8, screenMargin*3, 1 );
	_lessonProgressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
	_lessonProgressView.clipsToBounds = YES;
	
	_lessonProgressBar.frame = CGRectMake(0, 0, 1, 1 );
	_lessonProgressBar.backgroundColor = [UIColor whiteColor];
	
	// Generate Languages
	
	for(int i = 0; i < [[lesson lessonsList] count]; i++){
		
		UILabel *languageLabel = [[UILabel alloc] init];
		languageLabel.frame = CGRectMake(i * screen.size.width, 0, screen.size.width, _languageSelectionView.frame.size.height);
		languageLabel.text = [[lesson lessonsList] objectAtIndex:i];
		languageLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16];
		languageLabel.textAlignment = NSTextAlignmentCenter;
		
		[_languageSelectionView addSubview:languageLabel];
	}
}

-(void)templateReadyAnimate {
	
	NSLog(@"> Anim | Ready");
	
	float barMaxLesson = [gameLessonsArray count];
	float barCurrentLesson = userLesson;
	
	self.lessonEnglishLabel.alpha = 0;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	self.lessonEnglishLabel.alpha = 1;
	self.lessonProgressBar.frame = CGRectMake(0, 0, self.lessonProgressView.frame.size.width*(barCurrentLesson/barMaxLesson), 1 );
	[UIView commitAnimations];
	
	// Animate button fade
	int i = 0;
	for (UIView *subview in [self.choicesView subviews] ) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelay:i*0.1];
		[UIView setAnimationDuration:0.];
		subview.alpha = 1;
		[UIView commitAnimations];
		i+=1;
	}
}

-(void)templateChoiceCorrectAnimation
{
	self.feedbackView.backgroundColor = [UIColor whiteColor];
	
	self.feedbackView.alpha = 0.4;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3];
	self.feedbackView.alpha = 0;
	[UIView commitAnimations];
}


-(void)templateChoiceIncorrectAnimation
{
	self.feedbackView.backgroundColor = [UIColor redColor];
	self.feedbackView.alpha = 1;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.6];
	self.feedbackView.alpha = 0;
	[UIView commitAnimations];
}

# pragma mark To clean -

-(void)lessonStart {
	NSLog(@"> Less | Start");
	lesson = [[Lesson alloc] init];
	gameLessonsArray = [lesson lessonContent:modeIsLanguage];
}

-(void)audioPlayerSounds:(NSString *)filename{
	
	NSLog(@"$ Audio | Play %@",filename);
	
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	resourcePath = [resourcePath stringByAppendingString: [NSString stringWithFormat:@"/%@", filename] ];
	NSError* err;
	audioPlayerSounds = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:resourcePath] error:&err];
	
	audioPlayerSounds.volume = 1.0;
	
	audioPlayerSounds.numberOfLoops = 0;
	audioPlayerSounds.currentTime = 0;
	
	if(err)	{ NSLog(@"%@",err); }
	else	{
		[audioPlayerSounds prepareToPlay];
		[audioPlayerSounds play];
	}
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
