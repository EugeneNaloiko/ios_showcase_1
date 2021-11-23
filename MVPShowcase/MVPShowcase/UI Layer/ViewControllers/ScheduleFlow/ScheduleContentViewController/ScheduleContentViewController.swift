//
//  ScheduleContentViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ScheduleContentViewController: BaseViewController {
    
    var presenter: ScheduleContentVCPresenterProtocol!
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var seeRelatedVideosViewTappedClosure: ((WorkoutDataModel, ProgramDataModel) -> Void)?
    var seeWorkoutInProgramClosure: ((WorkoutDataModel, ProgramDataModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTableView()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureToMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewWillApear()
    }
    
    private func prepareTableView() {
        self.registerCells()
        self.registerHeaders()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        
        self.tableView.sectionFooterHeight = 0
        
        self.tableView.rowHeight = 0
        
        self.tableView.backgroundColor = UIColor.tfWhite
        
        self.tableView.separatorStyle = .none
    }
    
    // MARK: Register cells
    private func registerCells() {
        self.tableView.register(ActiveProgramCell.self, forCellReuseIdentifier: ActiveProgramCell.reuseIdentifier)
        self.tableView.register(CompletedProgramCell.self, forCellReuseIdentifier: CompletedProgramCell.reuseIdentifier)
    }
    
    // MARK: Register headers
    private func registerHeaders() {
        self.tableView.register(ScheduleContentHeader.self, forHeaderFooterViewReuseIdentifier: ScheduleContentHeader.reuseIdentifier)
    }
    
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func subscribeClosures() {
        
    }
    
    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func selectedDateChangedTo(date: Date) {
        self.presenter.selectedDate = date
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func addGestureToMainView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.contentViewGestureTapped(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func contentViewGestureTapped(_ sender: UIViewController) {
        NotificationCenter.default.post(name: .hideWorkoutOverlayView, object: self)
    }
    
}

extension ScheduleContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRows(for: section)
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
        case .completedWorkouts:
            guard self.presenter.getNumberOfRows(for: 0) > 0 else { return nil }
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleContentHeader.reuseIdentifier) as? ScheduleContentHeader else { return nil }
            header.setData(titleText: L.string("COMPLETED"))
            return header
        case .activePrograms:
            guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleContentHeader.reuseIdentifier) as? ScheduleContentHeader else { return nil }
            header.setData(titleText: L.string("ACTIVE_PROGRAMS"))
            return header
        case .none:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currentSectionType = presenter.getCurrentSectionTypeFor(section: indexPath.section) else { return UITableViewCell() }
        switch currentSectionType {
        case .completedWorkouts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedProgramCell.reuseIdentifier, for: indexPath) as? CompletedProgramCell else { return UITableViewCell() }
            if let completedWorkoutDataModel = self.presenter.getDataModelForCompletedWorkoutsSection(indexPath: indexPath) {
                cell.setData(dataModel: completedWorkoutDataModel, selectedDate: self.presenter.selectedDate)
                
                cell.markAsIncompleteTappedClosure = { [weak self] in
                    self?.presenter.performMarkAsIncompleteAction(dataModel: completedWorkoutDataModel)
                }
                
                cell.seeRelatedVideosViewTappedClosure = { [weak self] in
                    guard let program = completedWorkoutDataModel.program else { return }
                    guard let workout = completedWorkoutDataModel.workout else { return }
                    self?.seeRelatedVideosViewTappedClosure?(workout, program)
                }
            }
            
            return cell
        case .activePrograms:
            let cell = tableView.dequeueReusableCell(withIdentifier:ActiveProgramCell.reuseIdentifier, for: indexPath) as! ActiveProgramCell
            if let activeProgramDataModel = self.presenter.getDataModelForActiveProgramSection(indexPath: indexPath) {
                cell.setData(programDataModel: activeProgramDataModel, selectedDate: self.presenter.selectedDate, indexPath: indexPath)
                
                cell.seeRelatedVideosViewTappedClosure = { [weak self] workout in
                    self?.seeRelatedVideosViewTappedClosure?(workout, activeProgramDataModel)
                }
                
                cell.scrolledToItem = { _ in
                }
                
                cell.markAsCompleteTappedClosure = { [weak self] workoutData in
                    self?.presenter.performMarkAsCompleteAction(
                        program: activeProgramDataModel,
                        workout: workoutData)
                }
                
                cell.moveToTodayActionClosure = { [weak self] programSku, currentPosition in
                    self?.presenter.performMoveToTodayAction(programSku: programSku, currentPosition: currentPosition)
                }
                
                cell.moveToTomorrowActionClosure = { [weak self] programSku, currentPosition in
                    self?.presenter.performMoveToTomorrowAction(programSku: programSku, currentPosition: currentPosition)
                }
                
                cell.pickedItem = { [weak self] workout in
                    guard let sSelf = self else { return }
                    sSelf.seeWorkoutInProgramClosure?(workout, activeProgramDataModel)
                }
            }
            return cell
        }
    }
}

extension ScheduleContentViewController: ScheduleContentVCProtocol {
    
    func scrollToTheFirstRow() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToFirstRow(animated: true)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
