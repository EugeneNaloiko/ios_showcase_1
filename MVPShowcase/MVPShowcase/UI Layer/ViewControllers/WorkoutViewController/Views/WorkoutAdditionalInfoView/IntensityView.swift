//
//  IntensityView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import Foundation

final class IntensityView: UIView {
    
    private let lblIntensityTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 10)
        lbl.text = L.string("INTENSITY_STRING")
        
        lbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lbl.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return lbl
    }()
    
    private let intensityValuesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.setContentHuggingPriority(.defaultLow, for: .vertical)
        sv.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.addSubview(self.lblIntensityTitle)
        self.addSubview(self.intensityValuesStackView)
    }
    
    private func setupConstraints() {
        lblIntensityTitle.translatesAutoresizingMaskIntoConstraints = false
        intensityValuesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblIntensityTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lblIntensityTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblIntensityTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            intensityValuesStackView.topAnchor.constraint(equalTo: self.lblIntensityTitle.bottomAnchor),
            intensityValuesStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            intensityValuesStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            intensityValuesStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setTitle(titleText: String) {
        lblIntensityTitle.text = titleText
    }
    
    func setValues(values: [String]) {
        values.forEach({ [weak self] value in
            guard let sSelf = self else { return }
            let lblValue: VerticalAlignLabel = {
                let lbl = VerticalAlignLabel()
                lbl.font = UIFont.sfProFont(.semibold, size: 12)
                lbl.textColor = UIColor.tfOrangish
                lbl.textAlignment = .center
                return lbl
            }()
            lblValue.text = value
            sSelf.intensityValuesStackView.addArrangedSubview(lblValue)
        })
    }
    
}

public class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }
    
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
