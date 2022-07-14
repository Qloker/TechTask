//
//  CustomCell.swift
//  VkTask
//
//  Created by Ilia Zakharov on 14.07.2022.
//
import UIKit

class CustomCell: UITableViewCell {
    
    // MARK: - Views
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.header
        label.font = Constants.Font.header
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.description
        label.font = Constants.Font.description
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 5
        image.image = Constants.Image.forTable
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    private func setupViews() {
        addSubview(image)
        
        stack.addArrangedSubview(headerLabel)
        stack.addArrangedSubview(descriptionLabel)
        addSubview(stack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            image.widthAnchor.constraint(equalToConstant: 55),
            image.heightAnchor.constraint(equalToConstant: 55),
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

    }
    
    func config(result: Service) {
        headerLabel.text = result.name
        descriptionLabel.text = result.serviceDescription
        
        var data = Data()
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        let group = DispatchGroup()
        group.enter()
        queue.async(group: group) {
            guard let url = URL(string: result.iconURL) else  { return }
            data = try! Data(contentsOf: url)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.image.image = UIImage(data: data)
        }
    }
}
