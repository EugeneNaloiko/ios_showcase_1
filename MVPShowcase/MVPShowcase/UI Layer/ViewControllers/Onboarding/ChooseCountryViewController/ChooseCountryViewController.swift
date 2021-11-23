//
//  ChooseCountryViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import CountryPickerView

final class ChooseCountryViewController: BaseViewController {
    
    weak var loginRouter: LoginRouterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let chooseCountryContentView = ChooseCountryContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("CONTINUE_STRING"), for: UIControl.State.normal)
        return btn
    }()
    
    var userDataModel: UserInfoModel
    
    private let cpvInternal = CountryPickerView()
    
    init(loginRouter: LoginRouterProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init(nibName: nil, bundle: nil)
        self.loginRouter = loginRouter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.updateButtonState()
        
        cpvInternal.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        self.navigationController?.navigationBar.setNavigationBarTransparent()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
        
        self.headerView.setData(titleText: L.string("COUNTRY_OF_RESIDENCE"), descriptionText: L.string("THE_TERMS_AND_SERVICES_WHICH_YOU_APPLY_TO_YOU_DEPEND_ON_YOUR_COUNTRY"))
        if let countryCode = self.userDataModel.profile?.countryCode, let country = self.cpvInternal.getCountryByCode(countryCode) {
            self.chooseCountryContentView.setCountry(name: country.name)
            self.cpvInternal.setCountryByCode(countryCode)
        }
        
        self.updateButtonState()
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.chooseCountryContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.chooseCountryContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -20),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.chooseCountryContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 40),
            self.chooseCountryContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.chooseCountryContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.chooseCountryContentView.bottomAnchor.constraint(equalTo: self.btnNext.topAnchor, constant: -40),
        ])
        
    }
    
    private func updateButtonState() {
        if self.userDataModel.profile?.countryCode != nil {
            self.btnNext.isEnabled = true
        } else {
            self.btnNext.isEnabled = false
        }
    }
    
    private func subscribeClosures() {
        
        self.chooseCountryContentView.chooseCountryFieldTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.cpvInternal.showCountriesList(from: sSelf)
        }
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.loginRouter.showMaleOrFemaleScreen(userDataModel: sSelf.userDataModel)
        }
    }
    
}

extension ChooseCountryViewController: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.userDataModel.profile?.countryCode = country.code
        self.chooseCountryContentView.setCountry(name: country.name)
        self.updateButtonState()
    }
}
