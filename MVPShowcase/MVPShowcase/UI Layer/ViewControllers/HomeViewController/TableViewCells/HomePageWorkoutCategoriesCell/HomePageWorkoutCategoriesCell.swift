//
//  HomePageWorkoutCategoriesCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomePageWorkoutCategoriesCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private var collectionView: UICollectionView!
    
    private var cellHeightAndWidth: CGFloat = (UIScreen.main.bounds.width - 48) / 3
    
    private var dataModel: [WorkoutCategoriesDataModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    var btnNextTappedClosure: ((_ workoutCategoryDataModel: WorkoutCategoriesDataModel) -> Void)?

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
        layout.minimumLineSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.tfWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        
        self.registerCollectionViewCells()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCollectionViewCells() {
        collectionView?.register(WorkoutCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: WorkoutCategoriesCollectionViewCell.reuseIdentifier)
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
            self.collectionView.heightAnchor.constraint(equalToConstant: self.cellHeightAndWidth)
        ])
    }
    
    func clearData() {
        self.dataModel = []
    }
    
    func setData(dataModel: [WorkoutCategoriesDataModel]) {
        self.dataModel = dataModel
    }
    
}

extension HomePageWorkoutCategoriesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutCategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as? WorkoutCategoriesCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(dataModel: self.dataModel[indexPath.row])
        cell.closureTappedOnBtnAction = { [weak self] in
            guard let sSelf = self else { return }
            let selectedCategory = sSelf.dataModel[indexPath.row]
            sSelf.btnNextTappedClosure?(selectedCategory)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 110, height: 110)
        let width = (UIScreen.main.bounds.width - 48) / 3
        return CGSize(width: width, height: width)
    }
    
}
