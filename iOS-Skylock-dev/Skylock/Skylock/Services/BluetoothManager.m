//
//  BluetoothManager.m
//  Skylock
//
//  Created by Daniel Ondruj on 23.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "BluetoothManager.h"

static NSString *kLockServiceUUID = @"ddea706a-9d53-4bbb-ac0b-74ba819e7d9c";
static NSString *kLockCharacteristicUUID = @"f1c7c102-27bc-4074-aee6-35c58a3b31f6";

@interface BluetoothManager ()

@property (nonatomic, strong) CBCentralManager * manager;
@property (nonatomic, strong) NSMutableArray   * peripherals;
@property (nonatomic, strong) CBPeripheral * connected_peripheral;
@property (nonatomic, strong) CBService *lockingService;
@property (nonatomic, strong) CBCharacteristic *lockingCharacteristic;
@property (nonatomic, strong) NSData *lockingBufferData;

@property (nonatomic) CBManagerRequest cbManagerRequest;

@property (nonatomic) BOOL writingLockStateRequest;

@property (nonatomic) BOOL reconnectionRequest;
@property (nonatomic, strong) CBPeripheral *readyToConnectTempPeripheral;

@end


@implementation BluetoothManager

- (id)init
{
    self = [super init];
    if (self) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _connected_peripheral = nil;
        _peripherals = [[NSMutableArray alloc] init];
        _cbManagerRequest = kNoneRoquest;
        _reconnectionRequest = NO;
    }
    return self;
}

+ (BluetoothManager*)sharedInstance
{
    static BluetoothManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BluetoothManager alloc] init];
    });
    
    return instance;
}

#pragma mark - Scanning for peripherals

-(void)stopScanningForPeripherals
{
    if(_manager.state==CBCentralManagerStatePoweredOn)
    {
        //you're good to go on calling centralManager methods
        _cbManagerRequest = kNoneRoquest;
        
        [_manager stopScan];
    }
    else
    {
        _cbManagerRequest = kStopScannSkylockPeripheralsRequest;
    }
}

-(void)lookForSkylockPeripherals
{
    if(_manager.state==CBCentralManagerStatePoweredOn)
    {
        //you're good to go on calling centralManager methods
        _cbManagerRequest = kNoneRoquest;
        
        NSArray * services=[NSArray arrayWithObjects:
                            [CBUUID UUIDWithString:kLockServiceUUID],
                            nil
                            ];
        
        [_manager scanForPeripheralsWithServices:services options: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
    }
    else
    {
        _cbManagerRequest = kLookForSkylockPeripheralsRequest;
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        switch (_cbManagerRequest) {
            case kLookForSkylockPeripheralsRequest:
                [self lookForSkylockPeripherals];
                break;
            case kStopScannSkylockPeripheralsRequest:
                [self stopScanningForPeripherals];
                break;
            case kConnectToPeripheralRequest:
                [_manager connectPeripheral:_readyToConnectTempPeripheral options:nil];
                break;
            case kCancelPeripheralConnectionRequest:
                [_manager cancelPeripheralConnection:_connected_peripheral];
                break;
            default:
                break;
        }
    }
    
//    char * managerStrings[]={
//        "Unknown",
//        "Resetting",
//        "Unsupported",
//        "Unauthorized",
//        "PoweredOff",
//        "PoweredOn"
//    };
//    
//    NSString * newstring=[NSString stringWithFormat:@"Manager State: %s",managerStrings[central.state]];
}

/**
 Called when scanner finds device
 First checks if it exists, if not then insert new device
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BOOL (^test)(id obj, NSUInteger idx, BOOL *stop);
    test = ^ (id obj, NSUInteger idx, BOOL *stop) {
        if([[obj name] compare:peripheral.name] == NSOrderedSame)
            return YES;
        return NO;
    };
    
    NSUInteger t=[_peripherals indexOfObjectPassingTest:test];
    if(t == NSNotFound)
    {
        [_peripherals addObject: peripheral];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(didFindPeripherals:)])
        [_delegate didFindPeripherals:_peripherals];
}

#pragma mark - Connection

-(void)reconnectPeripheralWithBTID:(NSString *)btid
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:btid];
    NSArray *knownPeripherals = [_manager retrievePeripheralsWithIdentifiers:@[uuid]];
    if((knownPeripherals != nil) && ([knownPeripherals count] > 0))
    {
        _readyToConnectTempPeripheral = [knownPeripherals firstObject];
        
        if(_manager.state==CBCentralManagerStatePoweredOn)
            [_manager connectPeripheral:_readyToConnectTempPeripheral options:nil];
        else
            _cbManagerRequest = kConnectToPeripheralRequest;
    }
}

-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
    _readyToConnectTempPeripheral = peripheral;
    
    //disconnect first
    if(_connected_peripheral != nil)
    {
        _reconnectionRequest = NO;
        
        [self disconnectConnectedPeripheral];
    }
    else
    {
        if(_manager.state==CBCentralManagerStatePoweredOn)
        {
            _cbManagerRequest = kNoneRoquest;
            [_manager connectPeripheral:_readyToConnectTempPeripheral options:nil];
        }
        else
            _cbManagerRequest = kConnectToPeripheralRequest;
    }
}

-(void)disconnectConnectedPeripheral
{
    //disconnect peripheral if connected
    if(_connected_peripheral != nil)
    {
        if(_manager.state==CBCentralManagerStatePoweredOn)
        {
            _cbManagerRequest = kNoneRoquest;
            [_manager cancelPeripheralConnection:_connected_peripheral];
        }
        else
            _cbManagerRequest = kCancelPeripheralConnectionRequest;
    }
}

#pragma mark - Services works

- (void)connectServices
{
    [_connected_peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error != nil)
    {
        //TODO: handle error
        return;
    }
    
    for(CBService *service in _connected_peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:kLockServiceUUID]])
        {
            _lockingService = service;
            [_connected_peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
}

#pragma mark - Characteristic works

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if(error != nil)
    {
        //TODO: handle error
        return;
    }
    
    for(CBCharacteristic *characteristic in _lockingService.characteristics)
    {
        NSLog(@"%@", characteristic.UUID);
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kLockCharacteristicUUID]])
        {
            _lockingCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:_lockingCharacteristic];
        }
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(didConnectToPeripheral:)])
    {
        [_delegate didConnectToPeripheral:peripheral.name];
    }
    
    [[SkylockDataManager sharedInstance] didConnectPeripheralWithID:[self getLocalUUIDOfConnectedPeripheral]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BT_DID_CONNECT object:nil userInfo:@{@"peripheral":peripheral}];
}

-(void)readLockStateForConnectedDevice
{
    if(_connected_peripheral != nil)
    {
        if(_lockingCharacteristic != nil)
        {
            [_connected_peripheral readValueForCharacteristic:_lockingCharacteristic];
        }
    }
        
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSData *data = characteristic.value;
    // parse the data as needed
    
    if(_lockingCharacteristic == characteristic)
        _lockingBufferData = [NSData dataWithData:data];
    
    unsigned char *aBuffer = malloc(1);
    NSRange range = {1, 1};
    [_lockingBufferData getBytes:aBuffer range:range];
    
    BOOL a;
    if(aBuffer[0] == 1)
    {
        a = YES;
    }
    else
    {
        a = NO;
    }
    //[self peripheralHasNewData:data];
    
    [[SkylockDataManager sharedInstance] didReadLockLocked:a];
}

-(void)peripheralHasNewData:(NSData *)data
{
    if(_writingLockStateRequest)
    {
        _writingLockStateRequest = NO;
    }
}

-(void)setLockStateTo:(LockState)newState
{
    if(_lockingBufferData == nil)
        return;
    
    NSMutableData *data;
    unsigned char *aBuffer;
    NSRange range = {1, 1};
    
    data = [NSMutableData dataWithData:_lockingBufferData];
    
    aBuffer = malloc(1);
    if(newState == eLocked)
        aBuffer[0] = 1;
    else if(newState == eUnlocked)
        aBuffer[0] = 0;
        
    [data replaceBytesInRange:range withBytes:aBuffer];
    
    NSLog(@"Writing value for characteristic %@", _lockingCharacteristic);
    [_connected_peripheral writeValue:data forCharacteristic:_lockingCharacteristic
                                type:CBCharacteristicWriteWithResponse];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
    }
}

#pragma mark - Connection delegates

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _connected_peripheral = peripheral;
    _connected_peripheral.delegate = self;
    
    _reconnectionRequest = YES;
    
//    if(_delegate && [_delegate respondsToSelector:@selector(didConnectToPeripheral:)])
//        [_delegate didConnectToPeripheral:peripheral.name];
    [self connectServices];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _connected_peripheral = nil;
    
    [[SkylockDataManager sharedInstance] didDisconnectPeripheralWithID:peripheral.identifier];
    
    if(_reconnectionRequest)
        [self connectToPeripheral:_readyToConnectTempPeripheral];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BT_DID_DISCONNECT object:nil userInfo:@{@"peripheral":peripheral}];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(_delegate && [_delegate respondsToSelector:@selector(didFailConnectToPeripheral:)])
        [_delegate didFailConnectToPeripheral:peripheral.name];
    
    if(_reconnectionRequest)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self connectToPeripheral:_readyToConnectTempPeripheral];
        });
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BT_DID_FAIL_CONNECT object:nil userInfo:@{@"peripheral":peripheral}];
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}

-(NSString *)getLocalIDStringOfConnectedPeripheral
{
    NSString *s = @"";
    if(_connected_peripheral)
        s = [_connected_peripheral.identifier UUIDString];
    return s;
}

-(NSUUID *)getLocalUUIDOfConnectedPeripheral
{
    NSUUID *identifier = nil;// = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
    if(_connected_peripheral)
        identifier = _connected_peripheral.identifier;
    return identifier;
}

@end
