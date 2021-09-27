//
//  UserSearchView.swift
//  GithubSearcher
//
//  Created by nakajima on 2021/09/21.
//

import SwiftUI

struct UsersSearchView: View {
    weak var delegate: ViewProtocol?
    @State private var searchText: String = ""
    let type: StateType
    enum StateType {
        case display([User])
        case notFound
        case error(ModelError)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("user name", text: $searchText)
                    .onChange(of: searchText) { _ in
                        delegate?.loadUser(query: searchText)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .padding()
                Spacer()
                switch type {
                case .display(let users):
                    List(users) { user in
                        NavigationLink(destination: RepositoriesView(delegate: delegate,
                                                                     repositoryUrlString: user.reposUrl)
                                        .onAppear { delegate?.loadReository(urlString: user.reposUrl) }) {
                            UserRow(user: user)
                        }
                    }
                    .refreshable {
                        delegate?.loadUser(query: searchText)
                    }
                case .notFound:
                    Text("user not found")
                case .error(let error):
                    Text(error.localizedDescription)
                }
                Spacer()
            }
            .navigationTitle("🔍Search Github User")
        }
    }
}

struct UsersSearchView_Previews: PreviewProvider {
    static var previews: some View {
        UsersSearchView(type: .notFound)
        UsersSearchView(type: .display([User.mockUser]))
        UsersSearchView(type: .error(.jsonParseError("invalid text")))
    }
}
