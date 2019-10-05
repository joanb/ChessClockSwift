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
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetButtonTrailingConstraint: NSLayoutConstraint!

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
        neededToHide(true)
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        presenter.clocksStateBehaviourSubject.onNext(ClocksEvents.restart)
        neededToHide(false)
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

// MARK: - Extension to manage UI showing

extension ViewController {
    
    private func neededToHide(_ trigger: Bool) {
        
        let viewsToHide = [topChrono, bottomChrono, topClockButton, bottomClockButton, pauseButton]
        for view in viewsToHide {
            view?.isHidden = trigger
        }
        
        resetButtonAnimation(trigger)
    }
    
    private func resetButtonAnimation(_ trigger: Bool) {
        
        if trigger {
            resetButtonTrailingConstraint.constant = (view.frame.width / 2) - (resetButton.frame.width / 2)
        } else {
            resetButtonTrailingConstraint.constant = 106
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
