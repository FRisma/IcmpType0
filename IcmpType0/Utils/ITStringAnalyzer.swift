//
//  ITStringAnalyzer.swift
//  IcmpType0
//
//  Created by Franco Risma on 25/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class ITStringAnalyzer {
    
    static let kHttpsPrefix = "https://"
    static let kHttpPrefix = "http://"
    
    public class func urlArrayIn(string input: String) -> [URL] {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        var results: Array = [URL]()
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let stringURL = input[range]
            if let url = completeURL(fromString: String(stringURL)) {
                results.append(url)
            }
        }
        return results
    }
    
    private class func completeURL(fromString string: String) -> URL? {
        if string.lowercased().range(of:kHttpsPrefix) != nil || string.lowercased().range(of:kHttpPrefix) != nil  {
            return URL(string: string)
        } else {
            var fullURLString = kHttpsPrefix
            fullURLString += string
            return URL(string: fullURLString)
        }
    }
}
