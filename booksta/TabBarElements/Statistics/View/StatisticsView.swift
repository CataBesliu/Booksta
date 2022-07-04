//
//  StatisticsView.swift
//  booksta
//
//  Created by Catalina Besliu on 04.07.2022.
//

import SwiftUI
import Charts
import Resolver

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel = Resolver.resolve()
    @State var text = ""
    
    var body: some View {
        VStack {
            switch viewModel.stateUserFollowings {
            case .idle, .loading:
                Text("Loading...")
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            case let .loaded(users):
                ZStack {
                    Text("Loading chart...")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                    getChart(postsModel: viewModel.postsForUsers)
                        .zIndex(1)
                }
            case let .error(error):
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            }
        }
        .onAppear {
            viewModel.resetState()
            viewModel.fetchData()
        }
    }
    
    func getChart(postsModel: [(user: UserModel, posts: [PostModel])]) -> some View {
        VStack {
            if postsModel.count > 0 {
                let usernames = postsModel.map({ return $0.user.username })
                BarChart(usernames: usernames,
                         entries: getCharEntries(postsModel: postsModel),
                         selectedYear: Binding.constant(1),
                         selectedItem: $text)
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color.white)
                
                Text(text)
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            }
        }
    }
    
    func getCharEntries(postsModel: [(user: UserModel, posts: [PostModel])]) -> [BarChartDataEntry] {
        let barCharEntries = zip(postsModel.indices, postsModel).map { (index, element) in
            return BarChartDataEntry(x: Double(index), y: Double(element.posts.count))
        }
        return barCharEntries
    }
}
