//
//  BMImagenDetalleViewController.swift
//  App_BaresMadrid
//
//  Created by formador on 15/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class BMImagenDetalleViewController: UIViewController {
    
    //MARK: - Variables locales
    var calloutIm : UIImage?
    
    //MARK: - IBOutlets
    @IBOutlet weak var myImageBarMadrid: UIImageView!
    
    //MARK: - IBActions
    @IBAction func hideVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - LIFE VC 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let calloutImDes = calloutIm{
            myImageBarMadrid.image = calloutImDes
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
