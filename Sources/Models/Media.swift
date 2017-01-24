//
//  Media.swift
//  SwiftyPress
//
//  Created by Basem Emara on 1/23/17.
//
//

import Foundation
import RealmSwift
import JASON

public class Media: Object {
    
    public dynamic var link = ""
    public dynamic var width = 0
    public dynamic var height = 0
    public dynamic var thumbnailLink = ""
    public dynamic var thumbnailWidth = 0
    public dynamic var thumbnailHeight = 0
    
    public override static func primaryKey() -> String? {
        return "link"
    }
    
    public convenience init(json: JSON) {
        self.init()
        
        link = json[.link]
        width = json[.width]
        height = json[.height]
        thumbnailLink = json[.thumbnailLink]
        thumbnailWidth = json[.thumbnailWidth]
        thumbnailHeight = json[.thumbnailHeight]
    }
    
}
