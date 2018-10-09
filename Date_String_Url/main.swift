//
//  main.swift
//  Date_String_Url
//
//  Created by fanyunyimac on 2018/9/20.
//  Copyright © 2018年 范云翼. All rights reserved.
//

import Foundation
//作业一:将指定的日期根据时区转换成相应的格式
func getDate(now : Date,zone : Int = 0)-> String {
    let format = DateFormatter()    //格式化类
    format.dateFormat = "yyyy年MM月dd日EEEE aa KK:mm"      //指定格式
    format.locale = Locale.current
    if zone > 0 {
        format.timeZone = TimeZone(abbreviation: "UTC+\(zone):00")
    } else {
        format.timeZone = TimeZone(abbreviation: "UTC+\(zone):00")
    }
    let dateFromString = format.string(from: now)
    return  dateFromString
}
//获取现在的时间
let date = Date()
let beiJing = getDate(now: date, zone: 8)
let tokyo = getDate(now: date, zone: 9)
let newyork = getDate(now: date, zone: -5)
let london = getDate(now: date, zone: 0)
print("第一题：")
print("北京:  "+beiJing+"\n"+"东京:  "+tokyo+"\n"+"纽约:  "+newyork+"\n"+"伦敦:  "+london)

//作业二
let testString = "Swift is a powerful and intuitive programming language for iOS, OS X, tvOS, and watchOS"
print("原字符串是:   "+testString)
let startIndex = testString.index(testString.startIndex, offsetBy: 5)
let endIndex = testString.index(testString.startIndex, offsetBy: 19)
print("第二题：")
print("字串是:")
print(testString[startIndex...endIndex])
print("删除OS后字符串是: "+testString.replacingOccurrences(of: "OS", with: ""))

//作业三
let dic = ["date" : ["beiJIng" : beiJing,"tokyo" : tokyo,"newyork" : newyork,"london" : london] as [String : String], "string" : testString] as AnyObject
//获得默认工作路径
let defaultDoc = FileManager.default
if var path = defaultDoc.urls(for: .documentDirectory, in: .userDomainMask).first?.path{
    //新建文件
    print("第三题： ")
    print("txt文件默认路径:   "+path)
    path.append("fyy.txt")
    print(dic.write(toFile: path, atomically: true))
}


//测试：自定义的类及其子类放在一个数组中存入文件
enum MyKey:CodingKey{
    case sno
}
class Person : Codable{
    var name : String
    var age : Int
    init(name : String,age : Int) {
        self.age = age
        self.name = name
    }
}
class Student : Person{
    var sno : String
    init(name : String,age : Int,sno : String){
        self.sno = sno
        super.init(name: name, age: age)
    }
    //编码方法
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MyKey.self)
        try container.encode(sno, forKey: MyKey.sno)
        try super.encode(to: encoder)
    }
    //解码方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyKey.self)
        self.sno = try container.decode(String.self, forKey: .sno)
        try super.init(from: decoder)
   }
}
let encoder = JSONEncoder()
let decoder = JSONDecoder()
let fyy = Person(name: "fyy", age: 20)
let fyyStudent = Student(name: "ljl", age: 18, sno: "2016110325")
let diction = [fyy,fyyStudent]
if var urlJson = defaultDoc.urls(for: .documentDirectory, in: .userDomainMask).first {
    //新建文件
    print("额外测试 : ")
    print("父类子类数组存入文件URL:     \(urlJson)")
    //把自定义对象存入文件
    urlJson.appendPathComponent("JSonArryayExtend.txt")
    let dataJson = try? encoder.encode(diction)
    print("编码前diction数据是： "+String(data: dataJson!, encoding: .utf8)!)
    try? dataJson?.write(to: urlJson)
    let dataAfterEncode = try? Data.init(contentsOf: urlJson)
    let newJson = try decoder.decode(type(of: diction), from: dataJson!)
    print("解码后数据是： "+String(data: dataAfterEncode!, encoding: .utf8)!)
} else {
    print("error")
}


//作业四
//图片的URL
let image = try? Data(contentsOf : URL(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3674402439,2717698677&fm=27&gp=0.jpg")!)
if let url = defaultDoc.urls(for: .documentDirectory, in: .userDomainMask).first {
    //新建文件
    print("第四题 : ")
    print("jpg图片路径:     \(url)")
    //写入文件路径,图片只能write(to : URL)一种写入
    try? image!.write(to: url)
} else {
    print("error")
}




//let url = defaultDoc.urls(for: .documentDirectory, in: .userDomainMask).first!
//var imageUrl = URL(string : "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3674402439,2717698677&fm=27&gp=0.jpg")!
//let imageData = try? Data(contentsOf: imageUrl)
//imageUrl.appendPathComponent("image.jpg")
//try? imageData?.write(to: url)
//系统提示没有UIImage类
//let image = UIImage(data: imageData!)

//作业五
//使用json接口
let weatherUrl = URL(string : "http://www.weather.com.cn/data/sk/101270102.html")
let str = try? String(contentsOf: weatherUrl!)          //显示json数据
//print("String for json"+str!)
let weatherData = try? Data(contentsOf: weatherUrl!)   //显示二进制json数据
//print(weatherData!)
let json = try? JSONSerialization.jsonObject(with: weatherData!, options: .allowFragments)

//解析json数据开始
if let dic = json as? [String : Any] {
    if let weatherNow = dic["weatherinfo"] as? [String : Any] {
        let city = weatherNow["city"]!
        let temp = weatherNow["temp"]!
        let fx = weatherNow["WD"]!
        let fl = weatherNow["WS"]!
        print("第五题：  成都天气如下")
        print("城市：\(city) , 温度: \(temp) , 风向: \(fx), 风力: \(fl)")
    }
}










