//
//  AddTaskView.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import UIKit
import SnapKit


class AddTaskView: UIView {

    lazy var titleTextField: UITextField = UITextField()
    lazy var descriptionTextView: UITextView = UITextView()



    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunc()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFunc() {
        setupTitleTextField()
        setupDesc()
    }

    private func setupTitleTextField() {
        addSubview(titleTextField)
        titleTextField.placeholder = "Title"
        titleTextField.font = .systemFont(ofSize: 28, weight: .bold)
        titleTextField.borderStyle = .none
        titleTextField.textColor = .label
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    private func setupDesc() {
        addSubview(descriptionTextView)
        descriptionTextView.font = .systemFont(ofSize: 17)
        descriptionTextView.textColor = .secondaryLabel
        descriptionTextView.text = "Add details..."
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }

    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add details..."
            textView.textColor = .secondaryLabel
        }
    }

}
