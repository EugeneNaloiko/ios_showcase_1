//
//  TfScoreViewTextField.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class TfScoreViewTextField: UITextField {
    
    var maxLength: Int? = nil
    
    var editingChangedClosure: ((_ newText: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        prepareUI()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    private func prepareUI() {
        self.textAlignment = .center
        self.font = UIFont.sfProFont(.bold, size: 24)
        self.textColor = UIColor.tfLightGray
        self.backgroundColor = UIColor.clear
        self.placeholder = "0"
        self.tintColor = UIColor.tfLightGray
        self.inputView = NumericKeyboard(target: self, useDecimalSeparator: true)
    }
    
    @objc func editingChanged() {
        if let text = self.text, let maxLength = self.maxLength {
            self.text = String(text.prefix(maxLength))
        }
        self.editingChangedClosure?(self.text ?? "")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
}


//MARK: - Custom keyboard
class DigitButton: UIButton {
    var digit: Int = 0
}

class NumericKeyboard: UIView {
    weak var target: UIKeyInput?
    var useDecimalSeparator: Bool
    
    var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
        return button
    }
    
    var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var decimalButton: UIButton = {
        let button = UIButton(type: .system)
        //        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        button.setTitle(/*decimalSeparator*/":", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "colon" //decimalSeparator
        button.addTarget(self, action: #selector(didTapDecimalButton(_:)), for: .touchUpInside)
        return button
    }()
    
    init(target: UIKeyInput, useDecimalSeparator: Bool = false) {
        self.target = target
        self.useDecimalSeparator = useDecimalSeparator
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NumericKeyboard {
    @objc func didTapDigitButton(_ sender: DigitButton) {
        target?.insertText("\(sender.digit)")
    }
    
    @objc func didTapDecimalButton(_ sender: DigitButton) {
        //        target?.insertText(Locale.current.decimalSeparator ?? ".")
        target?.insertText(":")
    }
    
    @objc func didTapDeleteButton(_ sender: DigitButton) {
        target?.deleteBackward()
    }
}

// MARK: - Private initial configuration methods

private extension NumericKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }
    
    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            
            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }
        
        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        
        if useDecimalSeparator {
            subStackView.addArrangedSubview(decimalButton)
        } else {
            let blank = UIView()
            blank.layer.borderWidth = 0.5
            blank.layer.borderColor = UIColor.darkGray.cgColor
            subStackView.addArrangedSubview(blank)
        }
        
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}


