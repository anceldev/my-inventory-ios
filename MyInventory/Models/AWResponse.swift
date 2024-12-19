//
//  ErrorResponse.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import Foundation

struct AWResponse: Decodable {
    var message: String
    var type: String
    var code: Int
}
