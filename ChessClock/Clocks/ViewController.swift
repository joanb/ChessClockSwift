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
    @IBOutlet weak var bottomClockButton: UIButton!
    @IBOutlet weak var topClockButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var presenter: ClocksPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        self.presenter = ClocksPresenter(view: self)
    }
    @IBAction func topClockPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.bottomRunning)
    }
    @IBAction func bottomClockPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.topRunning)
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.pause)
        pauseState(turnOn: true)
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.restart)
        pauseState(turnOn: false)
    }
    @IBAction func resumeButtonPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.resume)
        pauseState(turnOn: false)
    }
}

extension ViewController: ClockView {
    func render(viewModel: ClocksViewModel) {
        topChrono.text = viewModel.topTime
        bottomChrono.text = viewModel.bottomTime
        
        switch viewModel.running {
        case .top:
            topClockButton.isEnabled = true
            bottomClockButton.isEnabled = false
        case .bottom:
            topClockButton.isEnabled = false
            bottomClockButton.isEnabled = true
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
        bottomClockButton.isEnabled = !trigger
        topClockButton.isEnabled = !trigger
        pauseButton.isEnabled = !trigger
    }
}
