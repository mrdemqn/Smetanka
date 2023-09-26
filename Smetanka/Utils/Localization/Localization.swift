//
//  Localization.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

enum Localization: String {
    
    case appName = "app_name"
    case somethingWrong = "something_wrong"
    case skip = "skip"
    case next = "next"
    case registration = "registration"
    case login = "login"
    case logOut = "log_out"
    case check = "check"
    case authenticationTitle = "authentication_title"
    case emailPlaceholder = "email_placeholder"
    case passwordPlaceholder = "password_placeholder"
    case confirmPasswordPlaceholder = "confirm_password_placeholder"
    case errorAlertTitle = "error_alert_title"
    case errorAlertCancelActionTitle = "error_alert_cancel_action_title"
    case recipes = "recipes"
    case recipe = "recipe"
    case favourites = "favourites"
    case favouritesTabBarTitle = "favourites_tab_bar_title"
    case myRecipesTabBarTitle = "my_recipes_tab_bar_title"
    case myRecipes = "my_recipes"
    case profileTabBarTitle = "profile_tab_bar_title"
    case difficulty = "difficulty"
    case portion = "portion"
    case time = "time"
    case descriptionTitle = "descriptionTitle"
    case stepsTitle = "stepsTitle"
    case profileHeader = "profile_header"
    case themeButton = "theme_button"
    case defaultThemeButton = "default_theme_button"
    case darkThemeButton = "dark_theme_button"
    case lightThemeButton = "light_theme_button"
    case emailFieldTitle = "email_field_title"
    case passwordFieldTitle = "password_field_title"
    case loginHeader = "login_header"
    case loginSubHeader = "login_sub_header"
    case pleaseWait = "please_wait"
    case registrationSuccessTitle = "registration_success_title"
    case registrationSuccessMessage = "registration_success_message"
    
    /// MARK - Firebase Error Messages
    case unverifiedEmailTitle = "unverified_email_title"
    case unverifiedEmailMessage = "unverified_email_message"
    
    /// MARK - Создание рецепта
    case titleRecipePlaceholder = "title_recipe_placeholder"
    case difficultyRecipePlaceholder = "difficulty_recipe_placeholder"
    case portionRecipePlaceholder = "portion_recipe_placeholder"
    case timeRecipePlaceholder = "time_recipe_placeholder"
    case descriptionRecipePlaceholder = "description_recipe_placeholder"
    case stepRecipePlaceholder = "step_recipe_placeholder"
}
