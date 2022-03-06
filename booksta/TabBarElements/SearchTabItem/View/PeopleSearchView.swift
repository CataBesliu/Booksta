//
//  PeopleSearchView.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI

struct PeopleSearchView: View {
    @Binding var ownIndex: Int
    @Binding var bookViewIndex: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                Spacer()
                Text("People search")
                    .padding(5)
                
                //                Spacer()
            }
            ScrollView {
//                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
//                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
//                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
//                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
//                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
                Text("bfdjbdbvdsvbdbvkdbvksdvbsdkvbsdbvksbvkjdsvsdvdsvsdvsdvsvsd")
            }
            Spacer()
            
        }
        .padding()
        .padding(.bottom, 30)
        .background(Color.bookstaBackground)
        .clipShape(PeopleSearchShape())
        .contentShape(PeopleSearchShape())
        .onTapGesture {
            self.ownIndex = 1
            self.bookViewIndex = 0
        }
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
        .cornerRadius(20)
        
    }
}

//struct PeopleSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleSearchView(ownIndex: <#Binding<Int>#>, bookViewIndex: <#Binding<Int>#>)
//    }
//}
