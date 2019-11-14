//
//  ViewController.swift
//  CubinoteBleDemo
//
//  Created by Simon Wei on 2018-09-12.
//  Copyright © 2018 Simon Wei. All rights reserved.
//

import UIKit
import CubinoteBLESDK
import ExternalAccessory

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var tvReadResult: UITextView!
    @IBOutlet weak var btnselectdevice: UIButton!
    @IBOutlet weak var btnled: UIButton!
    @IBOutlet weak var btnbuz: UIButton!
    @IBOutlet weak var btnspeed: UIButton!
    @IBOutlet weak var btnlanguageid: UIButton!
    @IBOutlet weak var tvTimeOut: UITextField!
    
    var connectedCubinotes: [EAAccessory] = [EAAccessory]()
    var pickerDevicesData: [String] = [String]()
    var pickerData: [String] = [String]()
    var pickerData1: [String] = [String]()
    var index:Int = 0
    var led:Int = 1
    var buz:Int = 1
    var speed:Int = 1
    var languageid:Int = 1
    
    let sdk = CubinoteBLESDK.CubinoteBLE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerData = ["0", "1"]
        pickerData1 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","10", "11", "12", "13", "14", "15", "16", "17", "18", "19","20", "21"]
        
        connectedCubinotes = EAAccessoryManager.shared().connectedAccessories
        print(connectedCubinotes)
        for acc in connectedCubinotes {
            pickerDevicesData.append(acc.name)
        }
        if pickerDevicesData.count>0{
            btnselectdevice.setTitle(pickerDevicesData[index], for: UIControl.State.normal)
        }
        
        tvTimeOut.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readCallback(result:String)->Void{
        tvReadResult.text = result
    }
    
    
    @IBAction func ClickSelectDevice(_ sender: Any) {
        if pickerDevicesData.count>0{
            let viewControllerStoryboardId = "selectdeviceview"
            let storyboardName = "Main"
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            
            let vc:ViewControllerDevice = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! ViewControllerDevice
            
            vc.pickerData = pickerDevicesData
            vc.defaltrow = index
            vc.title = "Select Device"
            vc.tag = 0
            vc.mainViewController = self
            self.navigationController!.pushViewController(vc, animated: false)
        }
        else{
            
        }
    }
    
    @IBAction func ClickLed(_ sender: Any) {
        let viewControllerStoryboardId = "selectdeviceview"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        let vc:ViewControllerDevice = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! ViewControllerDevice
        
        vc.pickerData = pickerData
        vc.defaltrow = led
        vc.title = "Set LED"
        vc.tag = 1
        vc.mainViewController = self
        self.navigationController!.pushViewController(vc, animated: false)
    }
    @IBAction func ClickBuz(_ sender: Any) {
        let viewControllerStoryboardId = "selectdeviceview"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        let vc:ViewControllerDevice = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! ViewControllerDevice
        
        vc.pickerData = pickerData
        vc.defaltrow = buz
        vc.title = "Set Buz"
        vc.tag = 2
        vc.mainViewController = self
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func ClickSpeed(_ sender: Any) {
        let viewControllerStoryboardId = "selectdeviceview"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        let vc:ViewControllerDevice = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! ViewControllerDevice
        
        vc.pickerData = pickerData
        vc.defaltrow = speed
        vc.title = "Set Speed"
        vc.tag = 3
        vc.mainViewController = self
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    @IBAction func ClickLanguageId(_ sender: Any) {
        let viewControllerStoryboardId = "selectdeviceview"
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        let vc:ViewControllerDevice = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! ViewControllerDevice
        
        vc.pickerData = pickerData1
        vc.defaltrow = languageid
        vc.title = "Set Language"
        vc.tag = 4
        vc.mainViewController = self
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    
    func windowRootViewController() -> UIViewController {
        return (UIApplication.shared.delegate?.window??.rootViewController)!
    }
    
    @IBAction func ClickOpen(_ sender: Any) {
        if connectedCubinotes.count<=0{
            return
        }
        tvResult.text = String(sdk.CubinoteBLE_OpenSession(device: connectedCubinotes[index], callback:readCallback))
    }
    
    @IBAction func ClickClose(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_CloseSession())
    }

    @IBAction func ClickGetStatus(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_GetStatus())
    }
    
    @IBAction func ClickSet(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_Set(led: led, buz: buz, speed: speed, languageId: languageid))
    }
    @IBAction func ClickGetTimeout(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_GetTimeOut())
    }
    @IBAction func ClickSetTimeout(_ sender: Any) {
        let tt = tvTimeOut.text!
        let timeo:Int = Int(tt) ?? 60000
        tvResult.text = String(sdk.CubinoteBLE_SetTimeOut(timeout: timeo))
    }
    
    @IBAction func ClickPrintBWImage(_ sender: Any) {
        let filePath = Bundle.main.url(forResource: "after", withExtension: "bmp")
        let data = NSData(contentsOf: filePath!)
        tvResult.text = String(sdk.CubinoteBLE_Print_BWImage(pImage: data!))
    }
    @IBAction func ClickPrintContent(_ sender: Any) {
        //create a solid line
        let t1 = TextItem(iconID:41)
        let innerContent = InnerContent(item:t1)
        
        //create a regular text and insert it into print content
        let text = "Test Cubinote SDK"
        let t2 = TextItem(basetext: text, printType:1)
        innerContent.textList.append(t2)
        
        //create a big font, bold and underline text and insert it into print content
        let t3 = TextItem(basetext: text, printType: 1)
        t3.underline = 130
        t3.bold = 1
        t3.fontSize = 2
        innerContent.textList.append(t3)
        
        //create a QR code and insert it into print content
        let qr = "Test QR code"
        let t4 = TextItem(basetext: qr, printType: 3)
        innerContent.textList.append(t4)
        
        //create a material and insert it into print content
        let t5 = TextItem(iconID: 10)
        innerContent.textList.append(t5)
        
        //load data from a Monochrom bitmap file and insert it into print content
        let filePath = Bundle.main.url(forResource: "after", withExtension: "bmp")
        let data = NSData(contentsOf: filePath!)
        let base64String = data?.base64EncodedString(options: .endLineWithLineFeed)
        let p1 = TextItem(basetext: base64String!, printType: 5)
        innerContent.textList.append(p1)
        
        //create a dash line and insert it into print content
        let t6 = TextItem(iconID: 42)
        innerContent.textList.append(t6)
        
        //create a Cubinote logo and insert it into print content
        let t7 = TextItem(iconID: 57)
        innerContent.textList.append(t7)
        
        tvResult.text = String(sdk.CubinoteBLE_Print_Content(innerContent: innerContent))
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

