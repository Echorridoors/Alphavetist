//
//  xxiivvViewController.m
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvViewController.h"
#import "xxiivvTemplates.h"
#import <QuartzCore/QuartzCore.h>

@interface xxiivvViewController (){
	Template *template;
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
	[self templateStart];
	[self generateButtons];
}

-(void)templateStart{
	
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


-(void)generateButtons
{
	
	for (UIView *subview in [self.choicesView subviews]) {
		[subview removeFromSuperview];
	}
	
	for(int i = 0; i < 7; i++){
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self action:NSSelectorFromString(@"test") forControlEvents:UIControlEventTouchDown];
		button.tag = 1;
		button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:50.0f];
		[button setTitle: @"は" forState: UIControlStateNormal];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.contentEdgeInsets = UIEdgeInsetsMake(-1*(screenMargin*0.2), 0, 0, 0);
		button.backgroundColor = [UIColor blueColor];
		
		CALayer *bottomBorder = [CALayer layer];
		bottomBorder.frame = CGRectMake(0, screenButtonHeight-(screenButtonHeight/10), screenButtonWidth, screenButtonHeight/10);
		bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
		[button.layer addSublayer:bottomBorder];
		
		if( i > 3 ){
			button.frame = CGRectMake( ((i-4)*(screenButtonWidth))+((1+(i-4))*(screenMargin/2)), (screenButtonHeight)+(screenMargin), screenButtonWidth, screenButtonHeight);
		}
		else{
			button.frame = CGRectMake( (i*(screenButtonWidth))+((1+i)*(screenMargin/2)), screenMargin/2, screenButtonWidth, screenButtonHeight);
		}
		
		[self.choicesView addSubview:button];
	}
	
}


-(void)test {
	NSLog(@"!!");
}




@end
