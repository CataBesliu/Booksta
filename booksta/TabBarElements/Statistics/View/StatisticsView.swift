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
    @State private var selectedOption = "last month"
    private var menuOptions = ["this year","last month"]
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            dropDownView
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
                    if selectedOption == menuOptions[0] {
                        getYearPostsChart(postsModel: viewModel.postsForUsers)
                            .zIndex(1)
                    } else {
                        getMonthPostsChart(postsModel: viewModel.postsForUsers)
                            .zIndex(1)
                    }
                }
            case let .error(error):
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            }
            Spacer()
        }
        .onAppear {
            viewModel.resetState()
            viewModel.fetchData()
        }
        .padding()
        .bookstaNavigationBar(showBackBtn: false, onBackButton: {})
        }
    }
    
    private var dropDownView: some View {
        Menu {
            Button {
                selectedOption = menuOptions[1]
            } label: {
                Text("\(menuOptions[1])")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 16, weight: .semibold))
            }
            Button {
                selectedOption = menuOptions[0]
            } label: {
                Text("\(menuOptions[0])")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 16, weight: .semibold))
            }
        } label: {
            HStack {
                Text("Show posts written from:")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 16, weight: .bold))
                Text("\(selectedOption)")
                    .foregroundColor(.bookstaPurple)
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
    
    func getMonthPostsChart(postsModel: [(user: UserModel, posts: [PostModel])]) -> some View {
        VStack {
            if postsModel.count > 0 {
                let usernames = postsModel.map({ return $0.user.username })
                BarChart(selectedItem: $text,
                         chartLegend: "Posts written",
                         usernames: usernames,
                         entries: getCharEntries(postsModel: postsModel))
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color.white)
                
                Text(text)
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            }
        }
    }
    
    func getYearPostsChart(postsModel: [(user: UserModel, posts: [PostModel])]) -> some View {
        VStack {
            if postsModel.count > 0 {
                let usernames = postsModel.map({ return $0.user.username })
                LineChart(selectedItem: Binding.constant(""),
                          chartLegend: "Posts written",
                          usernames: usernames,
                          entries: getYearCharEntries(postsModel: postsModel))
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color.white)
                
                Text(text)
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
            }
        }
    }
    
    func getCharEntries(postsModel: [(user: UserModel, posts: [PostModel])]) -> [BarChartDataEntry] {
        let currentMonth = calendar.component(.month, from: ReviewModel.getDate(data: ReviewService.getDate())!)
        let lastMonthPostsModel = postsModel.map { postModel in
            return (user: postModel.user, posts : postModel.posts.filter({ calendar.component(.month, from: $0.timestamp!) == currentMonth }))
        }
        let barCharEntries = zip(lastMonthPostsModel.indices, lastMonthPostsModel).map { (index, element) in
            return BarChartDataEntry(x: Double(index), y: Double(element.posts.count))
        }
        return barCharEntries
    }
    
    func getYearCharEntries(postsModel: [(user: UserModel, posts: [PostModel])]) -> [[ChartDataEntry]] {
        let currentMonth = calendar.component(.month, from: ReviewModel.getDate(data: ReviewService.getDate())!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let allPosts = postsModel.map({ postModel -> (username: String, posts: [Int]) in
            let postsSorted = (1...currentMonth).map({month in
                return postModel.posts.filter({calendar.component(.month, from: $0.timestamp!) == month }).count
            })
            return (username: postModel.user.username, posts: postsSorted)
        })

        var arrayChartDataEntry: [[ChartDataEntry]] = []
        allPosts.forEach { item in
            var lineChartEntry: [ChartDataEntry] = []
            for (i, postsNr) in item.posts.enumerated() {
                lineChartEntry.append(ChartDataEntry(x: Double(i), y: Double(postsNr), data: item.username))
            }
            arrayChartDataEntry.append(lineChartEntry)
        }
        return arrayChartDataEntry
    }
}
