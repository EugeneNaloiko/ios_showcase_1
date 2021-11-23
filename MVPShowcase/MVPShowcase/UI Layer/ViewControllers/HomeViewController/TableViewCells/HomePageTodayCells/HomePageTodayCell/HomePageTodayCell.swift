//
//  HomePageTodayCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomePageTodayCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private var collectionView: UICollectionView!
    
    private var dataModel: [ProgramDataModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    var btnNextTappedClosure: ((_ dataModel: ProgramDataModel) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.setupCollectionView()
        self.addingViews()
        self.setupConstraints()
        self.contentView.backgroundColor = UIColor.tfWhite
        
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.backgroundColor = UIColor.tfWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        
        self.registerCollectionViewCells()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCollectionViewCells() {
        collectionView?.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.reuseIdentifier)
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.collectionView)
    }
    
    private func setupConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setData(dataModel: [ProgramDataModel]) {
        self.dataModel = dataModel
    }
    
}

extension HomePageTodayCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.reuseIdentifier, for: indexPath) as? TodayCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(dataModel: self.dataModel[indexPath.row])
        cell.closureTappedOnBtnAction = { [weak self] in
            guard let sSelf = self else { return }
            let selectedProgram = sSelf.dataModel[indexPath.row]
            sSelf.btnNextTappedClosure?(selectedProgram)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 76)
        return CGSize(width: width, height: 250)
    }
    
}
