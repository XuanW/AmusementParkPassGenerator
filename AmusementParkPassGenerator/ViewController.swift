//
//  ViewController.swift
//  AmusementParkPassGenerator
//
//  Created by XuanWang on 7/1/16.
//  Copyright © 2016 XuanWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let samplePerson = PersonalInfo(firstName: nil, lastName: nil, dateOfBirth: nil, street: nil, city: nil, state: nil, zip: nil)
        printPass(Guest.classic, person: samplePerson)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

