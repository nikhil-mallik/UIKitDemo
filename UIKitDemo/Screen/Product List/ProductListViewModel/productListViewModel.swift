//
//  productListViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import Foundation

final class productListViewModel {
    // Array to hold products
    var products: [ProductListModel] = []
    // Data Binding Closure
    var eventHandler: ((_ event: Event) -> Void)?
    
    // Method to fetch products
    func fetchProducts() {
        
        // Notify event handler that data loading started
        self.eventHandler?(.loading)
        
        // Make a network request to fetch products
        APIManager.shared.request(requestModel: nil, responseModelType: [ProductListModel].self, type: APIEndPoint.products) { response in
            print("API Hit")
            // Notify event handler
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                // Update products array with fetched products
                self.products = products.map { product in
                    var updatedProduct = product
                    updatedProduct.isLiked = false
                    return updatedProduct
                }
                self.eventHandler?(.dataLoaded) // Notify event handler
            case .failure(let error):
                // Notify event handler
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func fetchPreviousProduct(currentProductIndex: Int) -> ProductListModel? {
        guard currentProductIndex > 0 && currentProductIndex < products.count else {
            return nil
        }
        return products[currentProductIndex - 1]
    }
    
    // Fetch product details for the next product
    func fetchNextProduct(currentProductIndex: Int) -> ProductListModel? {
        guard currentProductIndex >= 0 && currentProductIndex < products.count - 1 else {
            return nil
        }
        return products[currentProductIndex + 1]
    }
}
