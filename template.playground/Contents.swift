import UIKit

/// 模板方法模式
/// 定义一个通用的算法骨架，然后将一些步骤延迟到子类中实现。子类可以重写这些步骤，而无需改变算法的结构。
/// 本实例通过植树来作为例子
/// 定义接口类其中植树(plantTree)作为模板方法,
/// 其中包含固定步骤挖坑(dig)、填土(fillsoil)、浇水(watertree)
/// 子类可定制步骤 选择树苗种类(select)
/// 适用场景实现步骤一致 某些方法能够公用 其他方法支持定制的场景
/// UIViewController 的生命周期方法：

/// UIViewController 提供了一组生命周期方法（如 viewDidLoad、viewWillAppear、viewDidAppear 等），这些方法可以被子类重写。这些方法定义了视图控制器在生命周期内的不同阶段应该做的事情，但是具体实现由开发者根据需要在子类中实现。

/// UIViewController 本身可以看作一个模板，框架调用这些模板方法，而开发者在子类中通过重写来定制行为

var greeting = "Hello, playground"

setupData()

func setupData() {
    AppleTree().plantTree()
    OrangeTree().plantTree()
}

protocol PlantProtocol {
    /// 模板方法
    func plantTree()
    /// 挖坑
    func dig()
    /// 选苗
    func select()
    /// 填土
    func fillSoil()
    /// 浇水
    func waterTree()
}

extension PlantProtocol {
    func plantTree() {
        dig()
        select()
        fillSoil()
        waterTree()
    }
    
    func dig() {
        print("挖坑")
    }
    
    func fillSoil() {
        print("填土")
    }
    
    func waterTree() {
        print("浇水")
    }
}

struct AppleTree: PlantProtocol {
    func select() {
        print("选择苹果树苗")
    }
}

struct OrangeTree: PlantProtocol {
    func select() {
        print("选择橘子树苗")
    }
}

