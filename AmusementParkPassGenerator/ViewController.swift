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
        
        // Plug data for testing
        
        let plugClassicGuest = PersonalInfo(firstName: nil, lastName: nil, dateOfBirth: nil, street: nil, city: nil, state: nil, zip: nil)
        printPass(Guest.classic, person: plugClassicGuest)
        
        let plugVIPGuest = PersonalInfo(firstName: nil, lastName: nil, dateOfBirth: nil, street: nil, city: nil, state: nil, zip: nil)
        printPass(Guest.vip, person: plugVIPGuest)
        
        let plugChildGuest = PersonalInfo(firstName: nil, lastName: nil, dateOfBirth: "03/02/2010", street: nil, city: nil, state: nil, zip: nil)
        printPass(Guest.freeChild, person: plugChildGuest)
        
        let plugHourlyEmployeeFood = PersonalInfo(firstName: "David", lastName: "Parker", dateOfBirth: nil, street: nil, city: nil, state: nil, zip: nil)
        printPass(Employee.hourlyFood, person: plugHourlyEmployeeFood)
        
        let plugHourlyEmployeeRide = PersonalInfo(firstName: "Matt", lastName: "Monohan", dateOfBirth: nil, street: "329 Candy Rd", city: "Los Angeles", state: "CA", zip: "83923")
        printPass(Employee.hourlyRide, person: plugHourlyEmployeeRide)
        
        let plugHourlyEmployeeMaintenance = PersonalInfo(firstName: "Charlie", lastName: "Brown", dateOfBirth: nil, street: "920 Peanut Street", city: "Chicago", state: "IL", zip: "37283")
        printPass(Employee.hourlyMaintenance, person: plugHourlyEmployeeMaintenance)
        
        let plugManager = PersonalInfo(firstName: "Ian", lastName: "Chang", dateOfBirth:nil, street: "203 Turtle Road", city: "San Francisco", state: nil, zip: "93028")
        printPass(Employee.manager, person: plugManager)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

