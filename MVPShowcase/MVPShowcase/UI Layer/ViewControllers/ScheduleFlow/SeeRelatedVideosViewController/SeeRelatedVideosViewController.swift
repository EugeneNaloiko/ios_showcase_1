//
//  SeeRelatedVideosViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class SeeRelatedVideosViewController: BaseViewController {
    
    var presenter: SeeRelatedVideosPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var noRelatedVideosView = NoRelatedVideosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func commonInit() {
        self.view.backgroundColor = UIColor.tfWhite
        self.prepareTableView()
        self.setupNavigationBar()
        self.addingViews()
        self.setupConstraints()
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
        self.setNavigationBarBackArrowButton()
        self.setNavigationTitle(title: L.string("RELATED_VIDEOS"))
    }
    
    // MARK: Register cells
    private func registerCells() {
        self.tableView.register(SeeRelatedVideosCell.self, forCellReuseIdentifier: SeeRelatedVideosCell.reuseIdentifier)
    }
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.noRelatedVideosView)
    }
    
    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.noRelatedVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.noRelatedVideosView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70),
            self.noRelatedVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.noRelatedVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
    }
    
    private func displayVideoPlayer(videoInfoModel: AllMuseVideosModel) {
        let closure: (() -> Void)? = {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }
        
        let vc = VideoPlayerViewController(videoInfoModel: videoInfoModel, backButtonTappedClosure: closure)
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension SeeRelatedVideosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeeRelatedVideosCell.reuseIdentifier, for: indexPath) as! SeeRelatedVideosCell
        
        if let cellInfo = presenter.getVideosCellInfo(indexPath: indexPath) {
            cell.setData(title: presenter.getCellTitle(indexPath: indexPath),
                         descriptionText: cellInfo.durationInHoursMinutesSecondsString,
                         thumbnail: presenter.getCellThumbnail(indexPath: indexPath))
        }
        
        cell.setVideoTypes(videoTypes: presenter.getVideoTypes(indexPath: indexPath))
        
        cell.btnOverlayTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            if let videoInfoModel = sSelf.presenter.getVideosCellInfo(indexPath: indexPath) {
                sSelf.displayVideoPlayer(videoInfoModel: videoInfoModel)
            }
        }
        return cell
    }
    
}

extension SeeRelatedVideosViewController: SeeRelatedVideosVCProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayRelatedVideos() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.noRelatedVideosView.isHidden = true
            self?.tableView.isHidden = false
        }
    }
    
    func displayNoRelatedVideosView() {
        DispatchQueue.main.async { [weak self] in
            self?.noRelatedVideosView.isHidden = false
            self?.tableView.isHidden = true
        }
    }
    
}
