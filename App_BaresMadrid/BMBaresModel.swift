//
//  BMBaresModel.swift
//  App_BaresMadrid
//
//  Created by formador on 13/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class BMBaresModel: NSObject {
    
    var direccionBares : String?
    var latitudBares : Double?
    var longitudBares : Double?
    var imagenBares : String? // url de la imagen -> ruta apple local - remota
    
    init(pDireccionBares : String, pLatitudBares : Double, pLongitudBares : Double, pImagenBares : String) {
        self.direccionBares = pDireccionBares
        self.latitudBares = pLatitudBares
        self.longitudBares = pLongitudBares
        self.imagenBares = pImagenBares
        super.init()
    }
    
}
