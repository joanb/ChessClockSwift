//
//  ViewController.swift
//  ChessClock
//
//  Created by joan barroso on 13/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topChrono: UILabel!
    @IBOutlet weak var bottomChrono: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
    }

    
    private func customize() {
        topChrono.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}

