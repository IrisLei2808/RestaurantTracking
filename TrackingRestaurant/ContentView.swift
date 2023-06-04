import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var restaurants: [Restaurant] = []
    @State private var isLoading = false
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                if restaurants.isEmpty {
                    Text("No restaurants found.")
                        .foregroundColor(.gray)
                        .padding()
                    Button(action: {
                        fetchRestaurants()
                    }) {
                        Text("Load Data")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    VStack {
                        RestaurantCardView(restaurant: restaurants[currentIndex],
                                           onPrevious: {
                                                                           currentIndex = (currentIndex - 1 + restaurants.count) % restaurants.count
                                                                       },
                                                                       onNext: {
                                                                           currentIndex = (currentIndex + 1) % restaurants.count
                                                                       })
                                               .padding()
                                       }
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .alert(isPresented: $locationManager.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(locationManager.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func fetchRestaurants() {
        guard let location = locationManager.location else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        isLoading = true
        
        // API Request
        let apiKey = "itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx"
        let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RestaurantResponse.self, from: data)
                DispatchQueue.main.async {
                    self.restaurants = response.businesses
                    isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

