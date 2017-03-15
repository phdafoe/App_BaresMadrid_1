//
//  BMBaresModel.swift
//  App_BaresMadrid
//
//  Created by formador on 13/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import MapKit

class BMBaresModel: NSObject, NSCoding {
    
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
    
    required convenience init?(coder aDecoder: NSCoder) {
        let direccionBaresaD = aDecoder.decodeObject(forKey: "direccionKey") as! String
        let latitudBaresaD = aDecoder.decodeObject(forKey: "latitudKey") as! Double
        let longitudBaresaD = aDecoder.decodeObject(forKey: "longitudKey") as! Double
        let imagenBaresaD = aDecoder.decodeObject(forKey: "imagenKey") as! String
        
        self.init(pDireccionBares : direccionBaresaD,
                  pLatitudBares : latitudBaresaD,
                  pLongitudBares : longitudBaresaD,
                  pImagenBares : imagenBaresaD)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(direccionBares, forKey: "direccionKey")
        aCoder.encode(latitudBares, forKey: "latitudKey")
        aCoder.encode(longitudBares, forKey: "longitudKey")
        aCoder.encode(imagenBares, forKey: "imagenKey")
    }
    
    
    
    
}

//MARK: - MKAnnotation
extension BMBaresModel : MKAnnotation{
    var coordinate: CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: latitudBares!, longitude: longitudBares!)
        }
    }
    var title: String? {
        get{
            return "Bar de Madrid"
        }
    }
    var subtitle: String? {
        get{
            return direccionBares?.replacingOccurrences(of: "\n", with: "")
        }
    }
}




