//
//  ProductController.swift
//  EcoInsights
//
//  Created by Robbe Van hoorebeke on 31/03/2023.
//

import Foundation

class ProductController : ObservableObject {
    static let shared = ProductController()

    let baseURL = "https://ecoinsights.xyz"
    var products: [Product] = []
    var isFetching = false;
    
    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Load products from local JSON first
        if let localProducts = loadProductsFromLocalFile() {
            self.products = localProducts
            completion(.success(localProducts))
        }
        
        // Then fetch products from the API if no fetch is currenlty ongoing
        if isFetching { return }
        
        fetchProducts { result in
            switch result {
            case .success(let fetchedProducts):
                self.products = fetchedProducts
                completion(.success(fetchedProducts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
      Fetches the products from the remote API or loads them from the local file if the API call fails.

      - Parameter completion: A closure to be called with the result of the operation. It contains either the fetched products or an error.
     */
    private func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/products")!
        self.isFetching = true
        print("Fetching products...")

        URLSession.shared.dataTask(with: url) { data, response, error in
            self.isFetching = false
            
            if let error = error {
                print("Failed to fetch products: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "Empty response data", code: -1, userInfo: nil)
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let fetchedProducts = try decoder.decode([Product].self, from: data)

                DispatchQueue.main.async {
                    self.saveProductsToLocalFile(data: data)
                    completion(.success(fetchedProducts))
                }
            } catch {
                print("Error decoding products data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }

    
    /**
     Filters the products based on the user's favorites.
     
     - Returns: An array of products filtered based on the user's favorites.
     */
    private func filterFavorites() -> [Product] {
        guard let favorites = UserController.shared.user?.favorites else {
            return products
        }
        return products.filter { favorites.contains($0.id) }
    }
    
    /**
     Saves the products data to a local JSON file.
     
     - Parameter data: The products data to be saved.
     */
    private func saveProductsToLocalFile(data: Data) {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL.appendingPathComponent("products.json")
            try data.write(to: fileURL)
//            print("Saved products to local JSON file")
        } catch {
            print("Error writing JSON data to local file: \(error)")
        }
    }
    
    /**
        Loads the products from the locally saved JSON file.

        - Returns: An optional array of products if the loading is successful, or nil if an error occurs.
       */
    private func loadProductsFromLocalFile() -> [Product]? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return nil
        }

        let fileURL = documentsURL.appendingPathComponent("products.json")

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let products = try decoder.decode([Product].self, from: jsonData)
//            print("Loaded products from local JSON file")
            return products
        } catch {
            print("Error decoding local JSON file: \(error)")
            return nil
        }
    }
}
