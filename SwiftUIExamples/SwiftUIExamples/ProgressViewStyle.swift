//
//  ProgressViewStyle.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2022/1/16.
//

import SwiftUI

struct SomeProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                // 默认进度条的背景色被黑色
                .fill(Color(.black))
                .frame(height: 20.0)
            if #available(iOS 15.0, *) {
                ProgressView(configuration)
                    // 指定进度条的消逝部分为蓝色
                    .tint(Color(.blue))
                    .frame(height: 12.0)
                    .padding(.horizontal)
            } else {
                ProgressView(configuration)
                    // 默认进度条的消逝部分为蓝色,且不能更改
                    .frame(height: 12.0)
                    .padding(.horizontal)
            }
        }
    }
}

struct SomeProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        // ProgressView(value: 0.4) 是一样的效果
        ProgressView(value: 4, total: 10)
            .progressViewStyle(SomeProgressViewStyle())
            .previewLayout(.sizeThatFits)
    }
}
