//
//  ContentView.swift
//  teamProject
//
//  Created by HARMON, AUDREY on 4/10/24.
//

import SwiftUI

// API url  https://api.github.com/search/users?q=greg


//indivisual User from the json
struct User: Codable { // creating variables to store user  data from JSON response
    public var login: String
    public var url: String
    public var avatar_url:String
    public var html_url: String
}
// the items array from the JSON
struct Result: Codable {
    var items:[User] // JSON RESULT
}

struct ContentView: View {
    @State var users:[User] = [] // array for users
    @State var searchText = "" // empty string for input
    var body: some View {
        NavigationStack{
            if users.count == 0 && !searchText.isEmpty{
                //display a progress spinning wheel if no data has been pulled yet
                VStack{
                    ProgressView().padding()
                    Text("Fetching Users...")
                        .foregroundStyle(Color.purple)
                        .onAppear{
                            getUsers()
                        }
                }
            } else {
                // bind the list to the User array
                // show the users in list
                List(users, id:\.login) {user in
                    // links to their github profile using Safari
                    Link(destination:URL(string:user.html_url)!){
                        
                        
                        // diplay the image
                        HStack(alignment:.top){
                            AsyncImage(url:URL(string: user.avatar_url)){ response in
                                switch response {
                                case .success(let image):
                                    image.resizable()
                                        .frame(width:50, height: 50)
                                default:
                                    Image(systemName:"nosign")
                                }
                            }
                        }
                        
                        // display the user info
                        VStack(alignment: .leading){
                            Text(user.login)
                            Text("\(user.url)")
                                .font(.system(size:11))
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
        }.searchable(text:$searchText) // on submit get users that match the input search text
            .onSubmit(of: .search){
                getUsers()
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
        if let apiURL = URL(string:"https://api.github.com/search/users?q=\(trimmedSearchText)"){ // search the api data
            var request = URLRequest(url:apiURL) // store the request response
            request.httpMethod = "GET" // grab the request response
            URLSession.shared.dataTask(with: request){ // stores data in memory using session
                data, response,error in // grab data from response and process error
                if let userData = data {
                    if let usersFromAPI = try? JSONDecoder().decode(Result.self, from: userData){
                        users = usersFromAPI.items 
                        print(users)
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    ContentView()
}
