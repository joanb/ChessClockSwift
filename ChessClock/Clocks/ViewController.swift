//
//  ViewController.swift
//  ChessClock
//
//  Created by joan barroso on 13/07/2019.
//  Copyright © 2019 joan barroso. All rights reserved.
//

import RxCocoa
import RxSwift
import RxGesture
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topChrono: UILabel!
    @IBOutlet weak var bottomChrono: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var presenter: ClocksPresenter!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        self.presenter = ClocksPresenter(view: self)
        setupPauseStateObservers()
        setupClockEvent()
    }
    
    func setupClockEvent() {
        let startBottom = topChrono.rx.tapGesture()
            .when(.recognized)
            .map({ _ in ClocksEvents.bottomRunning })
            
        let startTop = bottomChrono.rx.tapGesture()
            .when(.recognized)
            .map({ _ in ClocksEvents.topRunning})
            
        let pause = pauseButton.rx.tap
            .map({ _ in ClocksEvents.pause })
            
        let restart = resetButton.rx.tap
            .map({ _ in ClocksEvents.restart })
            
        let resume = resumeButton.rx.tap
            .map({ _ in ClocksEvents.resume })
            
        Observable.merge(startTop, startBottom, pause, restart, resume)
            .bind(to: presenter.clocksStateBehaviourSubject)
            .disposed(by: disposeBag)
    }
    
    func setupPauseStateObservers() {
           let pauseOnTriggeer = pauseButton.rx.tap.map({ true })

           let pauseOffTrigger = Observable
               .merge(resumeButton.rx.tap.asObservable(), resetButton.rx.tap.asObservable())
               .map({ false })

           Observable.merge(pauseOnTriggeer, pauseOffTrigger)
               .subscribe(onNext: { [weak self] in
                   self?.pauseState(turnOn: $0)
               })
               .disposed(by: disposeBag)
       }
}

extension ViewController: ClockView {
    func render(viewModel: ClocksViewModel) {
        topChrono.text = viewModel.topTimeText
        bottomChrono.text = viewModel.bottomTimeText
        switch viewModel.running {
        case .top:
            topChrono.alpha = 1.0
            bottomChrono.alpha = 0.5
        case .bottom:
            topChrono.alpha = 0.5
            bottomChrono.alpha = 1.0
        default:
            break
        }
    }
}

private extension ViewController {

    private func customize() {
        topChrono.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}

// MARK: - Paused state UI setup extension

private extension ViewController {

    private func pauseState(turnOn trigger: Bool) {
        resetButton.isEnabled = trigger
        resumeButton.isEnabled = trigger
        topChrono.alpha = trigger ? 0.5 : 1.0
        topChrono.isUserInteractionEnabled = !trigger
        bottomChrono.alpha = trigger ? 0.5 : 1.0
        bottomChrono.isUserInteractionEnabled = !trigger
        pauseButton.isEnabled = !trigger
    }
}
