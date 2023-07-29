// ArgumentProcessor.swift
// Copyright (c) 2023 FastlaneTools

//
//  ** NOTE **
//  This file is provided by fastlane and WILL be overwritten in future updates
//  If you want to add extra functionality to this project, create a new file in a
//  new group so that it won't be marked for upgrade
//

import Foundation

struct ArgumentProcessor {
    let args: [RunnerArgument]
    let commandTimeout: Int
    let port: UInt32

    init(args: [String]) {
        // Dump the first arg which is the program name
        let fastlaneArgs = stride(from: 1, to: args.count - 1, by: 2).map {
            RunnerArgument(name: args[$0], value: args[$0 + 1])
        }
        self.args = fastlaneArgs

        let potentialLogMode = fastlaneArgs.filter { arg in
            arg.name.lowercased() == "logmode"
        }

        port = UInt32(fastlaneArgs.first(where: { $0.name == "swiftServerPort" })?.value ?? "") ?? 2000

        // Configure logMode since we might need to use it before we finish parsing
        if let logModeArg = potentialLogMode.first {
            let logModeString = logModeArg.value
            Logger.logMode = Logger.LogMode(logMode: logModeString)
        }

        // User might have configured a timeout for the socket connection
        let potentialTimeout = fastlaneArgs.filter { arg in
            arg.name.lowercased() == "timeoutseconds"
        }

        if let logModeArg = potentialLogMode.first {
            let logModeString = logModeArg.value
            Logger.logMode = Logger.LogMode(logMode: logModeString)
        }

        if let timeoutArg = potentialTimeout.first {
            let timeoutString = timeoutArg.value
            commandTimeout = (timeoutString as NSString).integerValue
        } else {
            commandTimeout = SocketClient.defaultCommandTimeoutSeconds
        }
    }
}

// Please don't remove the lines below
// They are used to detect outdated files
// FastlaneRunnerAPIVersion [0.9.2]
