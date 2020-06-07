//
//  UseDuckDuckGoViewController.swift
//  DuckDuckGo
//
//  Created by Mia Alexiou on 01/03/2017.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//

import UIKit

class UseDuckDuckGoViewController: UIViewController {
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    var descriptionLineHeight: CGFloat = 0
    private static let minimumTopMargin: CGFloat = 14
    private static let verticalOffset: CGFloat = 20

    private lazy var onboardingSettings = OnboardingSettings()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        descriptionText.adjustPlainTextLineHeight(descriptionLineHeight)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if onboardingSettings.instructionsFirstLaunch {
            disableDoneButtonForOneSecond()
            onboardingSettings.instructionsFirstLaunch = false
        }
    }
    
    private func disableDoneButtonForOneSecond() {
        doneButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.doneButton.isEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        applyTopMargin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x:0, y:max(0, scrollView.contentSize.height - self.view.frame.size.height)), animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    private func applyTopMargin() {
        let availableHeight = view.frame.size.height
        let contentHeight = scrollView.contentSize.height
        let excessHeight = availableHeight - contentHeight
        let marginForVerticalCentering = (excessHeight  / 2) - UseDuckDuckGoViewController.verticalOffset
        let minimumMargin = UseDuckDuckGoViewController.minimumTopMargin
        topMarginConstraint.constant = marginForVerticalCentering > minimumMargin ? marginForVerticalCentering : minimumMargin
    }
    
    @IBAction func onDonePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
