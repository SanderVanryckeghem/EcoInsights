//
//  ProductDetailView.swift
//  EcoInsights
//
//  Created by Sander Vanryckeghem on 30/03/2023.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var userController = UserController.shared
    let product: Product
    let types = ["Sourcing", "Production", "Packaging", "Transport", "Ethics"]
    @State private var selectedButton: String? = "Sourcing"
    @State private var liked: Bool = false
    
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                HStack(alignment: .center){
                    Spacer(minLength: 75)
                    SwiftUI.Image("\(product.brand) \(product.name)")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(EdgeInsets(top: -20, leading: 20, bottom: 20, trailing: 20))
                    VStack{
                        ScrollView{
                            if product.labels.count != 0{
                                
                                ForEach(product.labels, id: \.self) { label in
                                    let name = label.name.contains("Duurzame Visvangst (own)") ? "MSC" : label.name
                                    Image(name)
                                        .resizable()
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            
                        }
                        .frame(height: 220)
                        
                    }
                    .padding(.bottom, 25)
                    .padding(.top, -25)
                    Spacer(minLength: 6)
                    
                }
                .background(Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing))
                    .frame(width: 800, height:800)
                    .offset(x: 0, y: -270))
                
                HStack{
                    VStack(alignment: .leading){
                        Text(product.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                        Text(product.brand)
                            .padding(.leading, 4)
                        
                    }
                    Spacer()
                    LikeButtonComponent(checked: $liked, product: product)
                        .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.40784314274787903, green: 0.886274516582489, blue: 0.3176470696926117, alpha: 1)), Color(#colorLiteral(red: 0.7215686440467834, green: 0.9529411792755127, blue: 0.42352941632270813, alpha: 1))]), startPoint: .top, endPoint: .trailing))
                        .frame(width: 50, height:50))
                }
                
                HStack(){
                    ScoreComponent(score: product.totalScore)
                    StarRatingComponent(rating: product.totalScore)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(types, id: \.self) { type in
                            TypeButtonComponent(title: type, action: {
                                selectedButton = type
                            }, isSelected: Binding(get: {
                                selectedButton == type
                            }, set: { newValue in
                                if newValue {
                                    selectedButton = type
                                } else {
                                    selectedButton = nil
                                }
                            }))
                        }
                    }
                    .padding()
                }
                
                ScrollView(showsIndicators: false){
                    switch selectedButton {
                    case "Sourcing":
                        VStack(alignment: .leading) {
                            SourcingComponent(sourcingData: product.sourcing)
                        }
                    case "Production":
                        VStack(alignment: .leading){
                            ProductionComponent(productionData: product.production)
                        }
                    case "Packaging":
                        VStack(alignment: .leading) {
                            PackagingComponent(packagingData: product.packaging)
                        }
                    case "Transport":
                        VStack(alignment: .leading) {
                            TransportComponent(transportData: product.transport)
                        }
                    case "Ethics":
                        VStack(alignment: .leading) {
                            EthicsComponent(ethicsData: product.ethics)
                        }
                    default:
                        EmptyView()
                    }
                }
                
                .frame(minWidth: geometryProxy.size.width * 0.78,  maxWidth: geometryProxy.size.width * 0.78, alignment: .leading )
                
            }
            .frame(width: geometryProxy.size.width-32, height: geometryProxy.size.height-32)
            .padding()
            .background(.white)
            .onAppear {
                liked = userController.user?.favorites?.contains(product.id) ?? false
            }
            .onReceive(userController.$user) { _ in
                liked = userController.user?.favorites?.contains(product.id) ?? false
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}



struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(
            identifier: "1746b30e-11df-449b-bbb6-c79d0e34b0f6",
            barcode: "0000000",
            arLabel: "00",
            name: "Tonno all Olio di Oliva",
            brand: "Rio Mare",
            imageUrl: "https://picsum.photos/200/300",
            type: "default",
            totalScore: 4.5,
            production: [
                Production(
                    model: Model(
                        identifier: "41d68e1f-27b9-4126-9aa2-1420d13c3612",
                        name: "Organic Chicken",
                        type: "test",
                        percentage: 70
                    ),
                    factors: [
                        Factor(
                            identifier: "2c99ca11-33e1-401f-b290-06a875e58204",
                            name: "Feed source",
                            percentage: 50,
                            score: 3,
                            reason: "Organic feed",
                            classEntityIdentifier: "41d68e1f-27b9-4126-9aa2-1420d13c3612"
                        ),
                        Factor(
                            identifier: "f5c5b5cf-1b94-4d36-81e4-8ad2b6c4c7d4",
                            name: "Living conditions",
                            percentage: 50,
                            score: 4,
                            reason: "Free-range",
                            classEntityIdentifier: "41d68e1f-27b9-4126-9aa2-1420d13c3612"
                        )
                    ]
                )
            ],
            ethics: [
                Ethics(
                    model: Model(
                        identifier: "a1cf821d-f08e-47ea-9f78-29de7c0d88eb",
                        name: "Fair Trade Coffee",
                        type: "test",
                        percentage: 80
                    ),
                    factors: [
                        Factor(
                            identifier: "b3c3b37e-96a4-4c4e-a3e3-cf8d2f10b128",
                            name: "Fair labor practices",
                            percentage: 100,
                            score: 5,
                            reason: "Certified fair trade",
                            classEntityIdentifier: "a1cf821d-f08e-47ea-9f78-29de7c0d88eb"
                        )
                    ]
                )
            ],
            packaging: [
                Packaging(
                    model: Model(
                        identifier: "9c832ec5-03a5-495d-931e-7197c2e3d63f",
                        name: "Eco-friendly Packaging",
                        type: "test",
                        percentage: 90
                    ),
                    factors: [
                        Factor(
                            identifier: "b0f30c4c-24e3-4a2a-94cf-38c48aa1d269",
                            name: "Recyclability",
                            percentage: 70,
                            score: 4,
                            reason: "Made from recyclable materials",
                            classEntityIdentifier: "9c832ec5-03a5-495d-931e-7197c2e3d63f"
                        ),
                        Factor(
                            identifier: "202d8431-90fb-4a48-bc35-2df2f3d3cf1e",
                            name: "Carbon footprint",
                            percentage: 30,
                            score: 3,
                            reason: "Low carbon footprint",
                            classEntityIdentifier: "9c832ec5-03a5-495d-931e-7197c2e3d63f"
                        )
                    ]
                )
            ],
            transport: [
                Transport(
                    model: Model(
                        identifier: "2f15aa21-5551-4171-bb69-0709e9a94035",
                        name: "Electric Vehicle Transport",
                        type: "test",
                        percentage: 70
                    ),
                    factors: [
                        Factor(
                            identifier: "3c7bdf5c-6c94-4535-a35b-3ccfce2f22c9",
                            name: "Energy source",
                            percentage: 50,
                            score: 4,
                            reason: "Electric vehicles run on renewable energy sources",
                            classEntityIdentifier: "2f15aa21-5551-4171-bb69-0709e9a94035"
                        ),
                        Factor(
                            identifier: "1c49b1a5-45c8-44ec-bd05-4b172f4a4c9a",
                            name: "Efficiency",
                            percentage: 20,
                            score: 3,
                            reason: "Electric vehicles are more efficient than gas-powered vehicles",
                            classEntityIdentifier: "2f15aa21-5551-4171-bb69-0709e9a94035"
                        ),
                        Factor(
                            identifier: "c6b2e6f8-3d43-441c-aefa-92a2dce9d3d3",
                            name: "Emissions",
                            percentage: 30,
                            score: 4,
                            reason: "Electric vehicles produce zero emissions",
                            classEntityIdentifier: "2f15aa21-5551-4171-bb69-0709e9a94035"
                        )
                    ]
                )
            ],
            sourcing: [
                Sourcing(
                    model: Model(
                        identifier: "1746b30e-11df-449b-bbb6-c79d0e34b0f4",
                        name: "Tuna fish",
                        type: "test",
                        percentage: 80
                    ),
                    factors: [
                        Factor(
                            identifier: "32725220-5273-4ff1-a50b-18b2145ff9c7",
                            name: "Type of fishing",
                            percentage: 60,
                            score: 5,
                            reason: "Pole & line",
                            classEntityIdentifier: "1746b30e-11df-449b-bbb6-c79d0e34b0f4"
                        ),
                        Factor(
                            identifier: "7f7156e8-03fe-479f-a2ec-d4a041e77956",
                            name: "Type of tuna",
                            percentage: 40,
                            score: 5,
                            reason: "Skipjack",
                            classEntityIdentifier: "1746b30e-11df-449b-bbb6-c79d0e34b0f4"
                        )
                    ]
                ),
                Sourcing(
                    model: Model(
                        identifier: "7a682a94-9c8a-46e0-862d-e1b030c09f8b",
                        name: "Olive oil",
                        type: "test",
                        percentage: 20
                    ),
                    factors: [
                        Factor(
                            identifier: "adf60b14-8f45-45ee-ba59-672633951737",
                            name: "Cultivation type",
                            percentage: 100,
                            score: 2,
                            reason: "Not organic",
                            classEntityIdentifier: "7a682a94-9c8a-46e0-862d-e1b030c09f8b"
                        )
                    ]
                )
            ],
            labels: [
                EcoLabel(
                    identifier: "2fd57918-e60a-4002-b03b-bd897d01f05e",
                    name: "PAP 21 (paper)",
                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/d/d2/Recycling-Code-21.svg"
                ),
                EcoLabel(
                    identifier: "33874fde-4971-4a75-b371-b873acd6ac5c",
                    name: "SAFE (dolfijn)",
                    imageUrl: "https://psinfoodservice.be/wp-content/uploads/2021/10/Dolphin-safe_Tekengebied-1.png"
                ),
                EcoLabel(
                    identifier: "4dd4b7b2-0989-4a51-9f1e-14af1f432419",
                    name: "MSC",
                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/f/f3/Logo_Marine_Stewardship_Council.svg"
                ),
                EcoLabel(
                    identifier: "88b6ac26-1479-485e-8b3c-70736dcccbf5",
                    name: "Responsible Quality (own)",
                    imageUrl: "https://qualitaresponsabile.riomare.it/sites/riomarequre/themes/riomare/images/logo/logo-en.png"
                )
            ]
        ))
    }
}
