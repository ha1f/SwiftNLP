//
//  NlpUtil.swift
//  nlp100
//
//  Created by はるふ on 2016/04/21.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

extension String {
    func characterAtIndex(index: Int) -> Character {
        return self[self.startIndex.advancedBy(index)]
    }
    
    func substringTo(index: Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    
    func substringWith(start: Int, _ end: Int) -> String {
        let startIndex = self.startIndex.advancedBy(start)
        let endIndex = startIndex.advancedBy(end-start)
        return substringWithRange(startIndex..<endIndex)
    }
    
    func createReversedString(string: String) -> String {
        return String(string.characters.reverse())
    }
}

class NlpUtil {
    static func createNGram<T>(n: Int, sequence: [T]) {
        
    }
}
