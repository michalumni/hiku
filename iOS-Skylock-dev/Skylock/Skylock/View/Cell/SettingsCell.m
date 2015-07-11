//
//  SettingsCell.m
//  Skylock
//
//  Created by Daniel Ondruj on 27.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _iconImageView = [UIImageView new];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [UILabel new];
        //        [_titleLabel setBackgroundColor:[UIColor redColor]];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [_titleLabel setTextColor:SETTINGS_TEXT_NORMAL_COLOR];
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [UILabel new];
        //        [_numberLabel setBackgroundColor:[UIColor yellowColor]];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_detailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [_detailLabel setTextColor:SETTINGS_DETAIL_TEXT_NORMAL_COLOR];
        [_detailLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_detailLabel];
        
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
                                                                  relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:15];
    [self.contentView addConstraint:imgLeftPad];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32];
    [_iconImageView addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32];
    [_iconImageView addConstraint:widthConstraint];
    /////
    
    /////
    //title
    NSLayoutConstraint* titleLabelLeft = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeRight multiplier:1 constant:17];
    [self.contentView addConstraint:titleLabelLeft];
    
    NSLayoutConstraint* titleLabelRight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual toItem:_detailLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-10];
    [self.contentView addConstraint:titleLabelRight];
    
    NSLayoutConstraint* conCenterName = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:conCenterName];
    
    NSLayoutConstraint *heightConstraintTitle = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_titleLabel addConstraint:heightConstraintTitle];
    
    /////
    //detail
    NSLayoutConstraint* numberLabelRight = [NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-15];
    [self.contentView addConstraint:numberLabelRight];
    //
    NSLayoutConstraint* conCenterNumber = [NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:conCenterNumber];
    
    NSLayoutConstraint *widthConstraintDetail = [NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:75];
    [_detailLabel addConstraint:widthConstraintDetail];
    
    NSLayoutConstraint *heightConstraintNumber = [NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [_detailLabel addConstraint:heightConstraintNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
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
