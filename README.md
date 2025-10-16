Random Quote App (SwiftUI & MVVM)

Screenshot of the app in action here

Table of Contents
Introduction

Features

MVVM Architecture (Model - View - ViewModel)

Getting Started

Advanced Features & Best Practices

Introduction
This modern iOS application, built with SwiftUI, was developed for educational purposes. It allows users to view random quotes fetched from an external API. This README will guide you through the app's features, how to get started, and its underlying MVVM architecture.

Features
Displays a random quote fetched from an external API.

Automatically loads a quote when the app launches.

Refresh button to get a new quote on demand.

Complete UI state management:

Displays a loading indicator (ProgressView) during the network call.

Displays the quote upon success.

Displays clear and specific error messages in case of network or decoding failures.

MVVM Architecture (Model - View - ViewModel)
View
Responsible for displaying and managing the view's state. No data logic is handled here. It is passive and simply observes the ViewModel's changes.

In this project: QuoteView.swift

ViewModel
This is where the magic happens. This layer listens for events from the view, requests data from the Model/Service, transforms that data for display, and exposes the final state to the view via @Published properties. Thanks to this separation, layers can communicate without tight coupling.

In this project: QuoteViewModel.swift

Model / Service (Repository / Model)
Responsible for providing data while hiding its origin. In this project, this layer is implemented as a Service layer (QuoteServiceProtocol and its implementation APIQuoteService) which fetches data from a network API, but it could come from anywhere (local database, cache, etc.).

In this project: Quote.swift, QuoteDTO.swift, and the Service layer.

Getting Started
Prerequisites
Xcode 15 or later.

iOS 16 or later.

Installation
Clone the repository to your local machine:

git clone [https://github.com/Habano78/QuotesDisplay_Appels-R-seaux.git](https://github.com/Habano78/QuotesDisplay_Appels-R-seaux.git)


Open the .xcodeproj file in Xcode.

Build and run the project on your preferred simulator or physical device.

Usage
Launch the app and enjoy the inspirational quotes 💪

Advanced Features & Best Practices
Unit Tested: The QuoteViewModel is unit tested using a MockQuoteService to ensure its logic is reliable and bug-free.

Enhanced UI/UX: The application features a clean design with smooth animations for an improved user experience.

Accessibility Ready: The app is designed to be accessible, supporting key features like Dynamic Type and VoiceOver.

Offline Caching: A caching layer is implemented, allowing the app to display quotes even without an active internet connection.

Favorites Persistence: Users can save their favorite quotes for later viewing, with data persisted across app launches.
