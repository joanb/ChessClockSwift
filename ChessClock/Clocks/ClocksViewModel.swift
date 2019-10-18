//
//  ClocksViewModel.swift
//  ChessClock
//
//  Created by joan barroso on 15/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import Foundation

struct ClocksViewModel: Equatable {
    let running: RunningState
    let topTime: Int
    let bottomTime: Int
    var topTimeText: String {
        return String(topTime)
    }
    var bottomTimeText: String {
        return String(bottomTime)
    }

    static func == (lhs: ClocksViewModel, rhs: ClocksViewModel) -> Bool {
        return (lhs.running == rhs.running &&
            lhs.topTime == rhs.topTime &&
            lhs.bottomTime == rhs.bottomTime)
    }
}

enum RunningState {
    case top
    case bottom
    case paused
    case reseted
    case resumed
    init(event: ClocksEvents) {
        switch event {
        case .topRunning:
            self = .top
        case .bottomRunning:
            self = .bottom
        case .restart:
            self = .reseted
        case .pause:
            self = .paused
        case .resume:
            self = .resumed
        }
    }
}
