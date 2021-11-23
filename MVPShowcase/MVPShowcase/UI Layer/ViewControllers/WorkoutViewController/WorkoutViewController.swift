//
//  WorkoutViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutViewController: BaseViewController {
    
    var presenter: WorkoutPresenterProtocol!
    private var headerView: WorkoutTopHeaderView!
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: { [weak self] in
            self?.updateHeaderViewHeight(for: self?.tableView.tableHeaderView)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }
    
    private func commonInit() {
        self.prepareTableView()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        setupHeader()
    }
    
    private func setupHeader() {
        self.headerView = WorkoutTopHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.setData(programData: presenter.getCurrentProgramDataModel(),
                           workoutData: presenter.getSelectedWorkout(),
                           selectedDate: presenter.selectedDate)
        headerView.changeButtonStateTo(state: presenter.getWorkoutState())
        
        headerView.setPlayImageHidden()
        
        headerView.shouldUpdateHeaderHeightClosure = { [weak self] isAnimated in
            guard let sSelf = self else { return }
            if isAnimated {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.updateHeaderViewHeight(for: sSelf.tableView.tableHeaderView)
                }
            } else {
                sSelf.updateHeaderViewHeight(for: sSelf.tableView.tableHeaderView)
            }
        }
        
        headerView.btnCompleteIncompleteTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.presenter.btnCompleteTapped()
        }
        
        tableView.tableHeaderView = headerView
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        //        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: 0)).height
        //        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: UIView.layoutFittingExpandedSize.height),
        //                                              withHorizontalFittingPriority: .required,
        //                                              verticalFittingPriority: .fittingSizeLevel).height
        self.tableView.performBatchUpdates(nil)
    }
    
    private func prepareTableView() {
        self.registerCells()
//        self.registerHeaders()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        //        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tableView.backgroundColor = UIColor.tfWhite
        self.tableView.separatorStyle = .none
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton(withTintColor: UIColor.tfWhite)
        self.navigationController?.navigationBar.setNavigationBarTransparent()
    }
    
    // MARK: Register cells
    private func registerCells() {
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        self.tableView.register(WorkoutVCDefaultCell.self, forCellReuseIdentifier: WorkoutVCDefaultCell.reuseIdentifier)
    }
//
//    // MARK: Register headers
//    private func registerHeaders() {
//        self.tableView.register(ProgramOverviewDefaultHeader.self, forHeaderFooterViewReuseIdentifier: ProgramOverviewDefaultHeader.reuseIdentifier)
//    }
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
        //        self.view.addSubview(self.separatorView)
    }
    
    private func setupConstraints() {
        //        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            self.separatorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            //            self.separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            //            self.separatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            //            self.separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellName = presenter.getCellNameFor(indexPath: indexPath)
        switch cellName {
        case .emptyCell:
            return 16
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionName = presenter.getSectionNameFor(section: section)
//        guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ProgramOverviewDefaultHeader.reuseIdentifier) as? ProgramOverviewDefaultHeader else { return nil }
//        switch sectionName {
//        case .trailers:
//            header.setTitle(titleText: L.string("TRAILERS"))
//        case .meetYourCoach:
//            header.setTitle(titleText: L.string("MEET_YOUR_COACH"))
//        }
//        //        header.setData(dataModel: self.presenter.getSelectedCategory(), programCount: self.presenter.getProgramsCount())
//        //        header.contentView.backgroundColor = .brown
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //                let category = self.presenter.getCategories()[indexPath.row]
        let cellName = presenter.getCellNameFor(indexPath: indexPath)
        switch cellName {
        case .emptyCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = UIColor.tfWhite
            return cell
        case .overviewCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutVCDefaultCell.reuseIdentifier, for: indexPath) as? WorkoutVCDefaultCell else { return UITableViewCell() }
            cell.setData(titleText: L.string("OVERVIEW"), descriptionText: L.string("LEARN_MORE_ABOUT_WORKOUT"))
            cell.btnOverlayTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.presenter.overviewDidSelect()
            }
            return cell
        case .instructionalsCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutVCDefaultCell.reuseIdentifier, for: indexPath) as? WorkoutVCDefaultCell else { return UITableViewCell() }
            cell.setData(titleText: L.string("INSTRUCTIONALS"), descriptionText: L.string("SOME_INSTRUCTIONAL_VIDEOS_TO_HELP_YOU_OUR"))
            cell.btnOverlayTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.presenter.instructionalsDidSelect()
            }
            return cell
        case .followAllongCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutVCDefaultCell.reuseIdentifier, for: indexPath) as? WorkoutVCDefaultCell else { return UITableViewCell() }
            cell.setData(titleText: L.string("FOLLOW_ALLONG"), descriptionText: L.string("WATCH_AND_PRACTICE_YOUR_WORKOUT"))
            cell.btnOverlayTappedClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.presenter.followAlongDidSelect()
            }
            return cell
        }
    }
    
}

extension WorkoutViewController: WorkoutVCProtocol {
    
    func changeWorkoutState() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.headerView.changeButtonStateTo(state: sSelf.presenter.getWorkoutState())
        }
    }
    
}
