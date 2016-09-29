//
//  Venues.swift
//  crowds_like_app
//
//  Created by Aldo Lugo on 9/29/16.
//  Copyright © 2016 Aldo Lugo. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Venues {
    func getLocations(term: String, completion:@escaping (_ result: JSON) -> ()){
        let newTerm = term.replacingOccurrences(of: " ", with: "+")
        Alamofire.request("http://107.170.118.82:3000/venues?limit=10&query=\(newTerm)").responseJSON { (response) in
            if let data = response.result.value {
                let locationsData = JSON(data)
                completion(locationsData["response"]["venues"])
            }
        }
    }
}
