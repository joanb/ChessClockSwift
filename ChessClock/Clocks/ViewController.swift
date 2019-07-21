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
    @IBAction func PauseButtonPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.pause)
    }
}

extension ViewController: ClockView {
    func render(viewModel: ClocksViewModel) {
        topChrono.text = viewModel.topTime
        bottomChrono.text = viewModel.bottomTime
    }
}

private extension ViewController {

    private func customize() {
        topChrono.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}
