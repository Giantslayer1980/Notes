//
//  Instrument.swift
//  SwiftUIExamples
//
//

import SwiftUI

struct Instrument: View {
    @State private var value = 45.0
    
    var body: some View {
        VStack {
            Spacer()
            InstrumentItem(value: $value)
            Slider(value: $value, in: 0...200, step: 1)
                .padding(.horizontal, 20)
            HStack {
                Spacer()
                Button(action: {
                    self.value = 0
                }) {
                    Text("最小值")
                }.foregroundColor(.blue)
                Spacer()
                Button(action: {
                    self.value = 200
                }) {
                    Text("最大值")
                }.foregroundColor(.blue)
                Spacer()
            }
            Spacer()
        }.padding(.top,50)
    }
}

struct InstrumentItem: View {
    let lowLocations: [Double] = [-22.5, 0, 22.5, 45, 67.5, 90, 112.5, 135, 157.5, 180, 202.5]
    let longLocations: [Double] = [-11.25, 11.25, 33.75, 56.25, 78.75, 101.25, 123.75, 146.25, 168.75, 191.25]
    let texts: [String] = ["0", "20", "40", "60", "80", "100", "120", "140", "160", "180", "200"]
    @Binding var value: Double
    
    var body: some View {
        ZStack {
            // 屏幕正中间数值的显示
            Text("\(value, specifier: "%0.0f")")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.orange)
                .offset(x: 0, y: 40)
            
            // 因为是ZStack布局,
            // 所以图形中的短针实质上都偏移到了原始位置的(-150,0)处,
            // 随后对每个短针进行.rotationEffect()相对原点的旋转角度操作
            // 而旋转的角度是迭代lowLocation列表中的元素,
            // 后续的长针以及刻度数值都是一样的原理。
            ForEach(lowLocations, id:\.self) {item in
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 20, height: 6)
                    .offset(x: -150, y: 0)
                    .rotationEffect(.init(degrees: item))
                    .onTapGesture {
                        self.tapLow(angle: item)
                    }
            }
            
            ForEach(longLocations, id: \.self) { item in
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 40, height: 8)
                    .offset(x: -140, y: 0)
                    .rotationEffect(.init(degrees: item), anchor: .center)
                    .onTapGesture {
                        self.tapLong(angle: item)
                }
            }
            
            ForEach(lowLocations, id: \.self) {
                Text("\(self.texts[self.lowLocations.firstIndex(of: $0)!])")
                    .font(.system(size: 18, weight: Font.Weight.bold))
                    .foregroundColor(.orange)
                    .rotationEffect(.init(degrees: -$0), anchor: .center)
                    .offset(x: -120, y: 0)
                    .rotationEffect(.init(degrees: $0), anchor: .center)
            }
            
            // 因为是要返回中心点和指针的复合图形,
            // 所以返回的图形要遵循Shape协议,
            // 所以创建了Needle结构用来调用。
            Needle()
                .fill(Color.orange)
                .frame(width: 140, height: 6)
                .offset(x: -70, y: 0)
                .rotationEffect(.init(degrees: getAngle(value: value)), anchor: .center)
                .animation(.linear)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.orange)
        }.padding(.vertical, 80)
    }
    
    func tapLow(angle: Double) {
        value = Double(self.lowLocations.firstIndex(of: angle)!) * 20
    }
    
    func tapLong(angle: Double) {
        value = Double(self.longLocations.firstIndex(of: angle)!) * 20 + 10
    }
    
    func getAngle(value: Double) -> Double {
        return value/200*225-22.5
    }
}

// 继承Shape协议的结构,内部会自动实现path方法,其中的内部参数rect实质上是该结构实例的具体属性，
// 包涵了该结构实例的大小等属性。
struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

struct Instrument_Previews: PreviewProvider {
    static var previews: some View {
        Instrument()
            //.previewInterfaceOrientation(.portrait) 竖屏正常显示,默认显示
            //.previewInterfaceOrientation(.landscapeRight) 横屏且导览条在左侧显示
            //.previewInterfaceOrientation(.landscapeLeft) 横屏且导览条在右侧显示
            //.previewInterfaceOrientation(.portraitUpsideDown) 竖屏倒着显示
            .previewInterfaceOrientation(.landscapeRight)
    }
}
