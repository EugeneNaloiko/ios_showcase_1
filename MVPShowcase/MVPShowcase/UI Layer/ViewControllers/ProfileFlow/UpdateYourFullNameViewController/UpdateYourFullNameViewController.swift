//
//  UpdateYourFullNameViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class UpdateYourFullNameViewController: BaseViewController {
    
    var presenter: UpdateYourFullNamePresenterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let contentView = UpdateYourFullNameContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.updateButtonState()
        self.addGestureHideKeyboard()
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
        self.prefillInitialData()
    }
    
    private func prefillInitialData() {
        let fullName = self.presenter.getFullName()
        self.contentView.setInitialState(firstName: fullName.firstName, lastName: fullName.lastName)
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -10),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.contentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            self.contentView.bottomAnchor.constraint(lessThanOrEqualTo: self.btnNext.topAnchor, constant: -40),
        ])
        
    }
    
    private func subscribeClosures() {
        
        self.contentView.firstNameChangedClosure = { [weak self] newFirstName in
            self?.presenter.firstNameChangedTo(newFirstName: newFirstName)
            self?.updateButtonState()
        }
        
        self.contentView.lastNameChangedClosure = { [weak self] newLastName in
            self?.presenter.lastNameChangedTo(newLastName: newLastName)
            self?.updateButtonState()
        }
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnNextTapped()
        }
    }
    
    private func updateButtonState() {
        let fullName = self.presenter.getFullName()
        if fullName.firstName != "", fullName.lastName != "" {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
}

extension UpdateYourFullNameViewController: UpdateYourFullNameVCProtocol {
   
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
