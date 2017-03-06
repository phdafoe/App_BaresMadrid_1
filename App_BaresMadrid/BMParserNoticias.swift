//
//  BMParserNoticias.swift
//  App_BaresMadrid
//
//  Created by formador on 6/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire

class BMParserNoticias: NSObject {

    var jsonDataNoticias : JSON?
    
    func getDatosNoticias() -> Promise<JSON>{
        let request = NSMutableURLRequest(url: URL(string: CONSTANTES.CONEXIONES_URL.BASE_URL_NOTICIAS)!)
        return Alamofire.request(request as URLRequest).responseJSON().then{(data) -> JSON in
            self.jsonDataNoticias = JSON(data)
            print(self.jsonDataNoticias!)
            return self.jsonDataNoticias!
        }
    }
    
    func getParserNoticias() -> [BMNoticiasModel]{
        var arrayNoticiasModel = [BMNoticiasModel]()
        for item in 0..<jsonDataNoticias!.count{
            let noticiasModel = BMNoticiasModel(pAlbumId: dimeInt(jsonDataNoticias![item], nombre: "albumId"),
                                                pId: dimeInt(jsonDataNoticias![item], nombre: "id"),
                                                pTitle: dimeString(jsonDataNoticias![item], nombre: "title"),
                                                pUrl: dimeString(jsonDataNoticias![item], nombre: "url"),
                                                pThumbnailUrl: dimeString(jsonDataNoticias![item], nombre: "thumbnailUrl"))
            arrayNoticiasModel.append(noticiasModel)
        }
        return arrayNoticiasModel
    }
    
    
    
    
}









