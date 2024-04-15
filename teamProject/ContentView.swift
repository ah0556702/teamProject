//
//  ContentView.swift
//  teamProject
//
//  Created by HARMON, AUDREY on 4/10/24.
//

import SwiftUI

// API url  https://api.github.com/search/users?q=greg

struct Notice: Codable {
    public var forename: String
    public var surname: String
    public var imgUrl: String
    public var id: String
}

struct Result: Codable{
    var items: [Notice]
}

struct ContentView: View {
    @State var notices:[Notice] = []
    @State var searchText = ""
    var body: some View {
        NavigationStack{
            
        }
    }
    
    // fetches the Users from the github api
    
    func getUsers(){ // function for searching based on user input
        // Add Search content
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines) // take whitespace out of input text
        
        //Proceed only if searchText is not empty or just whitespace
        guard !trimmedSearchText.isEmpty else {
            return
        }
        if let apiURL = URL(string:"https://ws-public.interpol.int/notices/v1/red?nationality=US&page=1&resultPerPage=5"){ // search the api data
            var request = URLRequest(url:apiURL) // store the request response
            request.httpMethod = "GET" // grab the request response
            URLSession.shared.dataTask(with: request){ // stores data in memory using session
                data, response,error in // grab data from response and process error
                if let userData = data {
                    if let usersFromAPI = try? JSONDecoder().decode(Result.self, from: userData){
                        notices = usersFromAPI.items
                        print(notices)
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    ContentView()
}
