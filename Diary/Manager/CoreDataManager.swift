//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/04.
//

import CoreData

class CoreDataManager {
    private let name: String
    
    private lazy var persistentContainer: NSPersistentContainer = {
       let persistentContainer = NSPersistentContainer(name: name)
        
        persistentContainer.loadPersistentStores { description, err in }
        return persistentContainer
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(name: String) {
        self.name = name
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        do {
            let fetchResult = try context.fetch(request)
            
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Diary
extension CoreDataManager {
    func insertDiary(diaryContent: DiaryContent) {
        let diaryEntity = DiaryEntity(context: context)
        
        
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context) else { return }
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(diaryContent.title, forKey: "title")
        managedObject.setValue(diaryContent.body, forKey: "body")
        managedObject.setValue(diaryContent.date, forKey: "date")
        saveContext()
    }
}
