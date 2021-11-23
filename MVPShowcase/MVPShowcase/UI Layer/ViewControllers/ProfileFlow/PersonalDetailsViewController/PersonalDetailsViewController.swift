//
//  PersonalDetailsViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import CountryPickerView

class PersonalDetailsViewController: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var selectedImageInfo: [UIImagePickerController.InfoKey : Any]?
    
    var presenter: PersonalDetailsPresenterProtocol!
    
    private let cpvInternal = CountryPickerView()
    
    private var updateProfileImageClosure: ((_ image: UIImage) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func commonInit() {
        self.prepareTableView()
        self.addingViews()
        self.setupConstraints()
        self.setupNavigationBar()
        cpvInternal.delegate = self
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        self.setNavigationTitle(title: L.string("PERSONAL_DETAILS"))
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
        
        self.tableView.register(PersonalDetailsDefaultCell.self, forCellReuseIdentifier: PersonalDetailsDefaultCell.reuseIdentifier)
        self.tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
    }
    
    // MARK: Register headers
    private func registerHeaders() {
        self.tableView.register(PersonalDetailsProfileImageHeader.self, forHeaderFooterViewReuseIdentifier: PersonalDetailsProfileImageHeader.reuseIdentifier)
        
        self.tableView.register(PersonalDetailsDefaultHeader.self, forHeaderFooterViewReuseIdentifier: PersonalDetailsDefaultHeader.reuseIdentifier)
        
        //===
        self.tableView.register(ProfileTopHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileTopHeaderView.reuseIdentifier)
        
        
        self.tableView.register(ProfileDefaultHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileDefaultHeaderView.reuseIdentifier)
    }
    
//    private func prepareUI() {
//        self.btnLogout.addTarget(self, action: #selector(self.tappedOnBtnLogout), for: .touchUpInside)
//    }
    
    private func addingViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func displayOptionMenu() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.promptImagePicker(withPickerType: .camera)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.promptImagePicker(withPickerType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        optionMenu.modalPresentationStyle = .overFullScreen
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func promptImagePicker(withPickerType pickerType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(pickerType) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = pickerType
            myPickerController.allowsEditing = (pickerType == .camera)
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func setImagePickerImage(withInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
}

// MARK: UIImagePickerControllerDelegate

extension PersonalDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let resizedImage = image.resized(toWidth: 90)
        if let img = resizedImage {
            self.updateProfileImageClosure?(img)
        } else {
            self.updateProfileImageClosure?(image)
        }

        dismiss(animated: true, completion: nil)
    }

}

extension PersonalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
//        let sectionName = presenter.getSectionNameFor(section: indexPath.section)
//        switch sectionName {
//            case .legalSection(let cells):
//                switch cells[indexPath.row] {
//                case .emptyCell:
//                    return 24
//                default:
//                    return UITableView.automaticDimension
//                }
//        default:
            return UITableView.automaticDimension
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = presenter.getSectionNameFor(section: section)
        
        switch sectionName {
        case .imageSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonalDetailsProfileImageHeader.reuseIdentifier) as? PersonalDetailsProfileImageHeader
            
            let dataModel = StorageDataManager.shared.userDataModel
            
            header?.setFirstNameAndLastName(firstName: dataModel?.profile?.firstName ?? "",
                                            lastName: dataModel?.profile?.lastName ?? "")
            
            header?.setImage(image: self.presenter.profileImage)
            
            updateProfileImageClosure = { [weak self] image in
                guard let sSelf = self else { return }
//                guard
//                    let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//                else { return }
                sSelf.presenter.uploadImage(image: image)
                header?.setImage(image: image)
            }
            
            header?.changeProfileImageTappedClosure = { [weak self] in
                self?.displayOptionMenu()
            }
            return header
        case .profileInfoSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonalDetailsDefaultHeader.reuseIdentifier) as? PersonalDetailsDefaultHeader
            header?.setTitle(titleText: L.string("PROFILE").uppercased())
            
            return header
        case .contactDetailsSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonalDetailsDefaultHeader.reuseIdentifier) as? PersonalDetailsDefaultHeader
            header?.setTitle(titleText: L.string("PERSONAL_DETAILS").uppercased())
            
            return header
        case .moreSection:
            let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonalDetailsDefaultHeader.reuseIdentifier) as? PersonalDetailsDefaultHeader
            header?.setTitle(titleText: L.string("MORE_STRING").uppercased())
            
            return header
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = presenter.getSectionNameFor(section: indexPath.section)
        
        switch sectionName {
        case .imageSection:
            return UITableViewCell()
        case .profileInfoSection(let cells):
            switch cells[indexPath.row] {
            case .fullNameCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                cell.setTitle(titleText: self.presenter.userDataModel?.profile?.fullName ?? "-")
                cell.setSubTitle(subTitleText: L.string("FULL_NAME"))
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.fullNameCellTapped()
                }
                
                return cell
                
            case.dateOfBirthCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                
                if let date = self.presenter.getBirthDate() {
                    cell.setTitle(titleText: date.toString(dateFormat: "yyyy-MM-dd"))
                } else {
                    cell.setTitle(titleText: "-")
                }
                
                cell.setSubTitle(subTitleText: L.string("DATE_OF_BIRTH"))
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.dateOfBirthCellTapped()
                }
                return cell
                
            case .genderCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                cell.setTitle(titleText: self.presenter.userDataModel?.profile?.sex?.title ?? "-")
                cell.setSubTitle(subTitleText: L.string("GENDER"))
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.genderCellCellTapped()
                }
                return cell
            }
            
        case .contactDetailsSection(let cells):
            switch cells[indexPath.row] {
            case .emailAddressCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                cell.setTitle(titleText: self.presenter.userDataModel?.email ?? "-")
                cell.setSubTitle(subTitleText: L.string("EMAIL_ADDRESS"))
                cell.setLockedStyle()
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    guard let sSelf = self else { return }
                    UIUtils.showOkAlert(on: sSelf,
                                        titleText: L.string("FIELD_LOCKED"),
                                        descriptionText: L.string("YOU_CANNOT_EDIT_YOUR_EMAIL_ADRESS_YOU _CAN_CONTACT_US"))
                }
                
                return cell
            case .countryCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                var countryName = "-"
                
                if let code = self.presenter.userDataModel?.profile?.countryCode, let countryInfo = CountryPickerView().getCountryByCode(code) {
                    countryName = countryInfo.name
                    self.cpvInternal.setCountryByCode(code)
                }
                
                cell.setTitle(titleText: countryName)
                cell.setSubTitle(subTitleText: L.string("COUNTRY_STRING"))
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.cpvInternal.showCountriesList(from: sSelf)
                }
                return cell
            }
        case .moreSection(let cells):

            switch cells[indexPath.row] {
            case .fitnessLevelCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: PersonalDetailsDefaultCell.reuseIdentifier, for: indexPath) as! PersonalDetailsDefaultCell
                cell.setTitle(titleText: self.presenter.userDataModel?.profile?.currentFitnessLevel?.title ?? "-")
                cell.setSubTitle(subTitleText: L.string("FITNESS_LEVEL"))
                
                cell.btnOverlayTappedClosure = { [weak self] in
                    self?.presenter.fitnessLevelCellTapped()
                }
                
                return cell
            }
        }
    }
    
}

extension PersonalDetailsViewController: CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        if self.presenter.userDataModel?.profile?.countryCode != country.code {
            self.presenter.updateCountryCodeTo(newCountryCode: country.code)
        }
    }
}

extension PersonalDetailsViewController: PersonalDetailsVCProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
