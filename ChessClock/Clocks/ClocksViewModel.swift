//
//  ClocksViewModel.swift
//  ChessClock
//
//  Created by joan barroso on 15/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import Foundation

struct ClocksViewModel {
    let running: CurrentRunning
    let topTime: String
    let bottomTime: String
}

enum CurrentRunning {
    case top
    case bottom
    case none
}
