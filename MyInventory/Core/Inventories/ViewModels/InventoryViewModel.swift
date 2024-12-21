//
//  InventoryViewModel.swift
//  MyInventory
//
//  Created by Ancel Dev account on 21/12/24.
//

import Appwrite
import Foundation
import Observation

@Observable
final class InventoryViewModel {
    var user: User
    var inventories: [Inventory] = []
    var boxes: [Box] = []
    var items: [Item] = []
    
    var errorMessage: String?
    
    init(user: User) {
        self.user = user
        Task {
            await fetchInventories(collection: .inventories, forUser: user.id)
        }
    }
    
    
    func createInventory(inventory: Inventory, boxes: [Box], items: [Item]) async {
        do {
            _ = try await AWClient.createDocument(collection: .inventories, model: inventory)
            for box in boxes {
                _ = try await AWClient.createDocument(collection: .boxes, model: box)
            }
            for item in items {
                _ = try await AWClient.createDocument(collection: .items, model: item)
            }
            self.inventories.append(inventory)
            self.boxes.append(contentsOf: boxes)
            self.items.append(contentsOf: items)
            
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    
    func fetchInventories(collection: AWCollection, forUser userId: String) async {
        do {
            let queries = [Query.equal("owner", value: userId)]
            let inventories: [Inventory] = try await AWClient.getModelsWithQuery(collection: .inventories, queries: queries)
            self.inventories = inventories
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchBoxes(collection: AWCollection, forInventory inventoryId: String) async {
        do {
            let queries = [Query.equal("inventoryId", value: inventoryId)]
            let boxes: [Box] = try await AWClient.getModelsWithQuery(collection: .boxes, queries: queries)
            self.boxes = boxes
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchItems(collection: AWCollection, forBox boxId: String) async {
        do {
            let queries = [Query.equal("boxId", value: boxId)]
            let items: [Item] = try await AWClient.getModelsWithQuery(collection: .items, queries: queries)
            self.items = items
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
}
