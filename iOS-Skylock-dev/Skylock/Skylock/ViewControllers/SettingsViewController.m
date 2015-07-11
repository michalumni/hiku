//
//  SettingsViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 27.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"

#define CELL_IDENTIFIER @"SettingsCell"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[SettingsCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    [self setProperTitle];
}

-(void)setProperTitle
{
    CDLock *lock = [[SkylockDataManager sharedInstance] pickedLock];
    if(lock != nil)
        self.navigationItem.title = lock.name;
    else
        self.navigationItem.title = NSLocalizedString(@"SKYLOCK_TITLE", @"Title for screens");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(SettingsCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row]) {
                case 0:
                    cell.titleLabel.text = @"Wi-Fi";
                    cell.detailLabel.text = @"Hotspot";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsWifi"]];
                    break;
                case 1:
                    cell.titleLabel.text = @"Bluetooth";
                    cell.detailLabel.text = @"";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsBluetooth"]];
                    break;
                case 2:
                    cell.titleLabel.text = @"Locking Options";
                    cell.detailLabel.text = @"";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsOptions"]];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch ([indexPath row]) {
                case 0:
                    cell.titleLabel.text = @"Crash Alerts";
                    cell.detailLabel.text = @"";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsCrash"]];
                    break;
                case 1:
                    cell.titleLabel.text = @"Theft Alerts";
                    cell.detailLabel.text = @"";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsTheft"]];
                    break;
                case 2:
                    cell.titleLabel.text = @"Keyshare";
                    cell.detailLabel.text = @"";
                    
                    [cell.iconImageView setImage:[UIImage imageNamed:@"IcnSettingsKeyshare"]];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performActionForCellAtIndexPath:indexPath];
}

-(void)performActionForCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row]) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"ShowLockingOptions" sender:self];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch ([indexPath row]) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"ShowKeyshare" sender:self];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
