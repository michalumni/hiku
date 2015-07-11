//
//  SwitchCell.h
//  Skylock
//
//  Created by Daniel Ondruj on 29.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *valueSwitch;

@property (nonatomic) BOOL switchSelected;

//@property (nonatomic) FiltrationCellIDs cellID;

//@property (nonatomic, unsafe_unretained) id <SwitchCellDelegate> delegate;

-(void)setSwitchSelected:(BOOL)switchSelected;

@end
