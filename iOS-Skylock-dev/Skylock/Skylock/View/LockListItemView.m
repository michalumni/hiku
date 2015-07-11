//
//  LockListItemView.m
//  Skylock
//
//  Created by Daniel Ondruj on 20.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "LockListItemView.h"

@implementation LockListItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setUp
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapRecognizer];
    _selected = NO;
    [_bkgImage setImage:_unselectedBkgImage];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:YES];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:NO];
}

-(void)setDefault:(BOOL)isDefault
{
    [_defaultSignImage setImage:(isDefault)?[UIImage imageNamed:@"LockFavourite_selected"]:[UIImage imageNamed:@"LockFavourite"]];
}

-(void)tapped:(UITapGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        [self setSelected:YES];
    }
    else if(recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self setSelected:NO];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self setSelected:NO];
        
        if(_delegate && [_delegate respondsToSelector:@selector(lockItemClicked:withLock:)])
            [_delegate lockItemClicked:self withLock:_lock];
    }
}

-(void)setSelected:(BOOL)state
{
    if(_selected == state)
        return;
    
    if(state)
        [_bkgImage setImage:_selectedBkgImage];
    else
        [_bkgImage setImage:_unselectedBkgImage];
    
    _selected = state;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
