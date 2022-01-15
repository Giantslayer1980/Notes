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

### ForEach中\\.self使用的注意事项
如果一个对象遵循Identifiable协议,比如:
``` Swift
struct Student: Identifiable {
    let id: UUID = UUID()
    var name: String
    var strings: [String]
    var colors: [Color]
}
```
那么可以在ForEach中这样使用：
``` Swift
var students: [Student] = [
    Student(name: "A", strings: ["a"], colors: [Color(.green)]),
    Student(name: "B", strings: ["b"], colors: [Color(.green)]),
    Student(name: "C", strings: ["c"], colors: [Color(.red)])
]
ForEach(students) { student in
    print(student.name)
}
```
显示结果为：
> A B C

当Student遵循Identifiable协议时,ForEach中就不必使用id:\\.self。
如果不遵循Identifiable协议时,就需要我们指定唯一属性的key path,
（Student下面的name/strings/colors属性都可以作为key path来使用,
因为都可以计算哈希值）
但如果连key path也没有的话,我们可以用\\.self。
当使用\.self时,就是将整个结构对象的组合(如students)中的每个元素来一一迭代的话,
就需要被迭代的每个元素结构遵循Hashable协议，例如：
``` Swift
struct Student: Hashable {
    var name: String
    var strings: [String]
    var colors: [Color]
}
```
此时,ForEach内可以使用id的是:
\\.self | \\.name | \\.strings | \\.colors
而如果Student既不遵循Identifiable,也不遵循Hashable:
``` Swift
struct Student {
    var name: String
    var strings: [String]
    var colors: [Color]
}
```
那么ForEach内可以使用id的是:
\\.name | \\.strings | \\.colors
也就是说\\.self不能使用。

实际上,ForEach是在检索每个被迭代元素的哈希值,所以对于一个结构来说，一定要经过遵循并计算哈希值后,才可以被迭代。

如果哈希值相同的情况,会出现什么问题呢？
``` Swift
ForEach(students, id:\.colors) {
    student in
    print(student.name)
}
```
因为Students中前两个元素的colors属性完全相同,
那么初始计算的时候,这两个元素的索引哈希值也相同,
所以显示结果是：
> A A C

这是平时使用当中需要注意的问题。


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

### ProgressView 进度条
用法:
ProgressView(value: 5, total: 15)

### 为Label的.labelStyle这一modifier,创建新的样式即.trailingIcon,并遵循LabelStyle协议
例如：
``` Swift
Label("10", systemImage: "clock)
    .labelStyle(.xxx) 
```
其中.xxx可以选择 .iconOnly / .titleAndIcon / .titleOnly等等来使用
(只显示icon / 按照 icon + title 的次序显示 / 只显示title)。
而此处为其添加新的选项,即 .trailingIcon,看字面意思就是和.titleAndIcon相反的,
即把Icon放最后,而title放前面的意思。
具体实现：

``` Swift
import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
```

如何使用：
``` Swift

Label("10", systemImage: "clock")
    .labelStyle(.trailingIcon)
```

### ForEach的.onDelete功能
在Section内使用Foreach来依次显示列表内的内容时,
在ForEach内可以使用.onDelete来划动删除特定项。
当划动特定项时,会出现划动后的红色“删除”字样：
![SwiftLogo](./Images/ForEach-onDelete.jpg)
``` swift
Section(header: Text("Attendees")) {
    ForEach(data.attendees) { attendee in
        Text(attendee.name)
    }
    .onDelete { indices in
        data.attendees.remove(atOffsets: indices)
    }
}
```

## Button

### 停用Button -- .disabled
``` Swift
Button(action:{}) {}
    .disabled(someBoolVariableIsEmpty)
```
当变量someBoolVariableIsEmpty为false时,该Button将会被停用。

### sheet modifier on List 的使用
``` Swift
List()
    .sheet(isPresented: $isPresented) {
        ...
    }
```
参数isPresented需要传入的是一个Binding<Bool>。
可以这样理解,因为该sheet会被下拉而退出,
但若下拉后该isPresented参数不被变更为false,则sheet仍会被展现,
这明显是错误的,所以需要进行绑定参数,而非仅仅传一个值给sheet。

### toolbar modifier 的使用
在List的右上角显示工具栏
显示一个"edit"的button按钮：
``` Swift
List()
    .toolbar {
        Button("edit") {
            ...
        }
    }
```
在一个View上面显示"Cancel"和"Done"按钮：
``` Swift
View()
    .toolbar {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                isPresentingEditView = false
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
                isPresentingEditView = false
                scrum.update(from: data)
            }
        }
    }
```
两个按钮是平行排列的，感觉当中还夹着一个Spacer()。

### @State 与 @StateObject / @ObservedObject / @EnvironmentObject 的区别？
the @State property wrapper works only for value types, such as structures and enumerations.
@ObservedObject, @StateObject, and @EnvironmentObject declare a reference type as a source of truth. To use these property wrappers with your class, you need to make your class observable.
总结下来:
1.@State 仅用于Struct 和 Enum 等值类型，存储在View内部；而@StateObject、@ObservedObject和@EnvironmentObject用于引用类型,即class对象，存储在View外部（但可以在View内部命名）。
2.若要使用@ObservedObject、@StateObject和@EnvironmentObject的话，要使得对应的class实现ObservableObject协议。

### @EnvironmentObject 传值的简单示例
这是需要共享的基本数据：
``` Swift
class User: ObservableObject {
    @Published var name = "Taylor Swift"
}
```
接下来是两个用来接收上述数据的结构类型：
``` Swift
struct EditView: View {
    @EnvironmentObject var user: User

    var body: some View {
        TextField("Name", text: $user.name)
    }
}
struct DisplayView: View {
    @EnvironmentObject var user: User

    var body: some View {
        Text(user.name)
    }
}
```
那么,在ContentView中,如何向EditView()和DisplayView传递一个User对象？
``` Swift
struct ContentView: View {
    let user = User()

    var body: some View {
        VStack {
            EditView().environmentObject(user)
            DisplayView().environmentObject(user)
        }
    }
}
```
也可以把ContentView改成这样：
``` Swift
VStack {
    EditView()
    DisplayView()
}
.environmentObject(user)
```
上例把 user 放到 ContentView 的环境中，但是因为 EditView 和 DisplayView 都是 ContentView 的子视图，所以它们自动继承了 ContentView 的环境。
#### .environmentObject(user) 和 @EnvironmentObject var user: User 之间建立联系的？
你会发现,.environmentObject(user)中只有一个user,而不是(user:user),那@EnvironmentObject var user: User是如何正确识别并接收的呢？
查了资料,有称是通过字典的类型存键和类型存值来进行的。比如键存的是数据类型,就是User,而值就是User()。
真的是这样吗？
那如果我同时传递两个相同类型的对象,接收方如何区分？



