//
//  ContentView.swift
//  ClintonResumeSwiftUI
//
//  Created by student on 2/6/21.
//

import SwiftUI
import Combine

struct Resume: Codable, Hashable{
    let loc, state, phone, github, email: String
    let zip: Int
    let education: [Education]
    let experiences: [Experience]
    let languages, technical, tools: [String]
    
}

struct Education: Codable, Identifiable, Hashable{
    let id: Int
    let degree, emphasis, at, state, city, graduated, website: String
    let gpa: Double
}

struct Experience: Codable, Identifiable, Hashable{
    let id: Int
    let title, start, end, company, state, city: String
    let tasks: [String]
}

class NetworkManager: ObservableObject {
  // 1.
    @Published var resume = [Resume]()
     
    init() {
        let url = URL(string: "https://echtniet.github.io/resume.json")!
        // 2.
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let resumeData = data {
                    // 3.
                    let decodedData = try JSONDecoder().decode([Resume].self, from: resumeData)
                    DispatchQueue.main.async {
                        self.resume = decodedData
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var nManager = NetworkManager()
    var body: some View {
        NavigationView {
            List{
                ForEach(nManager.resume, id: \.self){res in
                    Text(res.loc)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
