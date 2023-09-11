//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

protocol DiaryDetailViewControllerDelegate: AnyObject {
    func saveDiaryContents(title: String, content: String)
}

final class DiaryDetailViewController: UIViewController, ActivityViewControllerShowable {
    weak var delegate: DiaryDetailViewControllerDelegate?
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.keyboardDismissMode = .onDrag
        textView.becomeFirstResponder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let todayDate: String
    private let diaryContent: DiaryEntity?
    private var isEditDiary: Bool {
        return diaryContent == nil
    }
    
    init(todayDate: String, diaryContent: DiaryEntity? = nil) {
        self.todayDate = todayDate
        self.diaryContent = diaryContent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpTextViewText()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryContents()
    }
    
    private func configureUI() {
        view.addSubview(textView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = todayDate
        navigationItem.rightBarButtonItem = .init(title: "더보기", style: .plain, target: self, action: #selector(didTappedMoreButton))
    }
    
    private func setUpTextViewText() {
        guard let diaryContent = diaryContent else { return }
        
        textView.text = diaryContent.title == "" ? "" : diaryContent.title + "\n" + diaryContent.body
    }
    
    private func saveDiaryContents() {
        var splittedDiaryContents = textView.text.components(separatedBy: "\n")
        guard let title = splittedDiaryContents.first else { return }
        
        splittedDiaryContents.removeFirst()
        let content = splittedDiaryContents.joined(separator: "\n")
        
        delegate?.saveDiaryContents(title: title, content: content)
    }
}

// MARK: - Button Action
extension DiaryDetailViewController {
    @objc
    func didTappedMoreButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: didTappedShareButtonFromAlert(alertAction:))
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true)
    }
    
    private func didTappedShareButtonFromAlert(alertAction: UIAlertAction) {
        let sharedItem = [self.textView.text]
        
        showActivityViewController(items: sharedItem as [Any])
    }
}
