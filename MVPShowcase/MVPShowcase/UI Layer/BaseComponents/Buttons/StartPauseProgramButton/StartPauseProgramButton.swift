//
//  StartPauseProgramButton.swift
//
//  Created by Eugene Naloiko
//

import UIKit

final class StartPauseProgramButton: UIButton {
    
    private var style: StartPauseProgramButtonState = .start
    
    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    private let heightDefaultValue: CGFloat = 40
    private let widthDefaultValue: CGFloat = 153
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: .tfOrangish, size: .small)
    
    private var height: CGFloat {
        set {
            self.heightConstraint.constant = newValue
        }
        
        get {
            return self.heightConstraint.constant
        }
    }
    
    var didTapClosure: (() -> Void)?
    
    private var text = ""
    
    override var isEnabled: Bool {
        didSet {
            self.setStyle(style: self.style)
        }
    }
    
    required init(style: StartPauseProgramButtonState) {
        self.style = style
        super.init(frame: .zero)
        self.commonInit()
        self.setupConstraints()
        self.setStyle(style: self.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 2
    }
    
    private func commonInit() {
        self.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView?.contentMode = .scaleAspectFill
        
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: heightDefaultValue)
        self.heightConstraint.isActive = true
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        }
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func setStyle(style: StartPauseProgramButtonState) {
        self.style = style
        
        titleLabel?.font = style.settings.font
        self.setTitle(style.settings.titleText, for: UIControl.State.normal)
        
        switch self.isEnabled {
        case true:
            self.backgroundColor = self.style.settings.backgroundColorEnableState
            self.setTitleColor(self.style.settings.fontColorEnabledState, for: .normal)
            if let imageName = self.style.settings.imageNameEnabledState {
                self.setImage(UIImage(named: imageName), for: UIControl.State.normal)
            }
            
            if let borderWidth = self.style.settings.borderWidthEnabledState {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = self.style.settings.borderColorEnabledState
            }
        case false:
            self.backgroundColor = self.style.settings.backgroundColorDisabledState
            self.setTitleColor(self.style.settings.fontColorDisabledState, for: .normal)
            if let imageName = self.style.settings.imageNameDisabledState {
                self.setImage(UIImage(named: imageName), for: UIControl.State.normal)
            }
            
            if let borderWidth = self.style.settings.borderWidthDisabledState {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = self.style.settings.borderColorDisabledState
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
                self?.alpha = 0.75
                self?.titleLabel?.alpha = 0.5
            }, completion: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.didTapClosure?()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
                self?.alpha = 1
                self?.titleLabel?.alpha = 1
            })
        }
    }
    
    func startIndicator() {
        self.isEnabled = false
        self.activityIndicator.start(onView: self)
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.isEnabled = true
            sSelf.activityIndicator.stop(completion: {
            })
        }
    }
    
}

