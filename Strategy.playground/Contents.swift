import UIKit

/// 注意区分策略模式 装饰器模式 适配器模式
// 策略模式
// https://github.com/ochococo/Design-Patterns-In-Swift/blob/master/README-CN.md#-%E7%AD%96%E7%95%A5strategy

var greeting = "Hello, playground"

enum Role {
    case Host /// 主持人
    case Audience /// 观众
    case Guest  /// 嘉宾
    case Cohost /// 主持人助理
}

protocol UserOperationProtocol {
    // 静音操作
    func mute(_ mute: Bool)

    // 打开摄像头
    func openCamera(_ open: Bool)

    // 踢出
    func kickOut(userId: Int) -> Bool
    
    // 进入等候室
    func enterWaitingRoom(userId: Int)
}

struct Host: UserOperationProtocol {
    func mute(_ mute: Bool) {
        print("主持人静音操作\(mute ? "静音" : "取消")")
    }

    func openCamera(_ open: Bool) {
        print("主持人打开摄像头\(open ? "打开" : "关闭")")
    }

    func kickOut(userId: Int) -> Bool {
        print("主持人将id为\(userId)踢出会议")
        return true
    }
    
    func enterWaitingRoom(userId: Int) {
        print("主持人不支持该功能")
    }
}

struct Guest: UserOperationProtocol {
    
    func mute(_ mute: Bool) {
        print("嘉宾静音操作\(mute ? "静音" : "取消")")
    }

    func openCamera(_ open: Bool) {
        print("嘉宾打开摄像头\(open ? "打开" : "关闭")")
    }

    func kickOut(userId: Int) -> Bool {
        print("嘉宾不支持踢人")
        return true
    }
    
    func enterWaitingRoom(userId: Int) {
        print("嘉宾\(userId)进入等候室")
    }
}

/// 装饰器模式
/// 助理主持 支持部分嘉宾的功能比如等候室的功能 并且支持一些主持人的操作功能
struct Cohost: UserOperationProtocol {
    
    let guest: Guest
    let host: Host
    
    init(guest: Guest, host: Host) {
        self.guest = guest
        self.host = host
    }
    
    func mute(_ mute: Bool) {
        self.host.mute(mute)
    }

    func openCamera(_ open: Bool) {
        self.guest.openCamera(open)
    }

    func kickOut(userId: Int) -> Bool {
        self.host.kickOut(userId: userId)
    }
    
    func enterWaitingRoom(userId: Int) {
        self.guest.enterWaitingRoom(userId: userId)
    }
}

struct Audience: UserOperationProtocol {
    
    func mute(_ mute: Bool) {
        print("观众静音操作\(mute ? "静音" : "取消")")
    }

    func openCamera(_ open: Bool) {
        print("观众打开摄像头\(open ? "打开" : "关闭")")
    }

    func kickOut(userId: Int) -> Bool {
        print("观众不支持踢人功能")
        return true
    }
    
    func enterWaitingRoom(userId: Int) {
        print("观众不支持该功能")
    }
}

struct UserOperation: UserOperationProtocol {
    
    var role: Role = .Audience
    
    var user: UserOperationProtocol = Audience()
    
    var userId: Int = -1
    
    init(role: Role, userId: Int) {
        self.role = role
        self.userId = userId
        self.user = user(role: role)
    }
    
    mutating func changeRole(_ role: Role) {
        self.role = role;
        self.user = user(role: role)
    }
    
    static func operationInstance() {
        UserOperation(role: .Audience, userId: 0)
    }
    
    internal func mute(_ mute: Bool) {
        self.user.mute(mute)
    }
    
    internal func openCamera(_ open: Bool) {
        self.user.openCamera(open)
    }
    
    internal func kickOut(userId: Int) -> Bool {
        self.user.kickOut(userId: userId)
        return true
    }
    
    func enterWaitingRoom(userId: Int) {
        self.user.enterWaitingRoom(userId: userId)
    }
    
    func user(role: Role) -> UserOperationProtocol {
        switch role {
        case .Audience:
            return Audience()
        case .Host:
            return Host()
        case .Guest:
            return Guest()
        case .Cohost:
            return Cohost(guest: Guest(), host: Host())
        }
    }
}

var operation = UserOperation(role: .Host, userId: 200)
operation.kickOut(userId: operation.userId)

/// 观众
operation.userId = 100
operation.kickOut(userId: operation.userId)
operation.changeRole(.Audience)
operation.kickOut(userId: operation.userId)

/// 嘉宾
operation.changeRole(.Guest)
operation.openCamera(true)
operation.enterWaitingRoom(userId: operation.userId)
operation.kickOut(userId: operation.userId)

/// 助理主持人
operation.changeRole(.Cohost)
operation.enterWaitingRoom(userId: operation.userId)
operation.kickOut(userId: operation.userId)
