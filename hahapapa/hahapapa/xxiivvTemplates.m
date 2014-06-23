//
//  xxiivvTemplates.m
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvTemplates.h"
#import <QuartzCore/QuartzCore.h>

@interface Template ()

@end

@implementation Template

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIFont*)fontBig {
	return [UIFont boldSystemFontOfSize:60.0f];
}

-(UILabel*)test2 {
	UILabel *loval;
	
	loval.backgroundColor = [UIColor blueColor];
	
	return loval;
}

-(UIButton*)choiceButton:(int)i{
	
	UIButton *button = [[UIButton alloc] init];
	
	[button addTarget:self action:NSSelectorFromString(@"gameChoiceSelected:") forControlEvents:UIControlEventTouchDown];
	button.tag = i;
	button.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:70];
	[button setTitle: @"em" forState: UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
	button.contentEdgeInsets = UIEdgeInsetsMake(-1*(screenMargin*0.2), 0, 0, 0);
	button.alpha = 1;
	
	if( i > 2 ){
		button.frame = CGRectMake( ((i-3)*(screenButtonWidth))+((1+(i-3))*(screenMargin/2)), (screenButtonHeight)+(screenMargin), screenButtonWidth, screenButtonHeight);
	}
	else{
		button.frame = CGRectMake( (i*(screenButtonWidth))+((1+i)*(screenMargin/2)), screenMargin/2, screenButtonWidth, screenButtonHeight);
	}
	
	float tileSize = screen.size.width/3;
	
	if(i == 1){	button.frame = CGRectMake(0, 0, tileSize, tileSize); }
	if(i == 2){	button.frame = CGRectMake(tileSize, 0, tileSize, tileSize); }
	if(i == 3){	button.frame = CGRectMake(tileSize*2, 0, tileSize, tileSize); }
	
	if(i == 4){	button.frame = CGRectMake(0, tileSize, tileSize, tileSize); }
	if(i == 5){	button.frame = CGRectMake(tileSize, tileSize, tileSize, tileSize); }
	if(i == 6){	button.frame = CGRectMake(tileSize*2, tileSize, tileSize, tileSize); }
	
	if(i == 7){	button.frame = CGRectMake(0, tileSize*2, tileSize, tileSize); }
	if(i == 8){	button.frame = CGRectMake(tileSize, tileSize*2, tileSize, tileSize); }
	if(i == 9){	button.frame = CGRectMake(tileSize*2, tileSize*2, tileSize, tileSize); }
	
	return button;
	
}

-(CGRect)lessonViewFrame {
	
	return CGRectMake(0, 0, screen.size.width, screen.size.height);
}

-(CGRect)choicesViewFrame {
	
	return CGRectMake(0, screen.size.height/2.5, screen.size.width, screen.size.height-(screen.size.height/2.5));
}


@end
