import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    private var ratingFormatted: String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: restaurant.rating)) ?? ""
        }
    
    private var starCount: Int {
            return Int(restaurant.rating.rounded())
        }
    
    var body: some View {
        VStack {
            if let imageUrl = URL(string: restaurant.image_url) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 500)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(restaurant.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            HStack(spacing: 4) {
                            ForEach(0..<starCount, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }

            Spacer()
            
            HStack {
                Button {
                    onPrevious()
                } label: {
                    Image(systemName: "arrowshape.left")
                        .foregroundColor(.black)
                }
                .padding()
                
                Button {
                    onNext()
                } label: {
                    Image(systemName: "arrowshape.right")
                        .foregroundColor(.black)
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

