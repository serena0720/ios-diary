//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTappedRightAddButton()
}

final class MainViewController: UIViewController, AlertControllerShowable {
    enum Section {
        case main
    }
    
    weak var delegate: MainViewControllerDelegate?
    private let diaryEntity: [DiaryEntity]
    private let dateFormatter: DateFormatter
    private var diffableDatasource: UITableViewDiffableDataSource<Section, DiaryEntity>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.indentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(diaryEntity: [DiaryEntity], dateFormatter: DateFormatter) {
        self.diaryEntity = diaryEntity
        self.dateFormatter = dateFormatter
        
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
        setUpTableViewDiffableDataSource()
        setUpTableViewDiffableDataSourceSnapShot()
    }

    private func configureUI() {
        view.addSubview(tableView)
    }
        
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTappedRightAddButton))
    }
}

// MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction: UIContextualAction = .init(style: .normal, title: "Share") { _, _, _ in
            
        }
        
        let deleteAction: UIContextualAction = .init(style: .destructive, title: "Delete") { _, _, _ in
            self.didTappedDeleteAction()
        }
        
        let swipeActionConfiguration: UISwipeActionsConfiguration = .init(actions: [deleteAction, shareAction])
        
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }
}

// MARK: - TableViewDiffableDataSource
extension MainViewController {
    private func setUpTableViewDiffableDataSource() {
        diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, diaryEntity in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.indentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            let date = Date(timeIntervalSince1970: diaryEntity.date)
            let formattedDate = self.dateFormatter.string(from: date)
            
            cell.setUpContents(title: diaryEntity.title, date: formattedDate, body: diaryEntity.body)
            return cell
        })
    }
    
    private func setUpTableViewDiffableDataSourceSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiaryEntity>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(diaryEntity)
        diffableDatasource?.apply(snapShot)
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc
    private func didTappedRightAddButton() {
        delegate?.didTappedRightAddButton()
        
    }
    
    private func didTappedDeleteAction() {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            
        }
        
        showAlertController(title: "진짜요?",
                            message: "정말로 삭제하시겠어요?",
                            style: .alert,
                            actions: [cancelAction, deleteAction])
    }
}
