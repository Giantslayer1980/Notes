//
//  Tabbar.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2021/12/31.
//

import SwiftUI

struct Tabbar: View {
    @State var selectedTabbar = 3
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTabbar) {
                // selection的值,是对应下面tag()内的值的
                MainContentView(title: "1")
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("1")
                    }.tag(0)
                MainContentView(title: "2")
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("2")
                    }.tag(1)
                MainContentView(title: "3")
                    // 这里虽然注释了.tabItem,但下方仍旧占位了
                    // .tabItem {
                    //     Image(systemName: "3.circle")
                    //     Text("3")
                    // }.tag(2)
                MainContentView(title: "4")
                    .tabItem {
                        Image(systemName: "4.circle")
                        Text("4")
                    }.tag(3)
                MainContentView(title: "5")
                    .tabItem {
                        Image(systemName: "5.circle")
                        Text("5")
                    }.tag(4)
            }
            .statusBar(hidden: false)
            .foregroundColor(.orange)
            .accentColor(.green)
            .navigationBarHidden(true)
        }
    }
}
    
struct MainContentView: View {
    @State var title: String
    var body: some View {
        VStack {
            LinkImage(title: title)
        }
    }
}
    
struct LinkImage: View {
    @State var title: String
    var body: some View {
        NavigationLink(destination: NextView()) {
            Image(systemName: title + ".circle")
                .resizable()
                .frame(width:200, height: 200)
        }
    }
}

struct NextView: View {
    var body: some View {
        Text("下一页")
            .navigationBarTitle(Text("下一页"), displayMode: .inline)
    }
}
    
struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
