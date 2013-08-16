//
//  xxiivvTemplates.m
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-15.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvTemplates.h"

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


-(CGRect)lessonViewFrame {
	
	return CGRectMake(0, 0, screen.size.width, screen.size.height/2.5);
}

-(CGRect)choicesViewFrame {
	
	return CGRectMake(0, screen.size.height/2.5, screen.size.width, screen.size.height-(screen.size.height/2.5));
}


@end
