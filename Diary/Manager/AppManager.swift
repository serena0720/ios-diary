//
//  AppManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class AppManager {
    private let navigationController: UINavigationController
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let localeID = Locale.preferredLanguages.first ?? "kr_KR"
        let deviceLocale = Locale(identifier: localeID).languageCode ?? "KST"
        
        dateFormatter.locale = Locale(identifier: deviceLocale)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    private let coreDataManager: CoreDataManager
    
    init(navigationController: UINavigationController, coreDataManager: CoreDataManager) {
        self.navigationController = navigationController
        self.coreDataManager = coreDataManager
    }
    
    func start() {
        guard let diaryContents = try? coreDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        let mainViewController = MainViewController(diaryContents: diaryContents, dateFormatter: dateFormatter)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didSelectRowAt(diaryContent: DiaryEntity) {
        let date = Date(timeIntervalSince1970: diaryContent.date)
        let formattedDate = dateFormatter.string(from: date)
        let diaryDetailViewController = DiaryDetailViewController(date: formattedDate, diaryEntity: diaryContent)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func didTappedRightAddButton() {
        let todayDate = dateFormatter.string(from: Date())
        let diaryDetailViewController = DiaryDetailViewController(date: todayDate, isUpdate: false)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func fetchDiaryContents(mainViewController: MainViewController) {
        guard let diaryContents = try? coreDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        
        mainViewController.setUpDiaryEntity(diaryContents: diaryContents)
    }
    
    func deleteDiaryContent(diaryContent: DiaryEntity) {
        coreDataManager.deleteData(entity: diaryContent)
        coreDataManager.saveContext()
    }
}

// MARK: - DiaryDetailViewControllerDelegate
extension AppManager: DiaryDetailViewControllerDelegate {
    func createDiaryData(text: String) {
        guard let (title, body) = convertDiaryData(text: text) else { return }
        let date = Date().timeIntervalSince1970
        let diaryEntityProperties: [String: Any] = ["title": title, "body": body, "date": date]
        
        coreDataManager.insertData(entityName: "DiaryEntity", entityProperties: diaryEntityProperties)
        coreDataManager.saveContext()
    }
    
    func updateDiaryData(diaryEntity: DiaryEntity, text: String) {
        guard let (title, body) = convertDiaryData(text: text) else { return }
        let date = Date().timeIntervalSince1970
        
        diaryEntity.title = title
        diaryEntity.body = body
        diaryEntity.date = date
        coreDataManager.saveContext()
    }
    
    func deleteDiaryData(diaryEntity: DiaryEntity) {
        coreDataManager.deleteData(entity: diaryEntity)
    }
    
    func popDiaryDetailViewController() {
        navigationController.popViewController(animated: true)
    }
    
    private func convertDiaryData(text: String) -> (String, String)? {
        let separatedText = text.split(separator: "\n", maxSplits: 1)
        guard let titleText = separatedText.first?.description else { return nil }
        
        let removedTitleText = separatedText.dropFirst()
        let bodyText = removedTitleText.count != 0 ? removedTitleText.description : ""
        
        return (titleText, bodyText)
    }
}
