//
//  xxiivvLessons.h
//  hahapapa
//
//  Created by Devine Lu Linvega on 2013-08-16.
//  Copyright (c) 2013 XXIIVV. All rights reserved.
//

#import "xxiivvViewController.h"

@interface Lesson : xxiivvViewController
	-(NSArray*)lessonContent;
	-(int)nextLesson;
@end

NSArray *gameLessonsArray;