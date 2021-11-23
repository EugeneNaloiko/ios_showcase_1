//
//  HowOldContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HowOldContentView: UIView {
    
    private let monthView: HowOldAreYouLabelWithFieldView = {
        let view = HowOldAreYouLabelWithFieldView(minValue: 1, maxValue: 12)
        view.setTitle(L.string("MONTH_STRING").uppercased())
        view.setPlaceholder(L.string("MM"))
        view.setTextFieldmaxLength(2)
        return view
    }()
    
    private let dayView: HowOldAreYouLabelWithFieldView = {
        let view = HowOldAreYouLabelWithFieldView(minValue: 1, maxValue: 31)
        view.setTitle(L.string("DAY_STRING").uppercased())
        view.setPlaceholder(L.string("DD"))
        view.setTextFieldmaxLength(2)
        return view
    }()
    
    private let yearView: HowOldAreYouLabelWithFieldView = {
        let view = HowOldAreYouLabelWithFieldView(minValue: Calendar.current.component(.year, from: Date()) - 120,
                                                  maxValue: Calendar.current.component(.year, from: Date()))
        view.setTitle(L.string("YEAR_STRING").uppercased())
        view.setPlaceholder(L.string("YYYY"))
        view.setTextFieldmaxLength(4)
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 15
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let lblError: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfCoral
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private var lblErrroWidthConstraint: NSLayoutConstraint?
    
    var editingChangedClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblErrroWidthConstraint?.constant = self.stackView.bounds.width + 30
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        stackView.addArrangedSubview(monthView)
        stackView.addArrangedSubview(dayView)
        stackView.addArrangedSubview(yearView)
        
        self.addSubview(stackView)
        self.addSubview(lblError)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        lblError.translatesAutoresizingMaskIntoConstraints = false
        
        self.lblErrroWidthConstraint = self.lblError.widthAnchor.constraint(equalToConstant: 0)
        self.lblErrroWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.lblError.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.lblError.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor)
        ])
        
    }
    
    private func subscribeClosures() {
        
        self.monthView.editingChangedClosure = { [weak self] newMonth in
            guard let sSelf = self else { return }
            if newMonth.count == sSelf.monthView.getTextFieldMaxLength() {
                sSelf.dayView.setFocusToField()
            }
            sSelf.editingChangedClosure?()
        }
        
        self.dayView.editingChangedClosure = { [weak self] newDay in
            guard let sSelf = self else { return }
            if newDay.count == sSelf.dayView.getTextFieldMaxLength() {
                sSelf.yearView.setFocusToField()
            }
            sSelf.editingChangedClosure?()
        }
        
        self.yearView.editingChangedClosure = { [weak self] newYear in
            self?.editingChangedClosure?()
        }
        
    }
    
    func isEnteredDataValid() -> (isValid: Bool, date: Date?, errorMessage: String?) {
        let todayDate = Date()
        if let yearStr = self.yearView.textField.text, yearStr.count == self.yearView.textField.maxLength, let enteredYear = Int(yearStr) {
            if let monthStr = self.monthView.textField.text, let enteredMonth = Int(monthStr), enteredMonth > 0, enteredMonth <= 12 {
                if let dayStr = self.dayView.textField.text, let enteredDay = Int(dayStr), enteredDay > 0, enteredDay <= 31 {
                    if isEnteredYearCorrect(enteredYear: enteredYear) {
                        if Platform.isValidDate(month: enteredMonth, day: enteredDay, year: enteredYear).isValid,
                           let date = Platform.isValidDate(month: enteredMonth, day: enteredDay, year: enteredYear).date {
                            if date < todayDate {
                                let age = date.getCurrentAge()
                                if age >= 13 {
                                    return (true, date, nil)
                                } else {
                                    return (false, nil, L.string("YOU_MUST_BE_AT_LEAST_13_YEARS_OF_AGE"))
                                }
                            }
                        }
                    }
                }
            }
        }
        return (false, nil, nil)
    }
    
    private func isEnteredYearCorrect(enteredYear: Int) -> Bool {
        let minYear = Calendar.current.component(.year, from: Date()) - 100
        let maxYear = Calendar.current.component(.year, from: Date())
        
        if (enteredYear >= minYear), (enteredYear <= maxYear) {
            return true
        }
        
        return false
    }
    
    func setFocusToMonthField() {
        self.monthView.setFocusToField()
    }
    
    func setFocusToDayField() {
        self.dayView.setFocusToField()
    }
    
    func setFocusToYearField() {
        self.yearView.setFocusToField()
    }
    
    func prefillDateFields(month: String, day: String, year: String) {
        self.monthView.setTextFieldText(text: month)
        self.dayView.setTextFieldText(text: day)
        self.yearView.setTextFieldText(text: year)
    }
    
    func displayErrorMessage(text: String) {
        self.lblError.text = text
        self.lblError.isHidden = false
    }
    
    func hideErrorMessage() {
        self.lblError.text = ""
        self.lblError.isHidden = true
    }
    
}
