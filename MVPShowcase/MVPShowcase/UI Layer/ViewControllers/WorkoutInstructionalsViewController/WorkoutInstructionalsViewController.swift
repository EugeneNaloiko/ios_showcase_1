//
//  WorkoutInstructionalsViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutInstructionalsViewController: BaseViewController {
    
    var presenter: WorkoutInstructionalsPresenterProtocol!
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            self?.updateHeaderViewHeight(for: self?.tableView.tableHeaderView)
        })
    }
    
    private func commonInit() {
        self.prepareTableView()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
        setupHeader()
    }
    
    private func setupHeader() {
        let headerView = WorkoutInstructionalsTopHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        headerView.setData(workoutData: presenter.getSelectedWorkout())
        
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
        
        tableView.tableHeaderView = headerView
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: 0)).height
        self.tableView.performBatchUpdates(nil)
    }
    
    private func prepareTableView() {
        self.registerCells()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
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
        self.tableView.register(WorkoutInstructionalsCell.self, forCellReuseIdentifier: WorkoutInstructionalsCell.reuseIdentifier)
    }
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    fileprivate func displayVideoPlayer(videoInfoModel: AllMuseVideosModel) {
        let closure: (() -> Void)? = {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: { [weak self] in
                self?.updateHeaderViewHeight(for: self?.tableView.tableHeaderView)
            })
        }
        
        let vc = VideoPlayerViewController(videoInfoModel: videoInfoModel, backButtonTappedClosure: closure)
        self.present(vc, animated: true, completion: nil)
    }
}

extension WorkoutInstructionalsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutInstructionalsCell.reuseIdentifier, for: indexPath) as? WorkoutInstructionalsCell else { return UITableViewCell() }

        let cellInfo = presenter.getCellInfo(indexPath: indexPath)
        
        if let videoInfoModel = cellInfo.videoInfoModel {
            cell.setData(titleText: videoInfoModel.title ?? "-", descriptionText: videoInfoModel.durationInHoursMinutesSecondsString, thumbnail: cellInfo.thumbnail)
        } else {
            cell.setData(titleText: "-", descriptionText: "-", thumbnail: cellInfo.thumbnail)
        }

        cell.btnOverlayTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            if let videoInfoModel = cellInfo.videoInfoModel {
                sSelf.displayVideoPlayer(videoInfoModel: videoInfoModel)
            }
        }
        return cell
    }
    
}

extension WorkoutInstructionalsViewController: WorkoutInstructionalsVCProtocol {
    
}
