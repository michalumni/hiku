//
//  KeyshareViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 27.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "KeyshareViewController.h"
#import "KeyshareCell.h"
#import "KeyshareAddUserCell.h"

#define CELL_IDENTIFIER @"KeyshareCell"
#define CELL_IDENTIFIER_ADD @"KeyshareAddCell"

@interface KeyshareViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation KeyshareViewController

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
    
    [self.tableView registerClass:[KeyshareCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView registerClass:[KeyshareAddUserCell class] forCellReuseIdentifier:CELL_IDENTIFIER_ADD];
    
    //TEMP DATA
    _dataSource = @[@{@"name":@"Pavel Zeifart", @"imageName":@"Pavel"},
                   @{@"name":@"Lucy Stanko", @"imageName":@"Lucy"},
                   @{@"name":@"Lubo Smid", @"imageName":@"Lubo"},
                    @{@"name":@"David Semerad", @"imageName":@"David"},
                   ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0)
        return 65;
    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 1)
        return 1;
    else
        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if([indexPath section] == 0)
    {
        KeyshareCell *cellSpecific = (KeyshareCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
        cellSpecific.iconImageView.image = [UIImage imageNamed:[[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"imageName"]];
        cellSpecific.titleLabel.text = [[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"name"];
        
        cell = cellSpecific;
    }
    else
    {
        KeyshareAddUserCell *cellSpecific = (KeyshareAddUserCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ADD forIndexPath:indexPath];
        cellSpecific.iconImageView.image = [UIImage imageNamed:@"IcnKeyshareAdd"];
        cellSpecific.titleLabel.text = @"Add User";
        
        cell = cellSpecific;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([indexPath section] == 1)
    {
        [self performSegueWithIdentifier:@"ShowAddKeyshareUser" sender:self];
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

@end
