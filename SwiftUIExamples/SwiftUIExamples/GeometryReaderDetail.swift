//
//  GeometryReaderDetail.swift
//  SwiftUIExamples
//
//  Created by 杨涛 on 2021/12/29.
//

import SwiftUI

struct GeometryReaderDetail: View {
    var body: some View {
GeometryReader {
    gr in

    // .global 表示的是整个手机屏幕的范围，包含最上面的导航条,(0,0)是整个屏幕的左上角.
    // .local  表示的是这个灰色容器的范围,(0,0)是这个容器的左上角,
    //     如果容器没有设置frame中的height和width的高度,那么(0,0)就是除去最上方导航条的左上角位置。
    
    VStack {
        VStack {
            // 本容器,在本例中,是指灰色阴影部分,包含橙色、蓝色、绿色等阴影部分
            // 这里容器设置的宽度和高度均未超过屏幕,若设置超过的情况下,下面括号内的计算方式就会不适用！
            
            // gr.frame(in: .global).width  代表容器本身的宽度
            Text("global->width:\(gr.frame(in: .global).width)")
            // gr.frame(in: .global).height 代表容器本身的高度
            Text("global->height:\(gr.frame(in: .global).height)")
            // gr.frame(in: .global).minX   代表容器最左侧距离屏幕左侧的距离
            Text("global->minX:\(gr.frame(in: .global).minX)")
            // gr.frame(in: .global).maxX   代表容器最右侧距离屏幕左侧的距离(width + minX)
            Text("global->maxX:\(gr.frame(in: .global).maxX)")
            // gr.frame(in: .global).midX   代表容器中间距离屏幕左侧的距离(width/2 + minX)
            Text("global->midX:\(gr.frame(in: .global).midX)")
            // gr.frame(in: .global).minY   代表容器顶部距离屏幕顶部的距离
            Text("global->minY:\(gr.frame(in: .global).minY)")
            // gr.frame(in: .global).maxY   代表容器底部距离屏幕顶部的距离(height + minY)
            Text("global->maxY:\(gr.frame(in: .global).maxY)")
            // gr.frame(in: .global).midY   代表容器中间距离屏幕顶部的距离(height/2 + minX)
            Text("global->midY:\(gr.frame(in: .global).midY)")
            
        }
        .frame(width:300, height:200)
        .background(Color.orange.opacity(0.3))

        VStack {
            // gr.frame(in: .local).width  代表容器本身的宽度(与.global一样)
            Text("local->width:\(gr.frame(in: .local).width)")
            // gr.frame(in: .local).height 代表容器本身的高度(与.global一样)
            Text("local->height:\(gr.frame(in: .local).height)")
            // gr.frame(in: .local).minX   代表容器最左侧,也就是0
            Text("local->minX:\(gr.frame(in: .local).minX)")
            // gr.frame(in: .local).maxX   代表容器右侧距离容器左侧的距离(就是width,不管是否超出屏幕)
            Text("local->maxX:\(gr.frame(in: .local).maxX)")
            // gr.frame(in: .local).midX   代表容器中间距离容器左侧的距离(就是width/2)
            Text("local->midX:\(gr.frame(in: .local).midX)")
            // gr.frame(in: .local).minY   代表容器顶部,也就是0
            Text("local->minY:\(gr.frame(in: .local).minY)")
            // gr.frame(in: .local).maxY   代表容器底部距离容器顶部的距离(就是height)
            Text("local->maxY:\(gr.frame(in: .local).maxY)")
            // gr.frame(in: .local).midY   代表容器中间距离容器顶部的距离(就是height/2)
            Text("local->midY:\(gr.frame(in: .local).midY)")
        }
        .frame(width:300, height:200)
        .background(Color.blue.opacity(0.3))
        
        VStack(alignment: .leading) {
            // 因为是gr,所以是最外面容器的width和height
            Text("gr->size->width:\(gr.size.width)")
            Text("gr->size->height:\(gr.size.height)")
        }
        .frame(width:300, height:100)
        .background(Color.green.opacity(0.3))
        
        // .path修饰器 貌似只能给图形使用,用于绘制自定义形状
        // 通过GeometryReader 的 GeometryProxy(即上面用到的gr),
        // CGRect(x:y:width:height:),其中当x:0 y:0时会指向其原始的位置,
        // 可将元素定位到指定位置.
        Rectangle()
            .path(in: CGRect(x: gr.size.width + 3, y: 0, width: 50, height: 50))
            .fill(Color.red).opacity(0.2)
            //.frame(width: 30, height: 30) 注意:再使用frame的话,图形的位置就会还原,.path就无效了
                        
    }
    .font(.title3)
}
        // 如果frame中的width或height设置过大,以致超过屏幕,那么类似minX/minY等就有可能是负数了
        .frame(width:300,height:800)
        .background(Color.gray.opacity(0.5))
    }
}

struct GeometryReaderDetail_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderDetail()
    }
}
