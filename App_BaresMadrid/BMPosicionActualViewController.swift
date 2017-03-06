//
//  BMPosicionActualViewController.swift
//  App_BaresMadrid
//
//  Created by formador on 22/2/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import MapKit

class BMPosicionActualViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    

    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

