//
//  Utils.swift
//  MyInventory
//
//  Created by Ancel Dev account on 27/11/24.
//

import Foundation
import JSONCodable

func convertToData(_ anyCodableDict: [String:AnyCodable]) throws -> Data {
    let jsonCompatibleDict = anyCodableDict.mapValues { $0.value }
    return try JSONSerialization.data(withJSONObject: jsonCompatibleDict)
}
func convertToJsonString<T:Codable>(_ model: T) throws -> String {
    let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    let jsonData = try encoder.encode(model)
    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        throw NSError(domain: "JSONEncoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON data to string"])
    }
    return jsonString
}
