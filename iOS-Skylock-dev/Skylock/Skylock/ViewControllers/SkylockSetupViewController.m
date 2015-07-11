//
//  SkylockSetupViewController.m
//  Skylock
//
//  Created by Daniel Ondruj on 23.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "SkylockSetupViewController.h"

@interface SkylockSetupViewController ()

@property (nonatomic, strong) NSArray *peripheralsArray;
@property (nonatomic, strong) CBPeripheral *selectedPeripheral;

@end

@implementation SkylockSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [[BluetoothManager sharedInstance] stopScanningForPeripherals];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"peripheralCell"];
    
    [[BluetoothManager sharedInstance] lookForSkylockPeripherals];
    [BluetoothManager sharedInstance].delegate = self;
    
    [_continueButton setEnabled:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_continueButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFindPeripherals:(NSArray *)array
{
    _peripheralsArray = array;
    [_tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_peripheralsArray==nil)
        return 0;
    return [_peripheralsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"peripheralCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CBPeripheral *peripheral = [_peripheralsArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

/*
 user selected row
 stop scanner
 connect peripheral for service search
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPeripheral = [_peripheralsArray objectAtIndex:[indexPath row]];
    [_continueButton setEnabled:YES];
}

-(void)didConnectToPeripheral:(NSString *)nameOfPeripheral
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //segue
    [self performSegueWithIdentifier:@"showChooseNameController" sender:self];
}

-(void)didFailConnectToPeripheral:(NSString *)nameOfPeripheral
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connecting error" message:[NSString stringWithFormat:@"Couldn't connect to %@", nameOfPeripheral] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)continueButtonAction:(id)sender {
    if(_selectedPeripheral)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BluetoothManager sharedInstance] stopScanningForPeripherals];
        [[BluetoothManager sharedInstance] connectToPeripheral:_selectedPeripheral];
    }
}

- (IBAction)closeGuideAction:(id)sender {
    [[BluetoothManager sharedInstance] disconnectConnectedPeripheral];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
