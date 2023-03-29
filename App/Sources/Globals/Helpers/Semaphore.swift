//
//  Semaphore.swift
//  GithubExplorer
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import Foundation

actor AsyncSemaphore {
    private var count: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []

    init(count: Int = 0) {
        self.count = count
    }

    func wait() async {
        count -= 1
        if count >= 0 { return }
        await withCheckedContinuation {
            waiters.append($0)
        }
    }

    func release() {
        self.count += 1
        if waiters.isEmpty { return }
        waiters.removeFirst().resume()
    }
}
