/**
    Env.swift
    EnvKit
 
    Created by Tibor Bödecs on 2019.01.01.
    Copyright Binary Birds. All rights reserved.
 */

import Foundation

/// env management class
public final class Env {
    
    /// work url based on the current directory path
    let workUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    
    /// session storage file url
    let fileUrl: URL

    /// env variable storage
    public private(set) var variables: [String: String]

    /// public subscript api for the env variables
    public subscript(key: String) -> String? {
        get {
            return self.variables[key]
        }
        set {
            self.variables.removeValue(forKey: key)
            unsetenv(key)
            if let value = newValue {
                self.variables[key] = value
                setenv(key, value, 1)
            }
        }
    }
    
    // MARK: - private helpers
    
    /// reloads the actual environment variables, based on the current env variables
    private func reloadEnv() {
        self.variables.forEach { variable in
            setenv(variable.key, variable.value, 1)
        }
    }

    // MARK: - public API methods

    /**
        Initializes a new env object and loads variables from the session storage file
     
        - Parameters:
            - file: The name of the session storage file
     
        - Throws:
            Load error if something goes wrong
     */
    public init(file: String = ".env.session") throws {
        self.fileUrl = self.workUrl.appendingPathComponent(file)
        self.variables = [:]
        try self.load()
        
    }

    /**
        Initializes a new env object from scratch.
     
        NOTE: this init method will save the new variables into the session storage file

        - Parameters:
            - file: The name of the session storage file
            - variables: The env variables you want to set
     
        - Throws:
            Save error if something goes wrong
     */
    public init(file: String = ".env.session", _ variables: [String: String]) throws {
        self.fileUrl = self.workUrl.appendingPathComponent(file)
        self.variables = variables
        self.reloadEnv()
        try self.save()
    }
    
    /**
        Loads the variables from the session storage file into memory & enviromnent

        - Throws:
            JSONDecoder or Data error if something goes wrong
     */
    public func load() throws {
        let data = try Data(contentsOf: self.fileUrl)
        self.variables = try JSONDecoder().decode([String: String].self, from: data)
        self.reloadEnv()
    }

    /**
        Saves the current env variables into the session storage file
     
        - Throws:
            JSONEncoder or Data error if something goes wrong during the save process
     */
    public func save() throws {
        let data = try JSONEncoder().encode(self.variables)
        try data.write(to: self.fileUrl)
    }

    /**
        Destroys all the env variables from the environment and the session storage file
     
        - Throws:
            FileManager exception if the session storage file could not be deleted
     */
    public func destroy() throws {
        self.variables.forEach { variable in
            unsetenv(variable.key)
        }
        self.variables = [:]
        try FileManager.default.removeItem(atPath: self.fileUrl.path)
    }
}
