//
//  MenuCell.m
//  Skylock
//
//  Created by Daniel Ondruj on 26.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconImageView = [UIImageView new];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [UILabel new];
//        [_titleLabel setBackgroundColor:[UIColor redColor]];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
        [_titleLabel setTextColor:MENU_TEXT_NORMAL_COLOR];
        [self.contentView addSubview:_titleLabel];
        
        _numberLabel = [UILabel new];
//        [_numberLabel setBackgroundColor:[UIColor yellowColor]];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_numberLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
        [_numberLabel setTextColor:MENU_TEXT_NUMBER_NORMAL_COLOR];
        [self.contentView addSubview:_numberLabel];
        
        [self setConstraints];
    }
    return self;
}

-(void)setConstraints
{
    /////
    //IMG
    NSLayoutConstraint* conCenterImg = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:conCenterImg];
    
    NSLayoutConstraint* imgLeftPad = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeft
                                                                  relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    [self.contentView addConstraint:imgLeftPad];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_iconImageView addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_iconImageView addConstraint:widthConstraint];
    /////
    
    /////
    //title
    NSLayoutConstraint* titleLabelLeft = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeRight multiplier:1 constant:20];
    [self.contentView addConstraint:titleLabelLeft];
    
    NSLayoutConstraint* titleLabelRight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual toItem:_numberLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-10];
    [self.contentView addConstraint:titleLabelRight];
    
    NSLayoutConstraint* conCenterName = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:conCenterName];
    
    NSLayoutConstraint *heightConstraintTitle = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_titleLabel addConstraint:heightConstraintTitle];
    
    /////
    //number
//    NSLayoutConstraint* numberLabelLeft = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeLeft
//                                                                      relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10];
//    [self.contentView addConstraint:numberLabelLeft];
    
    NSLayoutConstraint* numberLabelRight = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
    [self.contentView addConstraint:numberLabelRight];
//
    NSLayoutConstraint* conCenterNumber = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:conCenterNumber];
    
    NSLayoutConstraint *widthConstraintNumber = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_numberLabel addConstraint:widthConstraintNumber];
    
    NSLayoutConstraint *heightConstraintNumber = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_numberLabel addConstraint:heightConstraintNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
    {
        [_titleLabel setTextColor:MENU_TEXT_SELECTED_COLOR];
        [_numberLabel setTextColor:MENU_TEXT_SELECTED_COLOR];
    }
    else
    {
        [_titleLabel setTextColor:MENU_TEXT_NORMAL_COLOR];
        [_numberLabel setTextColor:MENU_TEXT_NUMBER_NORMAL_COLOR];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if(highlighted)
    {
        [_titleLabel setTextColor:MENU_TEXT_SELECTED_COLOR];
        [_numberLabel setTextColor:MENU_TEXT_SELECTED_COLOR];
        
        [self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.1f]];
    }
    else
    {
        [_titleLabel setTextColor:MENU_TEXT_NORMAL_COLOR];
        [_numberLabel setTextColor:MENU_TEXT_NUMBER_NORMAL_COLOR];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
