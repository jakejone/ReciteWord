//
//  ViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/1.
//

import Foundation

/*
 1. wordbanner card , wordSentence
 */

class ViewModel: ObservableObject {
    /**
            WordBanner state：
     1. loading, very quick
     2. displaying
     3. GotCha to next
     4. ring a bell to show centence and show next btn
     5. no idea to show centence and show next btn
     6.
     */
    enum State {
            case idle
            case loading
            case loaded(names: [String], prefix: String?)
            case ringABell
            case noIdea
            case error(Error)

            var isLoading: Bool {
                switch self {
                case .loading:
                    return true
                default:
                    return false
                }
            }

            var isError: Bool {
                switch self {
                case .error:
                    return true
                default:
                    return false
                }
            }
        }
    
    @Published private(set) var state = State.idle
}
