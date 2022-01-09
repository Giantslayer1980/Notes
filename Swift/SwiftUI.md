### 读取JSon文件里的内容并形成一个Struct实例
这里是一个泛型函数(GenericFunction)，传入的参数T要求遵守Decodable协议
为什么T要符合Decodable协议?
因为要从JSon文件中取得数据,就存在将结果解码decode的过程,
所以这里要返回的是一个遵循Decodable协议的T类型。

``` Swift
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    // 关于Bundle:
    // 当Xcode构建iOS app时,即创建了一种叫Bundle的东西,它可以存在app中所有的文件.
    // 当要读取main app bundle里的一个文件时,就用到了Bundle.main.url(),
    // Bundle.main.url()得到的是一个optional,所以需要解包.
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Could't load \(filename) from main bundle:\n\(error)")
    }
    
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Could't parse \(filename) as \(T.self):\n\(error)")
    }
}
```

### Codable协议
Codable协议的一个简单实例
Codable protocol is composed of Encodable and Decodable.
Codable = Encodable & Decodable

``` Swift
import Foundation

// JSon是类似于{"id":"1001","name":"Shaddy","grade":11}这样的数据格式,
// 而Codable协议,可编码为在网络上最广泛使用的JSon数据格式,
// 后续进行JSONEncoder().encode()编码时,放入的参数必须遵循该协议
struct Student: Codable {
    var id: String
    var name: String
    var grade: Int
}

let student = Student(id: "1001",name: "Shaddy", grade: 11)

do {
    // 将遵循Codable协议的结构,转换为JSon数据
    let jsonEncoder = JSONEncoder()
    // jsonEncoder.encode(_ value: Encodable)
    let jsonData = try jsonEncoder.encode(student)

    // 这里为了方便显示,将jsonData转换为字符串形式,实际项目中直接将jsonData传出即可
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    print("result: \(jsonString)")
    // result: {"id":"1001","name":"Shaddy","grade":11}

    // 这里将json数据解码decode回来
    let jsonDecoder = JSONDecoder()
    // jsonDecoder.decode(type: Decodable.Protocol, from: Data)
    let jsonDecoderData = try jsonDecoder.decode(Student.self, from: jsonData)
    print("result: \(jsonDecoderData)")
    // result: Student(id: "1001", name: "Shaddy", grade: 11)
}
```
> https://www.jianshu.com/p/f39994e045d2

### 向网页POST数据
``` Swift
import UIKit
struct Post: Encodable, Decodable {
    var body: String?
    var title: String?
    var id: Int
    var userId: Int
}
// 向特定网页POST数据
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

let post = Post(body: "给我滚出去", title: "你好啊，小明", id: 787, userId: 87)
do {
    let jsonBody = try JSONEncoder().encode(post)
    request.httpBody = jsonBody
} catch {
}

let session = URLSession.shared

session.dataTask(with: request) { (data, response, error) in
    guard let data = data else { return }
    do{
        let json = try JSONDecoder().decode(Post.self, from: data)
        print(json)
    }catch{
        print(error)
    }
}.resume()
```

### 从网页取数据
``` Swift
//从特定网页取数据
import UIKit
struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var phone: String
    var website: String
    var company: Company
    var address: Address
}

let url2 = URL(string: “https://jsonplaceholder.typicode.com/users")!

let session = URLSession.shared
session.dataTask(with: url2) { (data, response, error) in
    guard let data = data else { return }
    do{
        //原始解析方法
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                print(json)

        let users = try JSONDecoder().decode([User].self, from: data)
//        print(users)
        for user in users{
            print(user.address.geo.lat)
        }
    }catch{
        print(error)
    }
}.resume()
```

### @Binding页面如何初始化preview
因为某些页面有初始化@Binding的变量,那么该页面需要preview的话,如何生成预览呢？
一个是自己生成一些测试数据,
另一个就是使用.constant函数:
``` Swift 
struct RFSearchListView_Previews: PreviewProvider {

    static var previews: some View {
        RFSearchListView(items: .constant(["a","b","C"]))
    }
}
```
在Picturepreview项目中的PicturePreview.swift文件中,
使用的是:
``` Swift
PicturePreview(pictures: pictures, selectedPicture: .constant(nil))
```

### Substring 与 String
Substring并不是String的子类，这是两个不同的类型，但是它们都继承了StringProtocol协议，因此存在一些共性；在开发中Substring并不常用(目前只在分割String见到)，所以往往要转成String。
字符串使用split()分割的时候,得到的是[Sbustring],所以要得到[String]的话,还需要再转换。
比如：
``` Swift
var a:[String] = “”“
A
B
“””.split(separator: “\n”).map{String($0)}
```
必须要把Substring转换成String才行。

### Identifiable的使用
我们知道,当遍历一个结构的时候,
比如
``` Swift
struct SomeItem { let id = UUID() }
ForEach(someItems, id:\.id)
```
或者上述结构没有定义id时,则需要用到：
``` Swift
ForEach(someItems, id:\.self),
```
因此需要带有id:\.id或者id:\.self。
但Identifiable就比较方便了：
``` Swift
struct SomeItem: Identifiable { let id = UUID() }
```
这时候就可以这样简便的：
``` Swift
ForEach(someItems) { item in
      	……
}
```

### Alamofire模块的导入及使用
#### Alamofire模块的导入
1. 从github下载, https://gitcode.net/mirrors/Alamofire/ ,并解压
2. 打开需要使用Alamofire的项目,菜单栏中:File->Add Files to “项目名称”
3. 在弹出选择界面勾选“Copy items if needed”,找到下载解压好的Alamofire位置,选择Alamofire.xcodeproj
4. 但有时以上做完,还是无法import Alamofire,这时要在xcode的项目目录，选择最外层这个项目名称，基本的General设置里的Frameworks,Libraries,and Embedded Content里将Alamofire添加到项目的静态库中
5. 接下来项目就可以import Alamofire了。
#### Alamofire模块的使用
貌似还没法用,下次有机会再试一下
关于使用方法在：https://www.jianshu.com/p/07b1ec36a689
以后可以参考下，但Alamofire.request这个方法就不可以用了