//
//  MediaAPI.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

// MARK: - Services

public protocol MediaService {
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void)
    func fetch(ids: Set<Int>, completion: @escaping (Result<[Media], SwiftyPressError>) -> Void)
    func createOrUpdate(_ request: Media, completion: @escaping (Result<Media, SwiftyPressError>) -> Void)
}

public protocol MediaRemote {
    func fetch(id: Int, completion: @escaping (Result<Media, SwiftyPressError>) -> Void)
}

// MARK: - Namespace

public enum MediaAPI {}
