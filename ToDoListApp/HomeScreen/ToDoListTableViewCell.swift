//
//  ToDoListTableViewCell.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 20.08.2025.
//

import UIKit
import SnapKit

class ToDoListTableViewCell: UITableViewCell {

    private lazy var checkView : UIButton = UIButton(type: .system)
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var descLabel: UILabel = UILabel()
    private lazy var dateLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with todo: ToDoEntity) {
        titleLabel.text = todo.title
        if let desc = todo.desc, !desc.isEmpty {
            descLabel.text = desc
            descLabel.isHidden = false
        } else {
            descLabel.text = nil
            descLabel.isHidden = true
        }
        if let createdAt = todo.createdAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: createdAt)
        } else {
            dateLabel.text = "No date"
        }
        let imageName = todo.completed ? "checkmark.circle.fill" : "circle"
        checkView.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func setupCheckView() {
        addSubview(checkView)
        checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        checkView.tintColor = .systemYellow
        checkView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
    }

    private func setupTitle() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(checkView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupDescLabel() {
        addSubview(descLabel)
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 2
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
    }

    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(10)
        }

    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
