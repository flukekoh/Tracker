//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Артем Кохан on 08.09.2023.
//

import Foundation

protocol CategoriesViewModelDelegate: AnyObject {
    func didUpdateCategories()
    func didSelectCategory(_ category: TrackerCategory)
}

final class CategoriesViewModel {
    
    weak var delegate: CategoriesViewModelDelegate?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            delegate?.didUpdateCategories()
        }
    }
    private(set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory else { return }
            delegate?.didSelectCategory(selectedCategory)
        }
    }
    
    init(selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    func loadCategories() {
        categories = getCategoriesFromStore()
    }
    
    func selectCategory(at indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
    func handleCategoryFormConfirm(data: TrackerCategory.Data) {
        if categories.contains(where: { $0.id == data.id }) {
            updateCategory(with: data)
        } else {
            addCategory(with: data.title)
        }
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        do {
            try trackerCategoryStore.deleteCategory(category)
            loadCategories()
            if category == selectedCategory {
                selectedCategory = nil
            }
        } catch {}
    }
    
    private func getCategoriesFromStore() -> [TrackerCategory] {
        do {
            let categories = try trackerCategoryStore.categoriesCoreData.map {
                try trackerCategoryStore.makeCategory(from: $0)
            }
            return categories
        } catch {
            return []
        }
    }
    
    private func addCategory(with title: String) {
        do {
            try trackerCategoryStore.makeCategory(with: title)
            loadCategories()
        } catch {}
    }
    
    private func updateCategory(with data: TrackerCategory.Data) {
        do {
            try trackerCategoryStore.updateCategory(with: data)
            loadCategories()
        } catch {}
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func didUpdate() {
        categories = getCategoriesFromStore()
    }
}
