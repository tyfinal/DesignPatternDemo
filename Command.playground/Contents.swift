import UIKit

/// 命令模式
/// 应用场景：
/// 我的页面点击各个功能按钮使用命令模式打开不同页面

var greeting = "Hello, playground"

setupData()

func setupData() {
    let pr = MinePresenter()
    pr.setupData()
    pr.didSelectTableViewAtIndex()
}

/// 接口
protocol commandProtocol {
    func execute()
}

/// receiver实际执行者
struct MineReceiver {
    /// 跳转到关于我们页面
    func toAboutUs() {
        print("打开关于我们")
    }
    
    func toSetting() {
        print("打开开设置")
    }
    
    func toPrivacy() {
        print("打开隐私声明")
    }
}

/// commad实现类
struct AboutCommand: commandProtocol {
    
    let receiver: MineReceiver
    
    init(receiver: MineReceiver) {
        self.receiver = receiver
    }
    
    func execute() {
        receiver.toAboutUs()
    }
}

/// commad实现类
struct PrivacyCommand: commandProtocol {
    
    let receiver: MineReceiver
    
    init(receiver: MineReceiver) {
        self.receiver = receiver
    }
    
    func execute() {
        receiver.toPrivacy()
    }
}

/// commad实现类
struct SettingCommand: commandProtocol {
    
    let receiver: MineReceiver
    
    init(receiver: MineReceiver) {
        self.receiver = receiver
    }
    
    func execute() {
        receiver.toSetting()
    }
}

/// invoker命令调用类
class MinePresenter {
    
    let receiver = MineReceiver()
    
    var dataArray: [settingModel] = []
    
    func setupData() {
        /// 模你我的页面操作按钮数据源
        dataArray = [
            settingModel(name: "设置", command: SettingCommand(receiver: receiver), icon: "", function: toSetting),
            settingModel(name: "关于我们", command: AboutCommand(receiver: receiver), icon: "",function: nil),
            settingModel(name: "隐私协议", command: PrivacyCommand(receiver: receiver), icon: "", function: ({
                print("执行隐私协议闭包")
            }))
        ]
    }
    
    func didSelectTableViewAtIndex() {
        var index = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            if index < self.dataArray.count {
                let model = self.dataArray[index]
                if let command = model.command {
                    command.execute()
                }
                
                if let function = model.function {
                    function()
                }
            }
            index += 1
            if index == self.dataArray.count {
                timer.invalidate()
            }
        }
        RunLoop.current.add(timer, forMode: .default)
        RunLoop.current.run()
    }
    
    func toSetting() {
        print("在当前页面打开设置")
    }
}

struct settingModel {
    let name: String
    let command: commandProtocol?
    let icon: String
    let function: (()->())?
}

