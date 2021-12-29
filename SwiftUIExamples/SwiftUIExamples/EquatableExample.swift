//
//  EquatableExample.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2021/12/29.
//  借鉴：https://www.jianshu.com/p/a36a53d368a9 by 老马的春天

import SwiftUI

struct EquatableExample: View {
    @State private var n: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            // 1.第一种调用方式
            OddOrEvenView(number: n)
            // 2.第二种调用方式
            //EquatableView(content: OddOrEvenView(number: n))
            // 3.第三种调用方式
            // OddOrEvenView(number: n).equatable()
            
            Text("\(n)")
                .foregroundColor(.primary)
                .padding(.vertical,20)
            
            Button("Random an Integer from 10 to 1000") {
                self.n = Int.random(in: 10...1000)
            }
            .padding(.vertical,20)
            
            Spacer()
        }
    }
}

extension Int {
    var isOdd: Bool {self % 2 != 0}
    var isEven: Bool {self % 2 == 0}
}

// Equatable类型,
// 因为要遵循Equatable协议,所以经查询文档,
// 可以实现static func == (lhs: Self, rhs: Self) -> Bool 这个静态方法，
// 后续即可根据该方法来确定内部的body体是否要刷新了。
// Equatable类型的struct内部函数什么时候会更新？
// 如果某个View实现了Equatable协议，只有当其内部存在复杂属性的情况下，系统才会调用Equatable协议中的函数
// 复杂函数,类似于用 @State,ObservedObject或者environmentObject等,与之对应的基本数据类型.
// 也就是下面定义的show变量。
// 总结两点：
// 1.当view中包含复杂属性的时候，如果view实现了Equatable协议，则调用我们写的协议函数;
// 2.当view中不包含复杂属性的时候，如果实现了Equatable协议，则系统会自动根据view值的变化进行刷新，如果没有实现Equatable协议，则每次都需要计算body.
struct OddOrEvenView: View, Equatable {
    let number: Int
    @State private var show = false
    
    var body: some View {
        print("OddOrEvenView is updated, -- \(self.number)")
        return VStack {
            Text("\(number.isOdd ? "Odd" : "Even")")
                .font(.largeTitle)
                .padding(20)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 15).fill(number.isOdd ? Color.green : Color.red))
            // 特别这里再定义了一个Text,会发现下次出现同是单数或偶数时,这里的Text是不更新的,可以观察一下。
            Text("\(number)")
        }
    }
    
    static func == (lhs: OddOrEvenView, rhs: OddOrEvenView) -> Bool {
        return lhs.number.isOdd == rhs.number.isOdd
    }
}

struct EquatableExample_Previews: PreviewProvider {
    static var previews: some View {
        EquatableExample()
    }
}
