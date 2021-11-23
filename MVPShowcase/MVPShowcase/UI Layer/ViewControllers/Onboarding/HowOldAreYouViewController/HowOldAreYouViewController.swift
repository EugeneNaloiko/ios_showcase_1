//
//  HowOldAreYouViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HowOldAreYouViewController: BaseViewController {
    
    var presenter: HowOldAreYouPresenterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let howOldContentView = HowOldContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("CONTINUE_STRING"), for: UIControl.State.normal)
        return btn
    }()
    
    private var btnNextBottomAnchor: NSLayoutConstraint?
    private var defaultBottomConstant: CGFloat = -30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefillInitialData()
        self.setupUI()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
        self.updateButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        if let navTitle = self.presenter.navigationTitle {
            self.setNavigationTitle(title: navTitle)
        }
        
        if self.presenter.isNavigationBarTransparent {
            self.navigationController?.navigationBar.setNavigationBarTransparent()
        }
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
        self.btnNext.setTitle(self.presenter.nextButtonTitle, for: UIControl.State.normal)
        if self.presenter.isLogoHidden {
            self.headerView.setLogoHidden()
        }
            
        self.headerView.setData(titleText: self.presenter.titleText,
                                descriptionText: self.presenter.descriptionText)
    }
    
    private func prefillInitialData() {
        guard let date = self.presenter.getBirthDate() else { return }
        let monthString = date.get(.month, ignoreCurrentTimeZone: true)
        let dayString = date.get(.day, ignoreCurrentTimeZone: true)
        let yearString = date.get(.year, ignoreCurrentTimeZone: true)
        
        self.howOldContentView.prefillDateFields(month: "\(monthString)".count == 1 ? "0\(monthString)" : "\(monthString)",
                                                 day: "\(dayString)".count == 1 ? "0\(dayString)" : "\(dayString)",
                                                 year: "\(yearString)")
        self.checkDate()
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.howOldContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.howOldContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnNextBottomAnchor = self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: defaultBottomConstant)
        self.btnNextBottomAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -20),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.howOldContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 30),
            self.howOldContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.howOldContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.howOldContentView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnNextTapped()
        }
        
        self.howOldContentView.editingChangedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.howOldContentView.hideErrorMessage()
            sSelf.checkDate()
        }
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            let keyboardOffset: CGFloat = 5
            sSelf.btnNextBottomAnchor?.constant = -(keyboardFrame.size.height + keyboardOffset)
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.btnNextBottomAnchor?.constant = sSelf.defaultBottomConstant
        }
    }
    
    private func checkDate() {
        if self.howOldContentView.isEnteredDataValid().isValid {
            let date = self.howOldContentView.isEnteredDataValid().date
            let dateString = date?.toString()
            self.presenter.setBirthDateTo(dateString: dateString)
        } else if let errorMessage = self.howOldContentView.isEnteredDataValid().errorMessage {
            self.howOldContentView.displayErrorMessage(text: errorMessage)
            self.presenter.setBirthDateTo(dateString: nil)
        } else {
            self.presenter.setBirthDateTo(dateString: nil)
        }
        self.updateButtonState()
    }
    
    private func updateButtonState() {
        if self.howOldContentView.isEnteredDataValid().isValid {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
}

extension HowOldAreYouViewController: HowOldAreYouVCProtocol {
    
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
    func popVC() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.navigationController?.popViewController(animated: true)
        }
    }
    
}
