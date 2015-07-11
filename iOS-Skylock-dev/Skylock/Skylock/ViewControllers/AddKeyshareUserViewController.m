//
//  AddKeyshareUserViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 29.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "AddKeyshareUserViewController.h"
#import "KeyshareAddCell.h"

#define CELL_IDENTIFIER @"CellIdentifier"

@interface AddKeyshareUserViewController ()

@property (nonatomic, strong) NSArray* skylockUsers;
@property (nonatomic, strong) NSMutableArray* skylockUsersFiltered;

@end

@implementation AddKeyshareUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _skylockUsersFiltered = [[NSMutableArray alloc] init];
    
    _skylockUsers = @[@{@"name":@"Pavel Zeifart", @"imageName":@"Pavel"},
                   @{@"name":@"Lucy Stanko", @"imageName":@"Lucy"},
                   @{@"name":@"Lubo Smid", @"imageName":@"Lubo"},
                   @{@"name":@"David Semerad", @"imageName":@"David"},
                   ];
    
    [self.tableView registerClass:[KeyshareAddCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[KeyshareAddCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.searchDisplayController.searchResultsTableView.rowHeight = 65;
    self.searchDisplayController.displaysSearchBarInNavigationBar = NO;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_skylockUsersFiltered count];
    } else {
        return [_skylockUsers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyshareAddCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.iconImageView.image = [UIImage imageNamed:[[_skylockUsersFiltered objectAtIndex:[indexPath row]] objectForKey:@"imageName"]];
        cell.titleLabel.text = [[_skylockUsersFiltered objectAtIndex:[indexPath row]] objectForKey:@"name"];
    }
    else
    {
        cell.iconImageView.image = [UIImage imageNamed:[[_skylockUsers objectAtIndex:[indexPath row]] objectForKey:@"imageName"]];
        cell.titleLabel.text = [[_skylockUsers objectAtIndex:[indexPath row]] objectForKey:@"name"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [_skylockUsersFiltered removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    _skylockUsersFiltered = [NSMutableArray arrayWithArray:[_skylockUsers filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
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
