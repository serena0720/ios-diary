//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTappedRightAddButton()
    func didTappedTableViewCell(diaryContent: DiaryEntity)
}

final class MainViewController: UIViewController, ActivityViewControllerShowable, AlertControllerShowable {
    enum Section {
        case main
    }
    
    weak var delegate: MainViewControllerDelegate?
    private var diaryContents: [DiaryEntity]?
    private let coreDataManager: CoreDataManager
    private let dateFormatter: DateFormatter
    private var diffableDatasource: UITableViewDiffableDataSource<Section, DiaryEntity>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.indentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(coreDataManager: CoreDataManager, dateFormatter: DateFormatter) {
        self.coreDataManager = coreDataManager
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchDiaryContents()
        setUpTableViewDiffableDataSourceSnapShot()
    }
    
    private func fetchDiaryContents() {
        diaryContents = coreDataManager.fetch(request: DiaryEntity.fetchRequest())
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

// MARK: - TableViewDiffableDataSource
extension MainViewController {
    private func setUpTableViewDiffableDataSource() {
        diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, diarySample in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.indentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            let date = Date(timeIntervalSince1970: diarySample.date)
            let formattedDate = self.dateFormatter.string(from: date)
            cell.setUpContents(title: diarySample.title, date: formattedDate, body: diarySample.body)
            return cell
        })
    }
    
    private func setUpTableViewDiffableDataSourceSnapShot(animated: Bool = false) {
        guard let diaryContents = diaryContents else { return }
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiaryEntity>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(diaryContents)
        diffableDatasource?.apply(snapShot, animatingDifferences: false)
    }
    
    private func deleteItemFromSnapShot(diaryContent: DiaryEntity) {
        guard var snapShot = diffableDatasource?.snapshot() else { return }
        
        snapShot.deleteItems([diaryContent])
        diffableDatasource?.apply(snapShot)
    }
}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContent = diaryContents?[indexPath.row] else { return }
        
        delegate?.didTappedTableViewCell(diaryContent: diaryContent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { action, view, handler in
            self.didSwipedShareActionButton(index: indexPath.row)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
            self.didSwipedDeleteActionButton(index: indexPath.row)
        }

        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
        
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc
    private func didTappedRightAddButton() {
        delegate?.didTappedRightAddButton()
    }
    
    private func didSwipedShareActionButton(index: Int) {
        guard let diaryContent = self.diaryContents?[index] else { return }
        let shareItem = diaryContent.title + "\n" + diaryContent.body
        
        self.showActivityViewController(items: [shareItem])
    }
    
    private func didSwipedDeleteActionButton(index: Int) {
//        guard let deletedDiaryContent = self.diaryContents?[index] else { return }
//
//        self.diaryContents?.remove(at: index)
//        self.deleteItemFromSnapShot(diaryContent: deletedDiaryContent)
//        self.coreDataManager.delete(object: deletedDiaryContent)
        
        showAlertController(title: "진짜요?",
                            message: "정말로 삭제하시겠어요?",
                            leftButtonTitle: "취소",
                            rightButtonTitle: "삭제")
    }
}
