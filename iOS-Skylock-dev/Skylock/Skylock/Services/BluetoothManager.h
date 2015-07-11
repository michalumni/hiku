//
//  BluetoothManager.h
//  Skylock
//
//  Created by Daniel Ondruj on 23.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define BT_DID_FAIL_CONNECT @"DidFailToConnect"
#define BT_DID_CONNECT @"DidConnect"
#define BT_DID_DISCONNECT @"DidDisconnect"

@protocol BluetoothManagerDelegate <NSObject>

-(void)didFindPeripherals:(NSArray *)array;
-(void)didFailConnectToPeripheral:(NSString *)nameOfPeripheral;
-(void)didConnectToPeripheral:(NSString *)nameOfPeripheral;
-(void)didDisconnectToPeripheral:(NSString *)nameOfPeripheral;

@end

typedef enum
{
    kNoneRoquest = 1,
    kLookForSkylockPeripheralsRequest,
    kStopScannSkylockPeripheralsRequest,
    kCancelPeripheralConnectionRequest,
    kConnectToPeripheralRequest
} CBManagerRequest;

@interface BluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    
}

@property (nonatomic, weak) id<BluetoothManagerDelegate> delegate;

+ (BluetoothManager*)sharedInstance;
-(void)stopScanningForPeripherals;
-(void)lookForSkylockPeripherals;
-(void)reconnectPeripheralWithBTID:(NSString *)btid;
-(void)connectToPeripheral:(CBPeripheral *)peripheral;
-(void)disconnectConnectedPeripheral;
-(NSString *)getLocalIDStringOfConnectedPeripheral;
-(NSUUID *)getLocalUUIDOfConnectedPeripheral;
-(void)setLockStateTo:(LockState)newState;
-(void)readLockStateForConnectedDevice;

@end
