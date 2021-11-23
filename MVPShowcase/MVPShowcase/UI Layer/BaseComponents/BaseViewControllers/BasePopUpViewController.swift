//
//  BasePopUpViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class BasePopUpViewController: UIViewController {
    
    private var backgroundBlurView: UIVisualEffectView!
    
    required init(style: UIBlurEffect.Style, cornerRadius: CGFloat? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        let effect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: effect)
        self.backgroundBlurView = visualEffectView
        self.backgroundBlurView.alpha = 0.9
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    deinit {
        print("Was deinit -----> \(String(describing: type(of: self)))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addingViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addingViews() {
        self.view.addSubview(self.backgroundBlurView)
    }
    
    private func setupConstraints() {
        self.backgroundBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundBlurView.pinToView(view: self.view)
    }
    
}

