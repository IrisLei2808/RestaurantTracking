//
//  RemoteImage.swift
//  TrackingRestaurant
//
//  Created by Duc Le on 6/3/23.
//

import SwiftUI

struct RemoteImage: View {
    let urlString: String
    
    var body: some View {
        if let url = URL(string: urlString), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(systemName: "photo")
                .resizable()
        }
    }
}
