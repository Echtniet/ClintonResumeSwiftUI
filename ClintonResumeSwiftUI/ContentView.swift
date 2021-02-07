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
    
    @State var selectedIndex = 2
    @State var showModal = false
    
    let tabBarImageNames = ["house.fill", "gear", "graduationcap.fill", "pencil", "line.horizontal.3"]
    let titles = ["Home", "Experience", "Education", "Skills", "About Me"]
    
    init() {
        UITabBar.appearance().barTintColor = .white
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                
                Spacer()
                    .fullScreenCover(isPresented: $showModal, content: {
                        Button(action: {
                            showModal.toggle()
                        }, label: {
                            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                        })
                    })
                ForEach(nManager.resume, id: \.self){ res in
                    switch selectedIndex {
                    case 0:
                        HomeView()
                    case 2:
                        EducationView(education: res.education)
                        
                    default:
                        NavigationView {
                            Text("On tab: \(selectedIndex)")
                                .navigationTitle("Tab \(selectedIndex)")
                        }
                    }
                }
            }
            
            Spacer()
            
            Divider()
                .padding(.bottom, 16)
            
            HStack {
                ForEach(0..<5) { num in
                    Button(action: {
                        selectedIndex = num
                    }, label: {
                        Spacer()
                        VStack {
                            Image(systemName: tabBarImageNames[num])
                                .font(.system(size: 24, weight:. bold))
                                .foregroundColor(selectedIndex == num ? .black : .gray)
                                .padding(.bottom, 2)
                            (selectedIndex == num) ? Text(titles[num]).font(.system(size: 10)).foregroundColor(.black) : Text("")
                        }
                        Spacer()
                    })
                }
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("On tab: 1")
                .navigationTitle("Home")
        }
    }
}

struct EducationView: View {
    
    let education:[Education]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(education, id: \.self){edu in
                    VStack (alignment:.leading){
                        Text(edu.at)
                            .font(.headline)
                        Text(edu.city)
                    }
                }
            }
                .navigationTitle("Education")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
