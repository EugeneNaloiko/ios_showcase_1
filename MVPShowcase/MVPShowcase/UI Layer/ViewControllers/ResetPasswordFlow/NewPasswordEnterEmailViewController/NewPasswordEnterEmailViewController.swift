//
//  NewPasswordEnterEmailViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class NewPasswordEnterEmailViewController: BaseViewController {
    
    var presenter: NewPasswordEnterEmailPresenterProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    
    private let contentView: NewPasswordEnterEmailContentView = {
        let view = NewPasswordEnterEmailContentView()
        return view
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.isEnabled = false
        return btn
    }()
    
    private var bottomFieldY: CGFloat?
    private var viewHeight = UIScreen.main.bounds.height
    
    init(newPasswordRouter: NewPasswordRouterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.newPasswordRouter = newPasswordRouter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
        self.setupNavigationBar()
        
        #if DEBUG
        validateButtonState()
        #endif
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
        
    }
    
    private func setupUI() {
        extendedLayoutIncludesOpaqueBars = true
        self.view.backgroundColor = .tfWhite
        self.btnNext.setTitle(self.presenter.nextButtonTitle, for: UIControl.State.normal)
            
        self.contentView.setData(titleText: self.presenter.titleText,
                                 descriptionText: self.presenter.descriptionText,
                                 imageName: self.presenter.imageName)
        

    }
    
    private func addingViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    
    private func validateButtonState() {
        if self.contentView.email.isValidEmail() {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnNextTapped(email: sSelf.contentView.email)
        }
        
        self.contentView.emailFieldEditingChangedClosure = { [weak self] in
            self?.validateButtonState()
        }
        
        self.contentView.emailFieldDidBeginEditingClosure = { [weak self] fieldmaxY in
            guard let sSelf = self else { return }
            sSelf.bottomFieldY = sSelf.contentView.frame.origin.y + fieldmaxY
        }
        
        self.contentView.returnButtonTappedClosure = { [weak self] in
            self?.view.endEditing(true)
        }
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            
            let keyboardOffset: CGFloat = 5
            sSelf.viewHeight = sSelf.view.bounds.height
            guard sSelf.bottomFieldY != nil else { return }
            let bottomFieldYWithOffset = sSelf.bottomFieldY! + keyboardOffset
            
            let keyboardY = sSelf.viewHeight - keyboardFrame.size.height
            let offsetWhenKeyboardAppeared = bottomFieldYWithOffset - keyboardY
            
            if bottomFieldYWithOffset > keyboardY {
                sSelf.view.frame = CGRect(x: 0, y: -offsetWhenKeyboardAppeared, width: sSelf.view.bounds.width, height: sSelf.view.bounds.height)
            }
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
//            var viewFrameOriginY: CGFloat = 0
//            if sSelf.navigationController?.navigationBar.isTranslucent == false {
//                viewFrameOriginY = sSelf.navigationController?.navigationBar.frame.maxY ?? 0
//            }
            sSelf.view.frame = CGRect(x: 0, y: 0, width: sSelf.view.bounds.width, height: sSelf.viewHeight)
        }
        
    }
    
}

extension NewPasswordEnterEmailViewController: NewPasswordEnterEmailVCProtocol {
    
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
}

