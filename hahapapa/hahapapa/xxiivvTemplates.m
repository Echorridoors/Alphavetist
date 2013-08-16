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
	
//	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self action:NSSelectorFromString(@"gameChoiceSelected:") forControlEvents:UIControlEventTouchDown];
	button.tag = i;
	button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:50.0f];
	[button setTitle: @"em" forState: UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.contentEdgeInsets = UIEdgeInsetsMake(-1*(screenMargin*0.2), 0, 0, 0);
	button.backgroundColor = [UIColor blueColor];
	button.alpha = 0;
	
	if( i > 2 ){
		button.frame = CGRectMake( ((i-3)*(screenButtonWidth))+((1+(i-3))*(screenMargin/2)), (screenButtonHeight)+(screenMargin), screenButtonWidth, screenButtonHeight);
	}
	else{
		button.frame = CGRectMake( (i*(screenButtonWidth))+((1+i)*(screenMargin/2)), screenMargin/2, screenButtonWidth, screenButtonHeight);
	}
	
	
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, screenButtonHeight-(screenButtonHeight/10), screenButtonWidth, screenButtonHeight/10);
	bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
	[button.layer addSublayer:bottomBorder];
	
	return button;
	
}

-(CALayer*)bottomBorder{
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, screenButtonHeight-(screenButtonHeight/10), screenButtonWidth, screenButtonHeight/10);
	bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
	return bottomBorder;
}


-(CGRect)lessonViewFrame {
	
	return CGRectMake(0, 0, screen.size.width, screen.size.height/2.5);
}

-(CGRect)choicesViewFrame {
	
	return CGRectMake(0, screen.size.height/2.5, screen.size.width, screen.size.height-(screen.size.height/2.5));
}


@end
