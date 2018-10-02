//
//  CubinoteBLE.swift
//  CubinoteBLE
//
//  Created by Simon Wei on 2018-09-12.
//  Copyright © 2018 Simon Wei. All rights reserved.
//
import CoreBluetooth
import ExternalAccessory
public var iMaxPackageSize: Int

public class CubinoteBLE {
    
    public let CubinoteBLE_OK: Int
    
    public let CubinoteBLE_ERR_Invalid_DeviceName: Int
    
    public let CubinoteBLE_ERR_Open_Device_Failed: Int
    
    public let CubinoteBLE_ERR_Parameter_Led: Int
    
    public let CubinoteBLE_ERR_Parameter_Buz: Int
    
    public let CubinoteBLE_ERR_Parameter_Speed: Int
    
    public let CubinoteBLE_ERR_Parameter_LanguageId: Int
    
    public let CubinoteBLE_ERR_Session_Not_Opened: Int
    
    public let CubinoteBLE_ERR_Session_Busy: Int
    
    internal let center: NotificationCenter
    
    internal let mainQueue: OperationQueue
    
    internal var token: NSObjectProtocol?
    
    public init()
    
    public func CubinoteBLE_OpenSession(device: EAAccessory, callback: @escaping ((String) -> Void)) -> String
    
    public func CubinoteBLE_CloseSession() -> String
    
    public func CubinoteBLE_GetStatus() -> String
    
    public func CubinoteBLE_Set(led: Int, buz: Int, speed: Int, languageId: Int) -> String
    
    public func CubinoteBLE_Print_BWImage(pImage: NSData) -> String
    
    public func CubinoteBLE_Print_Content(innerContent: InnerContent) -> String
}
