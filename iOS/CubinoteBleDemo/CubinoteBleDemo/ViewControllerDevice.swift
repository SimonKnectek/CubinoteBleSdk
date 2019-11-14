//
//  ViewControllerDevice.swift
//  CubinoteBleDemo
//
//  Created by Simon Wei on 2019-11-13.
//  Copyright © 2019 Simon Wei. All rights reserved.
//

import UIKit

class ViewControllerDevice: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var pickerData: [String] = [String]()
    var defaltrow:Int = 0
    var mainViewController:ViewController?
    var tag:Int = 0

    @IBOutlet weak var pickview: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickview.dataSource = self
        pickview.delegate = self
        pickview.reloadAllComponents()
        pickview.selectRow(defaltrow, inComponent: 0, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tag==0{
            mainViewController?.index = row
            mainViewController?.btnselectdevice.setTitle(pickerData[row], for: UIControl.State.normal)
        }
        else if tag==1{
            mainViewController?.led = row
            mainViewController?.btnled.setTitle(pickerData[row], for: UIControl.State.normal)
        }
        else if tag==2{
            mainViewController?.buz = row
            mainViewController?.btnbuz.setTitle(pickerData[row], for: UIControl.State.normal)
        }
        else if tag==3{
            mainViewController?.speed = row
            mainViewController?.btnspeed.setTitle(pickerData[row], for: UIControl.State.normal)
        }
        else if tag==4{
            mainViewController?.languageid = row
            mainViewController?.btnlanguageid.setTitle(pickerData[row], for: UIControl.State.normal)
        }
        return pickerData[row]
    }

}
