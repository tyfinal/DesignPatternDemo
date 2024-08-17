import UIKit

var greeting = "Hello, playground"

setupData()

/// 通常包括originator 发起类 作为备忘录信息的提供者以及从备忘录中恢复数据后将数据转换为发起类需要的数据
/// memento类 备忘录 存储originator需要备份的信息
/// caretaker类 保存备忘录的容器类 不修改备忘录的内容 只负责存储与取出对应备忘录内容

/// 以页面展示的文本编辑器为例子

/// 首先构建originator类

struct Memento {
    /// 用户输入文字
    var text: String = ""
    
    init(text: String) {
        self.text = text
    }
}

class TextEdit {
    var text: String = ""
    
    init(text: String) {
        self.text = text
    }
    
    /// 将数据包装成备忘录
    func generateMemento() -> Memento {
        Memento(text: text)
    }
    
    /// 提供memonto还原数据的能力
    func restoreData(memento: Memento) {
        self.text = memento.text
    }
}

class MementoManager {
    var ls: [Memento] = []
    
    /// 存储当前状态
    func saveMemento(_ memonto: Memento) {
        print("save memento \(memonto.text)")
        ls.append(memonto)
        dump(ls)
    }
    
    /// 返回上一步
    func restoreMemento() -> Memento? {
        if !ls.isEmpty {
            print("restore memento before \(ls.last?.text ?? "")")
            ls.removeLast()
            print("restore memento after \(ls.last?.text ?? "")")
            return ls.last
        }
        return nil
    }
    
}

func setupData() {
    var editor = TextEdit(text: "")
    var manager = MementoManager()
    
    editor.text = "请输入您的用户名"
    manager.saveMemento(editor.generateMemento())
    
    editor.text = "dyfect"
    manager.saveMemento(editor.generateMemento())
    
    editor.text = "输入的用户名不正确清返回上一步"
    manager.saveMemento(editor.generateMemento())
    
    if let memento = manager.restoreMemento() {
        editor.restoreData(memento: memento)
        print("editor back to last step \(memento.text)")
    }
    
    manager.restoreMemento()
//    
//    manager.restoreMemento()
}
