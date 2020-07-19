//
//  Constants.swift
//  Gymmy
//
//  Created by Pranav Badgi on 22/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import Foundation
import Firebase

let MSG_MERTICS = "Metrics"
let MSG_DASHBOARD = "Dashboard"
let MSG_NOTIFICATIONS = "Get Notifications"

let MSG_ONBOARDING_METRICS = "Extrace valuable insights and come up with data driven products initiatives to help grow your business"
let MSG_ONBOARDING_DASHBOARD = "Everything you need all in one place, available throughout our dashboard feature"
let MSG_ONBOARDING_NOTIFICATIONS = "Get notified when important things are happening, so you don't miss out on the action"
let MSG_RESET_LINK_SENT = "We have sent a password reset link to your email."

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
