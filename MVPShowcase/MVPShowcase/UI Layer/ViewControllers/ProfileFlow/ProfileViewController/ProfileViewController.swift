//
//  ProfileViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import SDWebImage
import SafariServices

class ProfileViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var selectedImageInfo: [UIImagePickerController.InfoKey : Any]?
    
    var presenter: ProfilePresenterProtocol!
    
    private var updateProfileImageClosure: ((_ image: UIImage) -> Void)?
    private var updateProfileFullNameClosure: ((_ firstName: String, _ lastName: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func commonInit() {
        self.prepareTableView()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func prepareTableView() {
        self.registerCells()
        self.registerHeaders()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        self.tableView.backgroundColor = UIColor.tfWhite
        self.tableView.separatorStyle = .none
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: Register cells
    private func registerCells() {
        self.tableView.register(ProfileDefaultCell.self, forCellReuseIdentifier: ProfileDefaultCell.reuseIdentifier)
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
    }
    
    // MARK: Register headers
    private func registerHeaders() {
        self.tableView.register(ProfileTopHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileTopHeaderView.reuseIdentifier)
        self.tableView.register(ProfileDefaultHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileDefaultHeaderView.reuseIdentifier)
    }
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
//    func displayOptionMenu() {
//        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
//            self.promptImagePicker(withPickerType: .camera)
//        }
//        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
//            self.promptImagePicker(withPickerType: .photoLibrary)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        optionMenu.addAction(cameraAction)
//        optionMenu.addAction(photoLibraryAction)
//        optionMenu.addAction(cancelAction)
//        optionMenu.modalPresentationStyle = .overFullScreen
//        self.present(optionMenu, animated: true, completion: nil)
//    }
    
//    private func promptImagePicker(withPickerType pickerType: UIImagePickerController.SourceType) {
//        if UIImagePickerController.isSourceTypeAvailable(pickerType) {
//            let myPickerController = UIImagePickerController()
//            myPickerController.delegate = self
//            myPickerController.sourceType = pickerType
//            myPickerController.allowsEditing = (pickerType == .camera)
//            present(myPickerController, animated: true, completion: nil)
//        }
//    }
    
    private func setImagePickerImage(withInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
}

// MARK: UIImagePickerControllerDelegate

//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
//        self.updateProfileImageClosure?(info)
//        dismiss(animated: true, completion: nil)
//    }
//
//}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let sectionName = presenter.getSectionNameFor(section: indexPath.section)
        switch sectionName {
            case .legalSection(let cells):
                switch cells[indexPath.row] {
                case .emptyCell:
                    return 24
                default:
                    return UITableView.automaticDimension
                }
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = presenter.getSectionNameFor(section: section)
        
        switch sectionName {
        case .profileInfoSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileTopHeaderView.reuseIdentifier) as? ProfileTopHeaderView
            header?.hideCamera()
            header?.setTitle(titleText: L.string("PROFILE"))
            
            let dataModel = self.presenter.getUserDataModel()
            
            header?.setUserName(fullName: dataModel?.profile?.fullName ?? "-")
            
            header?.setEmail(email: dataModel?.email ?? "-")
            
            header?.setFirstNameAndLastName(firstName: dataModel?.profile?.firstName ?? "", lastName: dataModel?.profile?.lastName ?? "")
            
            self.updateProfileImageClosure = { image in
                DispatchQueue.main.async {
                    header?.setImage(image: image)
                }
            }
            
            self.updateProfileFullNameClosure = { firstName, lastName in
                DispatchQueue.main.async {
                    header?.setUserName(fullName: "\(firstName) \(lastName)")
                    header?.setFirstNameAndLastName(firstName: firstName,
                                                    lastName: lastName)
                }
            }
            
            return header
        case .settingsSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileDefaultHeaderView.reuseIdentifier) as? ProfileDefaultHeaderView
            header?.setTitle(titleText: L.string("SETTINGS_STRING"))
            return header
        case .legalSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileDefaultHeaderView.reuseIdentifier) as? ProfileDefaultHeaderView
            header?.setTitle(titleText: L.string("LEGAL_STRING"))
            return header
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = presenter.getSectionNameFor(section: indexPath.section)
        
        switch sectionName {
        case .profileInfoSection(let cells):
            switch cells[indexPath.row] {
            case .personalDetailsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                cell.setData(titleText: L.string("PERSONAL_DETAILS"), imageName: "img_edit_profile")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.personalDetailsTapped()
                }
                return cell
            case.myProgramCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 0, maskedCorners: [])
                cell.setData(titleText: L.string("MY_PROGRAMS"), imageName: "img_my_programs")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.myProgramCellTapped()
                }
                return cell
            case .myEquipmentsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
                cell.setData(titleText: L.string("MY_EQUIPMENTS"), imageName: "img_my_equipments")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.myEquipmentsTapped()
                }
                return cell
            }
            
        case .settingsSection(let cells):
            switch cells[indexPath.row] {
            case .pushNotificationCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                cell.setData(titleText: L.string("PUSH_NOTIFICATION"), imageName: "img_push_notification")
                return cell
            case.remindMeToExerciseCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 0, maskedCorners: [])
                cell.setData(titleText: L.string("REMIND_ME_TO_EXERCISE"), imageName: "img_clock")
                return cell
                
            case.changePasswordCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                cell.setData(titleText: L.string("CHANGE_PASSWORD"), imageName: "img_change_password")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.changePasswordCellTapped()
                }
                return cell
                
            case .aboutCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
                cell.setData(titleText: L.string("ABOUT"), imageName: "img_about")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.aboutTapped()
                }
                return cell
            }
        case .legalSection(let cells):

            switch cells[indexPath.row] {
            case .privacyPolicyCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                cell.setData(titleText: L.string("PRIVACY_POLICY"), imageName: "img_privacy_policy")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.privacyPolicyTapped()
                }
                return cell
            case.termAndConditionsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                                                   .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
                cell.setData(titleText: L.string("TERM_AND_CONDITIONS"), imageName: "img_terms_and_conditions")
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.termAndConditionsTapped()
                }
                return cell
                
            case.emptyCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else { return UITableViewCell() }
                cell.contentView.backgroundColor = UIColor.tfWhite
                return cell
                
            case .logoutCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDefaultCell.reuseIdentifier, for: indexPath) as! ProfileDefaultCell
                cell.makeCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                                                   .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
                cell.setData(titleText: L.string("LOG_OUT"), imageName: "img_log_out")
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.logoutTapped()
                }
                return cell
            }
        }
    }
    
}

extension ProfileViewController: ProfileViewProtocol {
    
    func openSafari(url: URL) {
        let config =  SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
    
    func updateProfileImage(image: UIImage) {
        self.updateProfileImageClosure?(image)
    }
    
    func updateFullName(firstName: String, lastName: String) {
        self.updateProfileFullNameClosure?(firstName, lastName)
    }
    
}
