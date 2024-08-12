//
//  ProductView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 09/03/2023.
//

import SwiftUI
import Combine

// View model that retrieves and stores the products data
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var favoriteProducts: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProducts() {
        ProductController.shared.getProducts() { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.products = products
                    self.updateFavoriteProducts()
                }
            case .failure(let error):
                print("Failed to fetch products: \(error)")
            }
        }
    }
    
    func updateFavoriteProducts() {
        guard let favoriteProductIDs = UserController.shared.user?.favorites else {
            favoriteProducts = []
            return
        }
        favoriteProducts = products.filter { favoriteProductIDs.contains($0.id) }
    }
    
    init() {
        UserController.shared.$user
            .compactMap { $0?.favorites }  // compactMap is used to ignore any `nil` values
            .sink { [weak self] _ in
                self?.fetchProducts()  // Refetch the products whenever favorites change
            }
            .store(in: &cancellables)  // Store the cancellable to keep the subscription alive
        
        fetchProducts()
        updateFavoriteProducts()
    }
}

// View that displays a list of products
struct ProductsView: View {
    @State private var gridLayout: [GridItem] = [GridItem(), GridItem()]
    @ObservedObject var viewModel: ProductViewModel
    @ObservedObject var userController = UserController.shared
    private var titleText = "Products"
    
    init() {
        viewModel = ProductViewModel()
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                // Title and spacing
                HStack {
                    VStack {
                        PageTitleComponent(titleText: titleText)
                            
                        Spacer()
                    }
                    Spacer()
                }
                
                // Product cards
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()], alignment: .center, spacing: 20) {
                        ForEach(viewModel.products) { product in
                            ProductCardComponent(product: product)
                                .frame(height: 230)
                        }
                    }
                    .padding(5)
                }
                .padding(.top, 100)
            }
            .frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
            .padding()
            .background(
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]),
                            startPoint: .top,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 1200, height: 1200)
                    .offset(x: -200, y: -850)
            )
            .onChange(of: userController.user?.favorites) { _ in
                viewModel.updateFavoriteProducts()
            }
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}
