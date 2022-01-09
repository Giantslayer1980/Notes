//
//  PickerExample.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2022/1/9.
//

import SwiftUI

struct PickerExample: View {
    @State var preferSeason = Season.summer
    
    // enum类型需要被迭代时,必须符合CaseIterable协议
    enum Season: String, CaseIterable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                Label("Picker的.pickerStyle为.segment:", systemImage: "1.circle")
                Spacer()
            }.padding()
            Picker("喜欢的季节", selection: $preferSeason) {
                // Season遵循CaseIterable协议后,可使用allCases属性去迭代
                ForEach(Season.allCases, id: \.self) {season in
                    Text(season.rawValue).tag(season)
                }
            }
                // 这里是水平展示所有可选项的.segment,
                .pickerStyle(.segmented)
                .padding()
            
            Divider()
            
            HStack {
                Label("Picker的.pickerStyle为.menu:", systemImage: "2.circle")
                Spacer()
            }.padding()
            Picker("喜欢的季节", selection: $preferSeason) {
                // Season遵循CaseIterable协议后,可使用allCases属性去迭代
                ForEach(Season.allCases, id: \.self) {season in
                    Text(season.rawValue).tag(season)
                }
            }
                // 还有只单一显示被选中项目的.menu,其他备选项不显示
                .pickerStyle(.menu)
                .padding(.top,0)
            
            Divider()
            
            HStack {
                Label("Picker的.pickerStyle为.inline/.wheel:", systemImage: "3.circle")
                Spacer()
            }.padding()
            Picker("喜欢的季节", selection: $preferSeason) {
                // Season遵循CaseIterable协议后,可使用allCases属性去迭代
                ForEach(Season.allCases, id: \.self) {season in
                    Text(season.rawValue).tag(season)
                }
            }
                // 竖式显示所有可选项的.inline和.wheel
                .pickerStyle(.inline)
                .padding(.top,0)
                .padding(.bottom,0)
            Divider()
        }
    }
}

struct PickerExample_Previews: PreviewProvider {
    static var previews: some View {
        PickerExample()
    }
}
