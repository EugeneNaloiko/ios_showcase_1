//
//  HomeViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    private let userInfoView = HomeVCUserInfoView()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var presenter: HomeViewControllerPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.setupUI()
        self.prepareTableView()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.updateUserFirstName(userFirstName: presenter.userInfoDetail()?.firstName ?? "")
        self.userInfoView.setFirstNameAndLastName(firstName: presenter.userInfoDetail()?.firstName ?? "",
                                                  lastName: presenter.userInfoDetail()?.lastName ?? "")
        
        //        show_all_fonts()
    }
    
    //    func show_all_fonts() {
    //        UIFont.familyNames.forEach({ familyName in
    //            let fontNames = UIFont.fontNames(forFamilyName: familyName)
    //            print("show_all_fonts\n")
    //            print(familyName, fontNames)
    //        })
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        //        self.view.backgroundColor = .green
    }
    
    private func addingViews() {
        self.view.addSubview(self.userInfoView)
        self.view.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        self.userInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.userInfoView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.userInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.userInfoView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func prepareTableView() {
        self.registerCells()
        self.registerHeaders()
        
        tableView.backgroundColor = UIColor.tfWhite
        tableView.rowHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    // MARK: Register cells
    private func registerCells() {
        self.tableView.register(HomePageTodayCell.self, forCellReuseIdentifier: HomePageTodayCell.reuseIdentifier)
        self.tableView.register(HomePageTodayRecoveryDayCell.self, forCellReuseIdentifier: HomePageTodayRecoveryDayCell.reuseIdentifier)
        self.tableView.register(HomePageWorkoutCategoriesCell.self, forCellReuseIdentifier: HomePageWorkoutCategoriesCell.reuseIdentifier)
        self.tableView.register(HomePageTrendingCell.self, forCellReuseIdentifier: HomePageTrendingCell.reuseIdentifier)
        self.tableView.register(HomePageRecommendedTrainigCell.self, forCellReuseIdentifier: HomePageRecommendedTrainigCell.reuseIdentifier)
    }
    
    // MARK: Register headers
    private func registerHeaders() {
        self.tableView.register(HomeScreenWelcomeHeader.self, forHeaderFooterViewReuseIdentifier: HomeScreenWelcomeHeader.reuseIdentifier)
        self.tableView.register(HomeScreenHeaderWithRightLabel.self, forHeaderFooterViewReuseIdentifier: HomeScreenHeaderWithRightLabel.reuseIdentifier)
        self.tableView.register(HomeScreenHeaderWithArrow.self, forHeaderFooterViewReuseIdentifier: HomeScreenHeaderWithArrow.reuseIdentifier)
    }
    
    private func subscribeClosures() {
        self.userInfoView.btnGoToProfileTappedClosure = { [weak self] in
            self?.presenter.btnGoToProfileTapped()
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSectionType = presenter.getCurrentSectionTypeFor(section: section)
        switch currentSectionType {
        case .welcomeSection:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenWelcomeHeader.reuseIdentifier) as? HomeScreenWelcomeHeader else { return nil }
            header.btnNextTappedClosure = { [weak self] in
                self?.presenter.btnStartProgramFromWelcomeViewTapped()
            }
            return header
        case .todaySection:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderWithRightLabel.reuseIdentifier) as? HomeScreenHeaderWithRightLabel else { return nil }
            header.setData(titleText: L.string("TODAY"), descriptionText: L.string("SKIP_TODAY"))
            if StorageDataManager.shared.isTodayRecoveryDay() {
                header.setSkipButtonHidden()
            } else {
                header.setSkipButtonUnhidden()
            }
            
            header.btnSkipTappedClosure = { [weak self] in
                self?.presenter.btnSkipTodayTapped()
            }
            return header
        case .workoutCategoriesSection:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderWithArrow.reuseIdentifier) as? HomeScreenHeaderWithArrow else { return nil }
            header.setData(titleText: L.string("WORKOUT_CATEGORIES"))
            header.btnSeeAllTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.presenter.seeAllCategoriesTapped()
            }
            return header
        case .trendingSection:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderWithArrow.reuseIdentifier) as? HomeScreenHeaderWithArrow else { return nil }
            header.setData(titleText: L.string("TRENDING"))
            header.btnSeeAllTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
            }
            return header
        case .recommendedTrainingSection:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderWithArrow.reuseIdentifier) as? HomeScreenHeaderWithArrow else { return nil }
            header.setData(titleText: L.string("RECOMMENDED_TRAINING"))
            header.btnSeeAllTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSectionType = presenter.getCurrentSectionTypeFor(section: indexPath.section)
        
        switch currentSectionType {
        case .welcomeSection:
            return UITableViewCell()
        case .todaySection:
            let cell = self.configureTodaySectionCell(indexPath: indexPath)
            return cell
        case .workoutCategoriesSection:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomePageWorkoutCategoriesCell.reuseIdentifier, for: indexPath) as? HomePageWorkoutCategoriesCell else { return UITableViewCell() }
            cell.clearData()
            cell.setData(dataModel: presenter.getWorkoutCategoriesSectionDataModel())
            cell.btnNextTappedClosure = { [weak self] selectedCategory in
                guard let sSelf = self else { return }
                sSelf.presenter.workoutCategoryDidSelect(selectedCategory: selectedCategory)
            }
            return cell
            
        case .trendingSection:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomePageTrendingCell.reuseIdentifier, for: indexPath) as? HomePageTrendingCell else { return UITableViewCell() }
            cell.setData(dataModel: presenter.getTrendingSectionDataModel())
            cell.btnNextTappedClosure = { [weak self] selectedTrending in
                guard let sSelf = self else { return }
                sSelf.presenter.trendingProgramDidSelect(selectedTrending: selectedTrending)
            }
            return cell
            
        case .recommendedTrainingSection:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomePageRecommendedTrainigCell.reuseIdentifier, for: indexPath) as? HomePageRecommendedTrainigCell else { return UITableViewCell() }
            cell.setData(dataModel: presenter.getRecommendedTrainingSectionDataModel())
            cell.btnNextTappedClosure = { [weak self] selectedProgram in
                guard let sSelf = self else { return }
                sSelf.presenter.recomendedTrainingProgramDidSelect(selectedProgram: selectedProgram)
            }
            return cell
        }
        
    }
    
    fileprivate func configureTodaySectionCell(indexPath: IndexPath) -> UITableViewCell {
        if StorageDataManager.shared.isTodayRecoveryDay() {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomePageTodayRecoveryDayCell.reuseIdentifier, for: indexPath) as? HomePageTodayRecoveryDayCell else { return UITableViewCell() }
            cell.btnNextTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.presenter.btnViewScheduleTapped()
            }
            return cell
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: HomePageTodayCell.reuseIdentifier, for: indexPath) as? HomePageTodayCell else { return UITableViewCell() }
            cell.setData(dataModel: presenter.getTodayPrograms())
            cell.btnNextTappedClosure = { [weak self] selectedProgram in
                guard let sSelf = self else { return }
                sSelf.presenter.todayProgramDidSelect(selectedProgram: selectedProgram)
            }
            return cell
        }
    }
    
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func updateUserFirstName(userFirstName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userInfoView.updateUserFirstName(userFirstName: userFirstName)
            self?.userInfoView.setFirstNameAndLastName(firstName: self?.presenter.userInfoDetail()?.firstName ?? "",
                                                       lastName: self?.presenter.userInfoDetail()?.lastName ?? "")
        }
    }
    
    func startIndicatorOnProfileImageView() {
        userInfoView.startIndicator()
    }
    
    func stopIndicatorOnProfileImageView() {
        userInfoView.stopIndicator()
    }
    
    func setProfileImage(imageData: Data) {
        if let image = UIImage(data: imageData) {
            DispatchQueue.main.async { [weak self] in
                self?.userInfoView.setImage(image: image)
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}
