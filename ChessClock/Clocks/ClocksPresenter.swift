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
    
    let view: ClockView!
    let clocksStateBehaviourSubject = BehaviorSubject<ClocksEvents>(value: .pause)
    let disposeBag = DisposeBag()
    
    init(view: ClockView) {
        self.view = view
        Observable<ClocksViewModel?>.concat(
            Observable.just(ClocksViewModel(running: CurrentRunning.none, topTime: "500", bottomTime: "500")),
            Observable.merge(
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in nil },
                clocksStateBehaviourSubject.asObservable()
                    .map { event -> ClocksViewModel in
                        let running: CurrentRunning = {
                            switch event {
                            case .bottomRunning:
                                return .bottom
                            case .topRunning:
                                return .top
                            case .pause:
                                return .none
                            case .restart:
                                return .none
                            }
                        }()
                        return ClocksViewModel(running: running, topTime: "500", bottomTime: "500")
                }
            )
            )
            
            .debug("interval")
            .scan(nil, accumulator: { (previous, current) -> ClocksViewModel in
                guard previous != nil else { return current! }
                var top = previous!.topTime
                var bottom = previous!.bottomTime
                switch current?.running ?? previous!.running {
                case .top:
                    var toInt = Int(top)!
                    toInt -= 1
                    top = String(toInt)
                case .bottom:
                    var toInt = Int(bottom)!
                    toInt -= 1
                    bottom = String(toInt)
                case .none:
                    print("none")
                }
                return ClocksViewModel(running: current?.running ?? previous!.running, topTime: top, bottomTime: bottom)
            })
            .distinctUntilChanged()
            .subscribe(onNext: { viewModel in
                view.render(viewModel: viewModel!)
            }).disposed(by: disposeBag)
    }
}

protocol ClockView {
    func render(viewModel: ClocksViewModel)
}
