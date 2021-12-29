//
//  MyRoundedCorners.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2021/12/29.
//

import SwiftUI

struct MyRoundedCorners: View {
    var body: some View {
        VStack {
            HStack {
                Text("SwiftUI")
                    .foregroundColor(.black).font(.title).padding(15)
                    .background(RoundedCorners(color: .green, tr: 30, bl: 30))
                
                Text("Lab")
                    .foregroundColor(.black).font(.title).padding(15)
                    .background(RoundedCorners(color: .blue, tl: 30, br: 30))
            }
            .padding(20).border(Color.gray).shadow(radius:3)
            
            HStack {
                Text("SwiftUI")
                    .foregroundColor(.black).font(.title).padding(15)
                    // 或者将.background()换成 overlay配合opacity 也是一样的效果
                    .overlay(RoundedCorners(color: .green, tr: 30, bl: 30).opacity(0.5))
                
                Text("Lab")
                    .foregroundColor(.black).font(.title).padding(15)
                    .overlay(RoundedCorners(color: .blue, tl: 30, br: 30).opacity(0.5))
            }
            .padding(20).border(Color.gray).shadow(radius:3)
        }
    }
}

struct RoundedCorners: View {
    var color: Color = .black
    var tl: CGFloat = 0.0 // top-left radius parameter
    var tr: CGFloat = 0.0 // top-right radius parameter
    var bl: CGFloat = 0.0 // bottom-left radius parameter
    var br: CGFloat = 0.0 // bottom-right radius parameter
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                // We make sure the radius does not exceed the bounds dimensions
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}

struct MyRoundedCorners_Previews: PreviewProvider {
    static var previews: some View {
        MyRoundedCorners()
    }
}
