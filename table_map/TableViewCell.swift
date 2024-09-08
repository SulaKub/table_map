//
//  TableViewCell.swift
//  table_map
//
//  Created by Sultan Kubentayev on 08/09/2024.
//

import UIKit
import MapKit
import SnapKit

class TableViewCell: UITableViewCell {
        
    let identifier = "Cell"
    
    var imageView1 : UIImageView = {
       let iv = UIImageView ()
        iv.image = UIImage(named: "")
        iv.contentMode = .scaleAspectFill // Чтобы изображение заполнило область корректно
        iv.clipsToBounds = true // Обеспечивает, что изображение будет обрезано по границам view
        iv.layer.cornerRadius = 10 // Устанавливаем радиус закругления углов
        return iv
    }()
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hotel Name"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var addressLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "address"
        label.font = .systemFont(ofSize: 16, weight: .semibold )
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    
    let mapView = MKMapView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(imageView1)
    }
    
    func setupConstraints() {
        imageView1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 350, height: 350))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView1.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-20)
            make.left.right.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(60) // Примерно 2 строки для шрифта 16pt
            make.bottom.equalToSuperview().inset(16)
        }
        addressLabel.setContentHuggingPriority(.required, for: .vertical)
        addressLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
