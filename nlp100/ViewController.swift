//
//  ViewController.swift
//  nlp100
//
//  Created by はるふ on 2016/04/19.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Nlp100.check()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

