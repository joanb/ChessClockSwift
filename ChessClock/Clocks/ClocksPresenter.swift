//
//  ClocksPresenter.swift
//  ChessClock
//
//  Created by joan barroso on 14/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum states {
    case idle
    case running
}

enum ClocksEvents {
    case topRunning
    case bottomRunning
    case pause
    case restart
}

class ClocksPresenter {
    
    let ui: ClockView!
    let observable: Observable<ClocksViewModel>!
    let clocksStateBehaviourSubject: BehaviorSubject<ClocksEvents>
    
    init(ui: ClockView) {
        self.ui = ui
        self .clocksStateBehaviourSubject = BehaviorSubject<ClocksEvents>(value: ClocksEvents.pause)
        self.observable = Observable<ClocksViewModel>.create { observable in
            return Disposables.create()
            }.concat(clocksStateBehaviourSubject.asObservable())
            .scan { nil, accumulator: { previous, modifier -> ClocksViewModel in
                
            }.map { $0! }
}
    
    func onEvent(events: ClocksEvents) {
        switch events {
        case .topRunning:
            print("")
        default:
            print("")
        }
    }
}

protocol ClockView {
    func render(viewModel: ClocksViewModel)
}
