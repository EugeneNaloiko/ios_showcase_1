//
//  BaseButton.swift
//
//  Created by Eugene Naloiko
//

import UIKit

final class BaseButton: UIButton {
    
    private var style: BaseButtonStyle = .orange
    
    private var heightConstraint: NSLayoutConstraint!
    
    private let heightDefaultValue: CGFloat = 50
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: .clear, size: .small)
    
    var height: CGFloat {
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
    
    required init(style: BaseButtonStyle) {
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
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: heightDefaultValue)
        self.heightConstraint.isActive = true
    }
    
    func setStyle(style: BaseButtonStyle) {
        self.style = style
        
        titleLabel?.font = style.settings.font
        
        switch self.isEnabled {
        case true:
            self.backgroundColor = self.style.settings.backgroundColorEnableState
            self.setTitleColor(self.style.settings.fontColorEnableState, for: .normal)
            
            if let borderWidth = self.style.settings.borderWidthEnableState {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = self.style.settings.borderColorEnableState
            }
        case false:
            self.backgroundColor = self.style.settings.backgroundColorNotEnableState
            self.setTitleColor(self.style.settings.fontColorNotEnableState, for: .normal)
            
            if let borderWidth = self.style.settings.borderWidthDisabledState {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = self.style.settings.borderColorNotEnableState
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
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.text = sSelf.titleLabel?.text ?? ""
            sSelf.setTitle("", for: .normal)
            sSelf.activityIndicator.start(onView: sSelf)
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.activityIndicator.stop(completion: {
                DispatchQueue.main.async { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.setTitle(sSelf.text, for: .normal)
                }
            })
        }
    }
    
}
