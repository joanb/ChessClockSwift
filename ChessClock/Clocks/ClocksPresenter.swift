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

enum ClocksEvents {
    case topRunning
    case bottomRunning
    case pause
    case restart
    case resume
}

let kStartingTime = 500

class ClocksPresenter {

    let view: ClockView!
    let clocksStateBehaviourSubject = BehaviorSubject<ClocksEvents>(value: .pause)
    let disposeBag = DisposeBag()

    init(view: ClockView) {
        let startState = ClocksViewModel(running: .paused, topTime: kStartingTime, bottomTime: kStartingTime)
        self.view = view
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(clocksStateBehaviourSubject.asObservable())
            .map { event -> ClocksViewModel in
                let running = RunningState(event: event)
                return ClocksViewModel(running: running, topTime: kStartingTime, bottomTime: kStartingTime)
            }
            .startWith(startState)
            .scan(startState, accumulator: { (previous, current) -> ClocksViewModel in
                var currentRunning = current.running
                currentRunning = currentRunning == .resumed ? previous.running : currentRunning
                var top = previous.topTime
                var bottom = previous.bottomTime
                switch currentRunning {
                case .top:
                    top = top >= 1 ? top - 1 : 0
                case .bottom:
                    bottom = bottom >= 1 ? bottom - 1 : 0
                case .paused:
                    return previous
                case .reseted:
                    return ClocksViewModel(running: .reseted, topTime: kStartingTime, bottomTime: kStartingTime)
                case .resumed:
                    break
                }
                return ClocksViewModel(running: currentRunning, topTime: top, bottomTime: bottom)
            })
            .distinctUntilChanged()
            .debug("interval")
            .subscribe(onNext: { [weak view] viewModel in
                view?.render(viewModel: viewModel)
            }).disposed(by: disposeBag)
    }
}

protocol ClockView: class {
    func render(viewModel: ClocksViewModel)
}
