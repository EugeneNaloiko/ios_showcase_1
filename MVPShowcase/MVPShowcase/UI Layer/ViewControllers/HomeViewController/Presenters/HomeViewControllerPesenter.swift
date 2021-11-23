//
//  HomeViewControllerPesenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

class HomeViewControllerPesenter: BasePresenter, HomeViewControllerPresenterProtocol {
    
    weak var view: HomeViewControllerProtocol!
    weak var appRouter: AppRouterProtocol!
    var homeRouter: HomeRouterProtocol!
    var networkManager: NetworkManagerProtocol!
    
    private var sections: [HomeViewControllerSection] = []
    
    private var dashboardInfo: DashboardInfoModel? {
        get {
            return StorageDataManager.shared.dashboardInfo
        }
        set {
            StorageDataManager.shared.dashboardInfo = newValue
        }
    }
    
    init(view: HomeViewControllerProtocol, appRouter: AppRouterProtocol, homeRouter: HomeRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.appRouter = appRouter
        self.homeRouter = homeRouter
        self.networkManager = networkManager
        self.setupSections()
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .NSCalendarDayChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getProfileImageFromServer), name: NSNotification.Name.profileImageDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHomeScreen), name: NSNotification.Name.dashboardInfoUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHomeScreen), name: NSNotification.Name.userProgramsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserFirstName), name: NSNotification.Name.userInfoUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateHomeScreen), name: NSNotification.Name.workoutExersiceProgressUpdated, object: nil)
        self.getAllMuseVideosInfo()
        self.getProfileImageFromServer()
    }
    
    @objc private func dayChanged() {
        GlobalUpdateService.shared.getDashboardInfo(completion: nil)
    }
    
    @objc private func updateUserFirstName() {
        self.view.updateUserFirstName(userFirstName: self.userInfoDetail()?.firstName ?? "")
    }
    
    @objc private func updateHomeScreen() {
        self.setupSections()
    }
    
    private func getAllMuseVideosInfo() {
        self.networkManager.getAllVideosFromMuse(completion: { allVideosInfo, _ in
            if let allVideosInfo = allVideosInfo {
                StorageDataManager.shared.updateAllMuseVideosInfo(allMuseVideos: allVideosInfo)
            } else {
                UIUtils.displayNetworkErrorBanner { [weak self] in
                    self?.getAllMuseVideosInfo()
                }
            }
        })
    }
    
    @objc private func getProfileImageFromServer() {
        self.view.startIndicatorOnProfileImageView()
        guard let profileImageId = StorageDataManager.shared.userDataModel?.profileImageId else {
            self.view.stopIndicatorOnProfileImageView()
            return
        }
        self.networkManager.getProfileImage(imageId: profileImageId, completion: { imageData, error in
            if let imageData = imageData {
                self.view.setProfileImage(imageData: imageData)
            }
            
            self.view.stopIndicatorOnProfileImageView()
        })
        
    }
    
    private func setupSections() {
        
        if self.getTodayPrograms().count > 0 {
            self.sections = [
                .todaySection(cells: [.todayCell]),
                .workoutCategoriesSection(cells: [.workoutCategoriesCell]),
                .trendingSection(cells: [.trendingSectionCell]),
                .recommendedTrainingSection(cells: [.recommendedTrainingSectionCell])
            ]
        } else if StorageDataManager.shared.isTodayRecoveryDay() {
            self.sections = [
                .todaySection(cells: [.todayCell]),
                .workoutCategoriesSection(cells: [.workoutCategoriesCell]),
                .trendingSection(cells: [.trendingSectionCell]),
                .recommendedTrainingSection(cells: [.recommendedTrainingSectionCell])
            ]
        } else {
            self.sections = [
                .welcomeSection,
                .workoutCategoriesSection(cells: [.workoutCategoriesCell]),
                .trendingSection(cells: [.trendingSectionCell]),
                .recommendedTrainingSection(cells: [.recommendedTrainingSectionCell])
            ]
        }
        
        self.view.reloadTableView()
    }
    
    func getNumberOfSections() -> Int {
        return sections.count
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        let currentSectionType = getCurrentSectionTypeFor(section: section)
        switch currentSectionType {
        case .welcomeSection:
            return 0
        case .todaySection(let cells):
            return cells.count
        case .workoutCategoriesSection(let cells):
            return cells.count
        case .trendingSection(let cells):
            return cells.count
        case .recommendedTrainingSection(let cells):
            return cells.count
        }
    }
    
    func getCurrentSectionTypeFor(section: Int) -> HomeViewControllerSection {
        return sections[section]
    }
    
    func userInfoDetail() -> UserProfileModel? {
        return StorageDataManager.shared.userDataModel?.profile
    }
    
    func getTodayPrograms() -> [ProgramDataModel] {
        let allTodayPrograms = self.dashboardInfo?.today ?? []
        let userPrograms = StorageDataManager.shared.userPrograms ?? []
        let currentDate = Date().toDateIgnoreAnyTimeZone()
        var todayProgramsNotPaused: [ProgramDataModel] = []
        
        for todayProgram in allTodayPrograms {
            for userProgram in userPrograms {
                if userProgram.programSku == todayProgram.sku {
                    if userProgram.pauseDate == nil {
                        let workouts = todayProgram.workouts
                        for workout in workouts {
                            if workout?.dateString.toDateIgnoreAnyTimeZone() == currentDate {
                                if workout?.id != nil {
                                    todayProgramsNotPaused.append(todayProgram)
                                }
                            }
                        }
                    }
                }
            }
        }
        return todayProgramsNotPaused
    }
    
    func getWorkoutCategoriesSectionDataModel() -> [WorkoutCategoriesDataModel] {
        return self.dashboardInfo?.workoutCategories ?? []
    }
    
    func getTrendingSectionDataModel() -> [TrendingModel] {
        return self.dashboardInfo?.trending ?? []
    }
    
    func getRecommendedTrainingSectionDataModel() -> [ProgramDataModel] {
        return self.dashboardInfo?.recommendedTraining ?? []
    }
    
    func btnStartProgramFromWelcomeViewTapped() {
        assertionFailure("STUB")
    }
    
    func btnGoToProfileTapped() {
        self.appRouter.switchToProfileTab()
    }
    
    func btnViewScheduleTapped() {
        self.appRouter.switchToScheduleTab()
    }
    
    func seeAllCategoriesTapped() {
        guard let categories = self.dashboardInfo?.workoutCategories else { return }
        self.homeRouter.showWorkoutCategoriesViewController(workoutCategories: categories)
    }
    
    func todayProgramDidSelect(selectedProgram: ProgramDataModel) {        
        assertionFailure("STUB")
    }
    
    func workoutCategoryDidSelect(selectedCategory: WorkoutCategoriesDataModel) {
        self.homeRouter.showWorkoutCategoriesProgramViewController(selectedCategory: selectedCategory)
    }
    
    func trendingProgramDidSelect(selectedTrending: TrendingModel) {
        guard let selectedProgram = selectedTrending.program else { return }
        self.homeRouter.showProgramOverviewViewController(selectedProgram: selectedProgram)
    }
    
    func recomendedTrainingProgramDidSelect(selectedProgram: ProgramDataModel) {
        self.homeRouter.showProgramOverviewViewController(selectedProgram: selectedProgram)
    }
    
    func btnSkipTodayTapped() {
        UIUtils.displaySkipTodayPopUp(imageName: "img_skip_today_calendar",
                                      titleText: L.string("ITS_OKAY_STRING"),
                                      messageText: L.string("WE_ALL_NEED_A_BREAK_SOMETIMES_WE_WILL_PUSH_TODAYS_SCHEDULE_TO_TOMORROW"),
                                      buttonContinueTitle: L.string("CONTINUE_STRING"),
                                      buttonCancelTitle: L.string("CANCEL_STRING"),
                                      btnContinueTappedCompletion: { [weak self] in
                                        self?.networkManager.skipToday(completion: { [weak self] error in
                                            if error == nil {
                                                self?.networkManager.getAllWorkoutExerciseProgress(completion: nil)
                                            }
                                        })
                                      },
                                      btnCancelTappedCompletion: nil)
    }
    
}
