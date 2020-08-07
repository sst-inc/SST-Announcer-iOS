//
//  Localisations.swift
//  Timetables
//
//  Created by JiaChen(: on 7/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

// swiftlint:disable all
enum Localized {
    enum Configurations {
        static var displayName: LocalizedStringKey {
            return "CONFIG_DISPLAY_NAME"
        }
        
        static var description: LocalizedStringKey {
            return "CONFIG_DESCRIPTION"
        }
    }
    enum Lessons {
        enum Over {
            static var s: LocalizedStringKey {
                return "LESSONS_OVER_S"
            }
            
            static var m: LocalizedStringKey {
                return "LESSONS_OVER_M"
            }
        }
    }
    enum No {
        enum Ongoing {
            enum Lessons {
                enum Title {
                    static var s: LocalizedStringKey {
                        return "NO_ONGOING_LESSONS_S"
                    }
                    
                    static var m: LocalizedStringKey {
                        return "NO_ONGOING_LESSONS_M"
                    }
                }
                enum Description {
                    static var s: LocalizedStringKey {
                        return "NO_ONGOING_LESSONS_DESCRIPTION_S"
                    }
                    
                    static var m: LocalizedStringKey {
                        return "NO_ONGOING_LESSONS_DESCRIPTION_M"
                    }
                }
            }
        }
        enum Lessons {
            static var s: LocalizedStringKey {
                return "NO_LESSONS_S"
            }
            
            static var m: LocalizedStringKey {
                return "NO_LESSONS_M"
            }
        }
    }
    enum Time {
        enum Starts {
            static var at: LocalizedStringKey {
                return "STARTS_AT"
            }
        }
        enum Ends {
            static var at: LocalizedStringKey {
                return "ENDS_AT"
            }
            static var `in`: LocalizedStringKey {
                return "ENDS_IN"
            }
        }
        enum Next {
            static var s: LocalizedStringKey {
                return "NEXT_S"
            }
            static var m: LocalizedStringKey {
                return "NEXT_M"
            }
        }
    }
    
    enum SetUp {
        enum Title {
            static var s: LocalizedStringKey {
                return "SETUP_TITLE_S"
            }
            static var m: LocalizedStringKey {
                return "SETUP_TITLE_M"
            }
        }
        static var description: LocalizedStringKey {
            return "SETUP_DESCRIPTION"
        }
    }
}
