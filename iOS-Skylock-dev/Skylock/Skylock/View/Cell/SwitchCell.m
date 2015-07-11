//
//  SwitchCell.m
//  Skylock
//
//  Created by Daniel Ondruj on 29.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticeNeue" size:17]];
        [_titleLabel setTextColor:KEYSHARE_TEXT_NORMAL_COLOR];
        [self.contentView addSubview:_titleLabel];
        
        _valueSwitch = [UISwitch new];
        _valueSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_valueSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_valueSwitch];
        
        [self setConstraints];
    }
    return self;
}

-(void)setSwitchSelected:(BOOL)switchSelected
{
    _switchSelected = switchSelected;
    [_valueSwitch setOn:switchSelected];
}

- (void)setState:(id)sender
{
    _switchSelected = [_valueSwitch isOn];
    
//    if(_delegate && [_delegate respondsToSelector:@selector(cellWithID:changedSelectedStateTo:)])
//    {
//        [_delegate cellWithID:_cellID changedSelectedStateTo:_switchSelected];
//    }
}

-(void)setConstraints
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_titleLabel]-[_valueSwitch]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _valueSwitch)]];
    
    NSLayoutConstraint* con1 = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:con1];
    
    NSLayoutConstraint* con2 = [NSLayoutConstraint constraintWithItem:_valueSwitch attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:con2];
    
    //    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_descriptionLabel(>=50)]-[_inputBkgView(>=40)]-[_separatorImage(1)]-10-[_hintLabel(35)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionLabel, _inputBkgView, _separatorImage, _hintLabel)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    //self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}

@end
