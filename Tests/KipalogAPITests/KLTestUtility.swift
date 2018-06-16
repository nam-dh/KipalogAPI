//
//  KLTestUtility.swift
//  KipalogAPI
//
//  Created by Nam Doan on 2018/06/07.
//  Copyright © 2018年 Nam Doan. All rights reserved.
//

import Foundation

final class KLTestUtility {
    static func loadDataFromFile(_ fileName: String) -> Data? {
        guard let filePath = Bundle(for: self).path(forResource: fileName, ofType: nil) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            return data
        } catch {
            return nil
        }
    }
    
    static func loadJSONFromFile(_ fileName: String) -> JSONDictionary? {
        guard let data = loadDataFromFile(fileName) else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary
            return json
        } catch {
            return nil
        }
    }
    
}
