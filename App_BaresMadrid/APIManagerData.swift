//
//  APIManagerData.swift
//  App_BaresMadrid
//
//  Created by formador on 15/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class APIManagerData: NSObject {
    
    //SINGLETON
    static let shared = APIManagerData()
    
    var baresMadrid : [BMBaresModel] = []
    
    
    //MARK: - SALVAR DATOS
    func salvarDatos(){
        //URL en donde vamos guardar nuestro archivo exite????
        if let url = dataBaseUrl(){
            NSKeyedArchiver.archiveRootObject(baresMadrid, toFile: url.path)
        }else{
            print("Error guardando datos")
        }
    }
    
    //MARK: - CARGAR DATOS
    func cargarDatos(){
        if let customUrl = dataBaseUrl(), let datosSalvados = NSKeyedUnarchiver.unarchiveObject(withFile: customUrl.path) as? [BMBaresModel]{
                baresMadrid = datosSalvados
        }else{
            print("Error cargando datos")
        }
    }
    
    
    //MARK: - URL IMAGE
    func imagenUrl() -> URL?{
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let customUrl = URL(fileURLWithPath: documentDirectory)
            return customUrl
        }else{
            return nil
        }
    }
    
    
    //MARK: - URL
    func dataBaseUrl() -> URL? {
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let customUrl = URL(fileURLWithPath: documentDirectory)
            print("\(customUrl)")
            return customUrl.appendingPathComponent("baresMadrid.data")
            
        }else{
            return nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
