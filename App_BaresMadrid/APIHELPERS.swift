//
//  APIHELPERS.swift
//  App_BaresMadrid
//
//  Created by formador on 6/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import SwiftyJSON


//MARK: - ALERT MESSAGE VC
func muestraAlertVC(_ titleData : String, messageData : String, titleActionData : String) -> UIAlertController{
    let alert = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: titleActionData, style: .default, handler: nil))
    return alert
}

//MARK: - NULL TO STRING
func dimeString(_ json : JSON, nombre : String) -> String{
    if let stringResult = json[nombre].string{
        return stringResult
    }else{
        return ""
    }
}


//MARK: - NULL TO INT
///Descripcion: parametro JSON que viene de la Promesa de un JSON Variable local en cada Parser
///Nombre: Como la definicion de la clave del JSON

func dimeInt(_ json : JSON, nombre : String) -> Int{
    if let intResult = json[nombre].int{
        return intResult
    }else{
        return 0
    }
}


//MARK: - NULL TO DOUBLE
func dimeDouble(_ json : JSON, nombre : String) -> Double{
    if let doubleResult = json[nombre].double{
        return doubleResult
    }else{
        return 0.0
    }
}


//MARK: - NULL TO FLOAT
func dimeFloat(_ json : JSON, nombre : String) -> Float{
    if let floatResult = json[nombre].float{
        return floatResult
    }else{
        return 0.0
    }
}




