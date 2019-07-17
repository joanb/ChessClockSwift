//
//  ClocksViewModel.swift
//  ChessClock
//
//  Created by joan barroso on 15/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import Foundation

struct ClocksViewModel: Equatable {
    let running: CurrentRunning
    let topTime: String
    let bottomTime: String

    static func == (lhs: ClocksViewModel, rhs: ClocksViewModel) -> Bool {
        return (lhs.running == rhs.running &&
            lhs.topTime == rhs.topTime &&
            lhs.bottomTime == rhs.bottomTime)
    }
}

enum CurrentRunning {
    case top
    case bottom
    case none
}
