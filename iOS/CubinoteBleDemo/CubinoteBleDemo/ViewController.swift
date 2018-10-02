//
//  ViewController.swift
//  CubinoteBleDemo
//
//  Created by Simon Wei on 2018-09-12.
//  Copyright © 2018 Simon Wei. All rights reserved.
//

import UIKit
import ExternalAccessory
import CubinoteBLESDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var PVDevices: UIPickerView!
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var pvDevices: UIPickerView!
    @IBOutlet weak var pvLed: UIPickerView!
    @IBOutlet weak var pvBuz: UIPickerView!
    @IBOutlet weak var pvSpeed: UIPickerView!
    @IBOutlet weak var pvLanguageId: UIPickerView!
    @IBOutlet weak var tvReadResult: UITextView!
    
    var connectedCubinotes: [EAAccessory] = [EAAccessory]()
    var pickerDevicesData: [String] = [String]()
    var pickerData: [String] = [String]()
    var pickerData1: [String] = [String]()
    var index:Int = 0
    
    let sdk = CubinoteBLESDK.CubinoteBLE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerData = ["0", "1"]
        pickerData1 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","10", "11", "12", "13", "14", "15", "16", "17", "18", "19","20", "21"]
        
        pvDevices.dataSource = self
        pvDevices.delegate = self
        
        pvLed.dataSource = self
        pvLed.delegate = self
        pvLed.selectRow(1, inComponent: 0, animated: false)
        
        pvBuz.dataSource = self
        pvBuz.delegate = self
        pvBuz.selectRow(1, inComponent: 0, animated: false)
        
        pvSpeed.dataSource = self
        pvSpeed.delegate = self
        pvSpeed.selectRow(1, inComponent: 0, animated: false)
        
        pvLanguageId.dataSource = self
        pvLanguageId.delegate = self
        pvLanguageId.selectRow(1, inComponent: 0, animated: false)
        
        connectedCubinotes = EAAccessoryManager.shared().connectedAccessories
        print(connectedCubinotes)
        for acc in connectedCubinotes {
            pickerDevicesData.append(acc.name)
        }
        if pickerDevicesData.count>0{
            pvDevices.reloadAllComponents()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag==2 {
            return pickerDevicesData.count
        }
        else if pickerView.tag==1 {
            return pickerData1.count
        }
        else{
            return pickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag==2 {
            return pickerDevicesData[row]
        }
        else if pickerView.tag==1 {
            return pickerData1[row]
        }
        else{
            return pickerData[row]
        }
    }
    
    func readCallback(result:String)->Void{
        tvReadResult.text = result
    }
    
    @IBAction func ClickOpen(_ sender: Any) {
        if connectedCubinotes.count<=0{
            return
        }
        index = pvDevices.selectedRow(inComponent: 0)
        
        tvResult.text = String(sdk.CubinoteBLE_OpenSession(device: connectedCubinotes[index], callback:readCallback))
    }
    
    @IBAction func ClickClose(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_CloseSession())
    }

    @IBAction func ClickGetStatus(_ sender: Any) {
        tvResult.text = String(sdk.CubinoteBLE_GetStatus())
    }
    
    @IBAction func ClickSet(_ sender: Any) {
        let led = Int(pickerData[pvLed.selectedRow(inComponent: 0)])
        let buz = Int(pickerData[pvBuz.selectedRow(inComponent: 0)])
        let speed = Int(pickerData1[pvSpeed.selectedRow(inComponent: 0)])
        let languageid = Int(pickerData[pvLanguageId.selectedRow(inComponent: 0)])
        
        tvResult.text = String(sdk.CubinoteBLE_Set(led: led!, buz: buz!, speed: speed!, languageId: languageid!))
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
}

