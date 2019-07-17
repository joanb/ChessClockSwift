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
    let clocksStateBehaviourSubject = BehaviorSubject<ClocksEvents>(value: .bottomRunning)
    let disposeBag = DisposeBag()
    
    init(ui: ClockView) {
        self.ui = ui
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .debug("interval")
            .map { _ -> ClocksViewModel in return ClocksViewModel(running: .bottom, topTime: "5:00", bottomTime: "5:00") }
            .scan(nil, accumulator: { (previous, current) -> ClocksViewModel in
                switch current.running {
                case .top:
                    print("running top")
                case .bottom:
                    print("running bottom")
                case .none:
                    print("none")
                }
                return previous ?? ClocksViewModel(running: .bottom, topTime: "5:00", bottomTime: "5:00")
            })
            .distinctUntilChanged()
            .subscribe(onNext: { viewModel in
                ui.render(viewModel: viewModel!)
            }).disposed(by: disposeBag)
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
