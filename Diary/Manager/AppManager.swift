//
//  AppManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class AppManager {
    private let navigationController: UINavigationController
    private let coreDataManger: CoreDataManager
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let localeID = Locale.preferredLanguages.first ?? "kr_KR"
        let deviceLocale = Locale(identifier: localeID).languageCode ?? "KST"
        
        dateFormatter.locale = Locale(identifier: deviceLocale)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter
    }()
    
    init(navigationController: UINavigationController, coreDataManger: CoreDataManager) {
        self.navigationController = navigationController
        self.coreDataManger = coreDataManger
    }
    
    func start() {
        let mainViewController = MainViewController(coreDataManager: coreDataManger, dateFormatter: dateFormatter)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didTappedTableViewCell(diaryContent: DiaryEntity) {
        let todayDate = dateFormatter.string(from: Date())
        let diaryDetailViewController = DiaryDetailViewController(todayDate: todayDate, diaryContent: diaryContent)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func didTappedRightAddButton() {
        let todayDate = dateFormatter.string(from: Date())
        let diaryDetailViewController = DiaryDetailViewController(todayDate: todayDate)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
}

// MARK: - DiaryDetailViewControllerDelegate
extension AppManager: DiaryDetailViewControllerDelegate {
    func saveDiaryContents(title: String, content: String) {
        let todayDate = Date().timeIntervalSince1970
        let diaryContent = DiaryContent(title: title, body: content, date: todayDate)
        
        coreDataManger.insertDiary(diaryContent: diaryContent)
    }
}
