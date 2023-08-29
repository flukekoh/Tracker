//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Артем Кохан on 28.08.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    var categoriesCoreData: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.createdAt, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func categoryCoreData(with id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request)
        
        //Заглушка пока нет механизма категорий
        if category.count == 0 {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.categoryId = id.uuidString
            categoryCoreData.createdAt = Date()
            categoryCoreData.title = "Домашний уют"
            try context.save()
            
            let category = try context.fetch(request)
            return category[0]
        }
        
        return category[0]
    }
    
    func makeCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard
            let idString = coreData.categoryId,
            let id = UUID(uuidString: idString),
            let title = coreData.title
        else { throw StoreError.decodeError }
       return TrackerCategory(id: id, title: title)

    }
    
    @discardableResult
    func makeCategory(with title: String) throws -> TrackerCategory {
        let category = TrackerCategory(title: title)

        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.categoryId = category.id.uuidString
        categoryCoreData.createdAt = Date()
        categoryCoreData.title = category.title
        try context.save()
        return category
    }
    
    func updateCategory(with data: TrackerCategory.Data) throws {
        let category = try getCategoryCoreData(by: data.id)
        category.title = data.title
        try context.save()
    }
    
    func deleteCategory(_ category: TrackerCategory) throws {
        let categoryToDelete = try getCategoryCoreData(by: category.id)
        context.delete(categoryToDelete)
        try context.save()
    }
    
    // MARK: - Private
    
    private func getCategoryCoreData(by id: UUID) throws -> TrackerCategoryCoreData {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        guard let category = fetchedResultsController.fetchedObjects?.first else { throw StoreError.fetchCategoryError }
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        return category
    }
}

extension TrackerCategoryStore {
    enum StoreError: Error {
        case decodeError, fetchCategoryError
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
