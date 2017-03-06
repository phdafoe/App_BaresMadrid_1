//
//  BMNoticiasModel.swift
//  App_BaresMadrid
//
//  Created by formador on 6/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class BMNoticiasModel: NSObject {
    
    var albumId : Int?
    var id : Int?
    var title : String?
    var url : String?
    var thumbnailUrl : String?
    
    init(pAlbumId : Int, pId : Int, pTitle : String, pUrl : String, pThumbnailUrl : String) {
        self.albumId = pAlbumId
        self.id = pId
        self.title = pTitle
        self.url = pUrl
        self.thumbnailUrl = pThumbnailUrl
        super.init()
    }

}
