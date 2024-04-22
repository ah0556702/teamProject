////
////  ContentView.swift
////  teamProject
////
////  Created by HARMON, AUDREY on 4/10/24.
////
//

import SwiftUI

struct Notice: Codable {
    var date_of_birth: String
    var nationalities: [String]
    var entity_id: String
    var forename: String
    var name: String
}

struct APIResponse: Codable {
    var total: Int
    var query: QueryInfo
    var _embedded: EmbeddedData
}

struct QueryInfo: Codable {
    var page: Int
    var resultPerPage: Int
}

struct EmbeddedData: Codable {
    var notices: [Notice]
}

struct ContentView: View {
    @State private var notices: [Notice] = []

    var body: some View {
        NavigationView {
            List(notices, id: \.entity_id) { notice in
                VStack(alignment: .leading) {
                    Text("Name: \(notice.forename) \(notice.name)")
                    Text("Date of Birth: \(notice.date_of_birth)")
                    Text("Nationalities: \(notice.nationalities.joined(separator: ", "))")
                }
            }
            .navigationTitle("Red Notices")
            .onAppear {
                getNotices()
            }
        }
    }

    func getNotices() {
        // Replace this with your API endpoint URL
        guard let url = URL(string: "https://ws-public.interpol.int/notices/v1/red?") else {
            print("Invalid API endpoint URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.notices = apiResponse._embedded.notices
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

