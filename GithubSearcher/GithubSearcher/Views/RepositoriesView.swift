//
//  RepositoryView.swift
//  GithubSearcher
//
//  Created by nakajima on 2021/09/21.
//

import SwiftUI

struct RepositoryView: View {
    weak var delegate: ViewProtocol?
    let repositoryUrlString: String
    //    @ObservedObject var model: GithubModel

    var body: some View {
        Text("temp")
        //        if let error = model.error {
        //            Text(error.localizedDescription)
        //        } else {
        //            if model.isLoading {
        //                ProgressView()
        //                    .scaleEffect(x: 3, y: 3, anchor: .center)
        //            } else {
        //                if model.repositories.isEmpty {
        //                    Text("No Repository")
        //                } else {
        //                    List(model.repositories) { repository in
        //                        RepositoryRow(repository: repository)
        //                    }
        //                }
        //            }
        //        }
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(repositoryUrlString: "https://api.github.com/users/0si43/repos")
    }
}
