//
//  ConfirmDetailsViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import CountryPickerView

final class ConfirmDetailsViewController: BaseViewController {
    
    weak var loginRouter: LoginRouterProtocol!
    var networkManager: NetworkManagerProtocol!
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("SUBMIT"), for: UIControl.State.normal)
        return btn
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        //        sv.bounces = false
        return sv
    }()
    
    private let scrollableContentView = ConfirmDetailsScrollableContentView()
    
    //    private let selectedUserProfileModelToUpdate: UserProfileModel
    private var userDataModel: UserInfoModel
    
    init(loginRouter: LoginRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init(nibName: nil, bundle: nil)
        self.loginRouter = loginRouter
        self.networkManager = networkManager
        
        if let profile = self.userDataModel.profile {
            self.setupSelectedInfo(userProfileModelToUpdate: profile)
        }
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
        //test
        //        self.scrollView.backgroundColor = .red
        //        self.scrollableContentView.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollableContentView.headerViewTopAnchor?.constant = self.view.safeAreaInsets.top - 20
        self.scrollableContentView.contentViewBottomConstraint?.constant = -self.view.safeAreaInsets.bottom - 110
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        self.navigationController?.navigationBar.setNavigationBarTransparent()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
        self.scrollableContentView.setHeaderData(titleText: L.string("CONFIRM_DETAILS"),
                                                 descriptionText: L.string("LETS_MAKE_SURE_EVERYTHING_LOOKS_RIGHT_BEFORE_YOU_SUBMIT"))
    }
    
    private func addingViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(scrollableContentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollableContentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            scrollableContentView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            //            scrollableContentView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            scrollableContentView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            scrollableContentView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor),
            scrollableContentView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            scrollableContentView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
            
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            //            self.contentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 20),
            //            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            //            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            //            self.contentView.bottomAnchor.constraint(equalTo: self.btnNext.topAnchor, constant: -30),
        ])
        
    }
    
    private func setupSelectedInfo(userProfileModelToUpdate: UserProfileModel) {
        let countryInfo = CountryPickerView().getCountryByCode(userProfileModelToUpdate.countryCode!)
        
        self.scrollableContentView.setupCountryViewDetails(countryName: countryInfo?.name ?? "-")
        
        self.scrollableContentView.setupGenderViewDetails(detailsItems: [userProfileModelToUpdate.sex?.title ?? "-"])
        
        let convertedDate = userProfileModelToUpdate.birthDate?.toDateIgnoreAnyTimeZone()
        self.scrollableContentView.setupDateOfBirthViewDetails(detailsItems: [convertedDate?.toString(dateFormat: "yyyy-MM-dd") ?? "-"])
        self.scrollableContentView.setupFitnessLevelViewDetails(detailsItems: [userProfileModelToUpdate.currentFitnessLevel?.title ?? "-"])
        
        guard let equipments = userProfileModelToUpdate.fitnessEquipment else { return }
        var detailsArray: [String] = []
        equipments.forEach({
            detailsArray.append($0.equipmentName)
        })
        
        self.scrollableContentView.setupEquipmentsViewDetails(detailsItems: detailsArray)
    }
    
    private func subscribeClosures() {
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.sendRequestToUpdateProfile()
        }
        
        self.scrollableContentView.btnEditTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.loginRouter.popToMaleOrFemaleScreen(userDataModel: sSelf.userDataModel)
        }
    }
    
    private func sendRequestToUpdateProfile() {
        guard let profile = self.userDataModel.profile else { return }
        
        var modelForUpdateProfile = UserProfileModel()
        modelForUpdateProfile.countryCode = profile.countryCode
        modelForUpdateProfile.sex = profile.sex
        modelForUpdateProfile.birthDate = profile.birthDate
        modelForUpdateProfile.currentFitnessLevel = profile.currentFitnessLevel
        modelForUpdateProfile.fitnessEquipment = profile.fitnessEquipment
        
        self.btnNext.startIndicator()
        self.networkManager.updateUserProfile(profile: modelForUpdateProfile,
                                              completion: { [weak self] userUpdatedModel, errorR in
                                                guard let sSelf = self else { return }
                                                DispatchQueue.main.async {
                                                    sSelf.btnNext.stopIndicator()
                                                    if let userUpdatedModel = userUpdatedModel {
                                                        sSelf.goToNextScreen(userDataModel: userUpdatedModel)
                                                    } else {
                                                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: sSelf.sendRequestToUpdateProfile)
                                                    }
                                                }
                                              })
    }
    
    private func goToNextScreen(userDataModel: UserInfoModel) {
//        assert(Thread.isMainThread, "Please initiate navigation to Next Screen from main thread only")
        self.loginRouter.showAwesomeScreen(userDataModel: userDataModel)
    }
}
