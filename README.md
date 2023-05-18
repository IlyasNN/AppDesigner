# SYSTEM DEVELOPMENT FOR QUICK CONFIGURATION OF A MOBILE APPLICATION

![alt text](/Resourses/Baner.png)

## Into
Since the development of mobile software is a rather expensive process, we considered the possibility of creating our own concept, which involves quickly configuring a mobile application on the IOS platform and configuring its operation. In simple words, this is a mobile application configurator, the main feature of which should be the infinity of refinement and expansion of functionality without compromising the overall architecture.
There are already similar systems on the market - no code and flowcode platforms, the main task of which is to change the approach to the process of designing a mobile application. Within the framework of simple applications and banal tasks, it will certainly work to get rid of the code, but the above-mentioned systems have a major disadvantage - scalability. Sooner or later, the question may arise about how to add specific functionality to the application, and nocode and flowcode at this moment become limited in their capabilities and do not allow this to be done.

## Stack
- SwiftUI
- Cocoapods dependecy package manager
- Firebase
-- Remote config
-- Base analytics
-- Crashlitics
-- Firestore database
-- Storage
-- Messaging

## Features

One of the main tasks of the entire system is remote configuration of a mobile application using Firebase. To do this, use the Remote Config tool. This is a cloud service that allows you to change the behavior and appearance of an application without requiring downloading an application update. When using Remote Config, we have created default values in the application that control the behavior and its appearance. We also used the Firebase console or remote configuration APIs to override values in the application for all users of the application or for groups of users.

The practical value is a functioning application available for installation on Apple devices such as iPhone, iPad and Macbook on arm64 processors. By the time the thesis is completed, there is knowledge and practical experience in software development and a lot of applied skills, such as working in an environment for creating a Figma design, setting up CI/CD and management in accordance with the best practices in commerce.

The development of the application does not end at this stage, as it requires improvements and improvements, as well as full testing. This mobile application configuration system can be an excellent solution for creating startups and demonstrating prototypes. It has great potential.
