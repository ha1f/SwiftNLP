//
//  Nlp100.swift
//  nlp100
//
//  Created by はるふ on 2016/04/19.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

// reference: http://postd.cc/why-is-swifts-string-api-so-hard/

struct Util {
}

class Nlp100 {
    
    static func check() {
        q1()
        q2()
        q3()
    }
    
    static func q1() {
        let string = "stressed"
        let res = string.createReversedString
        print(res)
    }
    
    static func q2() {
        let string = "パタトクカシーー"
        let res = String(string.characters.enumerate().filter{ $0.index % 2 == 0 }.map{$0.element})
        print(res)
    }
    
    static func q3() {
        let s1 = "パトカー"
        let s2 = "タクシー"
        let res = zip(s1.characters, s2.characters).map{String($0) + String($1)}.joinWithSeparator("")
        print(res)
    }
}
