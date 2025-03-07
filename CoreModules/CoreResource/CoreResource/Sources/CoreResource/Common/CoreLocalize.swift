//
//  CoreLocalize.swift
//
//
//  Created by Ozcan Akkoca on 7.01.2024.
//

import Foundation

public struct CoreLocalize {
    
    public struct Home {

        public static var Title: String { return NSLocalizedString("home_title", bundle: .module, comment: "Home") }
        public static var StartTracking: String { return NSLocalizedString("home_start_tracking", bundle: .module, comment: "Home") }
        public static var StopTracking: String { return NSLocalizedString("home_stop_tracking", bundle: .module, comment: "Home") }
        public static var ResetRoute: String { return NSLocalizedString("home_reset_route", bundle: .module, comment: "Home") }
        public static var LocationAccessRequired: String { return NSLocalizedString("home_location_access_required", bundle: .module, comment: "Home") }
        public static var LocationPermissionMessage: String { return NSLocalizedString("home_location_permission_message", bundle: .module, comment: "Home") }
        public static var Settings: String { return NSLocalizedString("home_settings", bundle: .module, comment: "Home") }
        public static var Cancel: String { return NSLocalizedString("home_cancel", bundle: .module, comment: "Home") }
        public static var LocationUpdate: String { return NSLocalizedString("home_location_update", bundle: .module, comment: "Home") }
        public static var Start: String { return NSLocalizedString("home_start", bundle: .module, comment: "Home") }
    }
}
