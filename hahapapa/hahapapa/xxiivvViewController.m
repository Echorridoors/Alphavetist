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

-(void)start
{
    modeIsLanguage = 0;
    
	[self lessonStart];
	[self templateStart];

	[self userStart];
	[self userLoad];
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

-(void)gameReady
{
    NSLog(@"%d",modeIsCapitalized);
    
    if( modeIsCapitalized == 1 ){
        self.lessonEnglishLabel.text = [gameLessonsArray[userLesson][0] capitalizedString];
    }
    else{
        self.lessonEnglishLabel.text = gameLessonsArray[userLesson][0];
    }
    
    self.lessonTypeLabel.text = [[lesson lessonsList] objectAtIndex:modeIsLanguage];
	
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
	
	NSArray* choiceWrongString = [self gameChoiceCreate];
	
	for(int i = 1; i < 10; i++){
		UIButton *button = [[UIButton alloc] init];
		[button addTarget:self action:NSSelectorFromString(@"gameChoiceSelected:") forControlEvents:UIControlEventTouchDown];
		button.frame = [template choiceButton:i].frame;
		button.tag = [template choiceButton:i].tag;
		button.titleLabel.font = [template choiceButton:i].titleLabel.font;
		button.contentEdgeInsets = [template choiceButton:i].contentEdgeInsets;
		button.alpha = 0;
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		[button setTitle: [lesson lessonContent:modeIsLanguage][i][1] forState: UIControlStateNormal];
		if(i == choiceSolution){
			[button setTitle:choiceSolutionString forState:UIControlStateNormal];
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
	if( userLesson > 69 ){
		[self audioPlayerSounds:@"fx.completed.wav"];
		userLessonComplete += 1;
		userLesson = 0;
		if( modeIsCapitalized == 1){
			modeIsCapitalized = 2;
		}
		else{
			modeIsCapitalized = 1;
		}
	}
	else{
		[self audioPlayerSounds:@"fx.click.wav"];
		userLesson += 1;
	}
	
	[self userSave];
	
	[self templateChoiceCorrectAnimation];
	
	NSLog(@"> Game | Start Lesson: %d", userLesson);
	
}

-(void)gameChoiceIncorrect {
	
	NSLog(@"> Game | Choice Incorrect");
	
	[self audioPlayerSounds:@"fx.error.wav"];
	
	
	[self templateChoiceIncorrectAnimation];
	
	userLesson -= 6;
	userLesson = abs(userLesson);
	
}


-(NSMutableArray*)gameChoiceCreate {
	
	NSMutableArray *randSequence = [[NSMutableArray alloc] initWithCapacity:11];
	
	int choiceFiller = 0;
	
	if( userLesson < 11 ){
		choiceFiller = 15;
	}
	
	for (int ii = 1; ii < userLesson+choiceFiller; ++ii){
		[randSequence addObject:[NSNumber numberWithInt:ii]];
	}
	for (int ii = [randSequence count]-1; ii > 0; --ii){
		int r = arc4random() % (ii + 1);
		[randSequence exchangeObjectAtIndex:ii withObjectAtIndex:r];
	}
	
	NSMutableArray *choiceWrongString = [[NSMutableArray alloc] initWithCapacity:11];
	int mod = 0;
	for (NSString* key in randSequence) {
		int k = [key intValue] + mod;
		if( k == userLesson ){
			mod = 1;
			k += 1;
		}
		if( k > [gameLessonsArray count]){ k = 10; }
		[choiceWrongString addObject:gameLessonsArray[k][modeIsCapitalized+1]];
	}
	return choiceWrongString;
}


-(UIColor*)gameChoiceColour:(NSString*)letter {
	
	for (NSArray* key in gameLessonsArray) {
		if(![letter isEqual:key[1]] && ![letter isEqual:key[2]]){
			continue;
		}
		
		NSString *completeTarget = key[0];
		NSString *suffixTarget = [completeTarget substringFromIndex: [completeTarget length] - 1];
		NSString *prefixTarget = [completeTarget substringToIndex: 1];
		
		NSString *completeCurrent = gameLessonsArray[userLesson][0];
		NSString *suffixCurrent = [completeCurrent substringFromIndex: [completeCurrent length] - 1];
		NSString *prefixCurrent = [completeCurrent substringToIndex: 1];
		
		if(userLessonComplete < 1){
			if( [suffixTarget isEqual:suffixCurrent] && [prefixTarget isEqual:prefixCurrent] ){
				return [UIColor colorWithRed:0 green:0.737 blue:0.556 alpha:1];
			}
			if( [prefixTarget isEqual:prefixCurrent] ){
				return [UIColor colorWithRed:0 green:0.737 blue:0.556 alpha:1];
			}
			if( [suffixTarget isEqual:suffixCurrent] ){
				return [UIColor colorWithRed:0 green:0.737 blue:0.556 alpha:1];
			}
		}
		
	}
	return [UIColor colorWithRed:0.194 green:0.233 blue:0.276 alpha:1];
}


-(void)gameChoiceSelected:(id)sender {
	
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
	modeIsCapitalized = 1;
	userLessonComplete = 0;
}

# pragma mark Animation -

-(void)templateReadyAnimate {
	
	NSLog(@"> Anim | Ready");
	
	float barMaxLesson = [gameLessonsArray count];
	float barCurrentLesson = userLesson;
	
	self.lessonEnglishLabel.alpha = 0;
    
    self.lessonTypeLabel.frame = CGRectMake(0, self.lessonProgressView.frame.origin.y-10, screen.size.width, screen.size.width/3/2);
    self.lessonTypeLabel.alpha = 0;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	self.lessonEnglishLabel.alpha = 1;
    self.lessonProgressBar.frame = CGRectMake(0, 0, (self.lessonProgressView.frame.size.width)*(barCurrentLesson/barMaxLesson), 1 );
    self.lessonTypeLabel.frame = CGRectMake(0, self.lessonProgressView.frame.origin.y+1, screen.size.width, screen.size.width/3/2);
    self.lessonTypeLabel.alpha = 1;
	[UIView commitAnimations];
	
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

-(void)templateStart {
	
	screen = [[UIScreen mainScreen] bounds];
	screenMargin = screen.size.width/8;
	screenButtonWidth = (screen.size.width - (4*(screenMargin/2)))/3;
	screenButtonHeight = ( (screen.size.height-(screen.size.height/2.5)) - (3*(screenMargin/2)) )/2 - (screenMargin/4);
	
	self.optionSelector.frame = CGRectMake(0, 0, 0, 0);
	
	template = [[Template alloc] init];
	
	self.lessonView.frame = [template lessonViewFrame];
	self.lessonView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	
	self.lessonEnglishLabel.frame = CGRectMake(0, ((screen.size.height-screen.size.width)/2)-50, screen.size.width, 100);
	self.lessonEnglishLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
	self.lessonEnglishLabel.text = @"na";
	
	self.choicesView.frame = CGRectMake(0, screen.size.height-screen.size.width, screen.size.width, screen.size.width);
	
	self.lessonProgressView.frame = CGRectMake(screen.size.width/3, ((screen.size.height-screen.size.width)/2)+50, screen.size.width/3, 1);
	self.lessonProgressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
	
	self.lessonProgressBar.frame = CGRectMake(0, 0, 0, 1 );
	self.lessonProgressBar.backgroundColor = [UIColor whiteColor];
	
	self.lessonTypeLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
	self.lessonTypeLabel.frame = CGRectMake(0, self.lessonProgressView.frame.origin.y+1, screen.size.width, screen.size.width/3/2);
	
    self.lessonModeToggle.frame = CGRectMake(0, self.lessonProgressView.frame.origin.y, screen.size.width, screen.size.width/3/2);
    
    self.lessonCaseToggle.frame = CGRectMake(0, self.lessonProgressView.frame.origin.y - (screen.size.width/3), screen.size.width, screen.size.width/3);
    
	self.feedbackView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height-screen.size.width);
}

- (IBAction)lessonModeToggle:(id)sender
{
	NSLog(@"> Mode | Language Toggle");
    
    modeIsCapitalized = 0;
    userLesson = 0;
    modeIsLanguage = modeIsLanguage + 1;
    
    if( modeIsLanguage == [[lesson lessonsList] count] ){
        modeIsLanguage = 0;
    }
    
    [self gameStart];
    [self gameStart];
}

- (IBAction)lessonCaseToggle:(id)sender
{
    NSLog(@"> Mode | Toggle Case");
    
    if( modeIsCapitalized == 1 ){
        modeIsCapitalized = 0;
    }
    else{
        modeIsCapitalized = 1;
    }
    
    [self gameStart];
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



-(void)userLoad{
	
	if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLesson"] intValue] > 0 ){
		
		NSLog(@"= User  | Loading..");
		
		userLessonComplete	= [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLessonComplete"] intValue];
		userLesson	= [[[NSUserDefaults standardUserDefaults] objectForKey:@"userLesson"] intValue];
		
		NSLog(@"= User  | Loaded.");
	}
}

-(void)userSave{
	
	NSLog(@"= User  | Saving..");
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userLessonComplete] forKey:@"userLessonComplete"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userLesson] forKey:@"userLesson"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSLog(@"= User  | Saved.");
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
