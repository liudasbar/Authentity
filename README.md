![Logo](https://raw.githubusercontent.com/liudasbar/Authentity/master/logo.png)
# Authentity - Security made easy

Authentity project is designed to safely keep your authentication tokens in one place on the go. The project is fully open source and [documented](https://github.com/liudasbar/Authentity) on GitHub and can be accessed by anyone at any time. The project uses [mattrubin](https://github.com/mattrubin/OneTimePassword)'s *OneTimePassword* project as a base for configuring authentication details (via the detected QR code __only__) and detecting any code changes. In addition, generated tokens are saved in Apple's Keychain by using [evgenyneu](https://github.com/evgenyneu/keychain-swift)'s *keychain-swift* open-source project.

[![Download on the App Store](https://raw.githubusercontent.com/liudasbar/Authentity/master/App_Store_Badge_180px.jpg)](https://apps.apple.com/us/app/authentity/id1511791665)

![Image](https://raw.githubusercontent.com/liudasbar/Authentity/master/IMG_9686.PNG)

![Image](https://raw.githubusercontent.com/liudasbar/Authentity/master/IMG_9556.jpg)

![Image](https://github.com/liudasbar/Authentity/raw/master/IMG_9557.PNG)


## Features

Two-factor (2FA) and Multi-factor (MFA) authentication mechanisms increase the security of your account. It is a process of requiring you to verify your identity in two or more unique ways before you are granted access to your account.

Learning the password or PIN for an account is what most hackers go after. Accessing your token generator and getting biological features is harder and that is the reason why 2FA and MFA are effective in providing greater security for your accounts. That is what Authentity brings you - a possibility to add more authentication factors to make your account even harder to be hacked.

With Authentity you get:

••• Security:
- Authentity uses biometric authentication so only you have access to your 2FA/MFA authentication tokens.
- Sensitive data is stored in a secure Apple's Keychain storage.
- While using Authentity, tokens are hidden when the application is in the background state.
- Authentity does not use any password or PIN authentication so the biometric security (if enabled) is used all the time.
- There is no other way anyone can access your generated tokens.

••• Ease of use:
- A minimalistic interface provides you with the best experience while using Authentity token generator.

••• Offline use:
- Tokens are temporarily generated safely on your local device storage without any Internet connection requirement.

••• Open-source project:
- It is an open-source project documented on GitHub. Source code can be verified at any time by anyone.
- See on GitHub: https://github.com/liudasbar/Authentity

Note:
Authentity uses a QR code scanner __only__ to add new tokens by using your device's camera.

## Abbreviations

2FA - Two-Factor Authentication (Pick any two: Something you __know__, something you __have__, something you __are__).

MFA - Multi-Factor Authentication (Pick all of them: Something you __know__, something you __have__, something you __are__).

## Versions

The project is written on Xcode 11 for iOS/iPadOS devices from iOS 13. Could be available for devices under iOS 13 but code changes may be required if any.

## Privacy permissions

User needs to grant these privacy permissions:
* Camera - Used for adding new authentication entries via the QR code.
* Face ID/Touch ID usage - Used for authenticating user via biometrics.

## Offline

Authentity is fully offline. Thus, no data is being sent or received to and from any server. Data collection is not implemented in any way.

## Security

Authentity uses Apple's Face ID / Touch ID so only users who have access to their device could reach their 2FA/MFA authentication tokens.

Authentity does not use any passcode to access 2FA/MFA authentication tokens.

Apple Keychain is a secure storage. Authentity stores scanned QR codes' addresses (sensitive data) in it by using [evgenyneu](https://github.com/evgenyneu/keychain-swift)'s keychain-swift open-source project. Once stored in Keychain, this information is only available to Authentity app, other apps can't see it. Besides that, iOS/iPadOS operating system makes sure this information is kept and processed securely. For example, text stored in Keychain can not be extracted from iPhone backup or from its file system.
See more about Apple's Keychain security: https://support.apple.com/guide/security/keychain-data-protection-overview-secb0694df1a/web

When user exceeds Face ID / Touch ID attempts, the application will throw a message saying the following:
*To continue using Authentity, quit Authentity, lock and unlock your phone*.

In addition, it will provide a button to quit the application for the user so he could continue to the lock/unlock process that resets Face ID / Touch ID attempts.

In case user still cannot access his details inside the application, he is prompted with a button to remove all the data inside the application and continue using it. What is more, Face ID is disabled after pressing the button mentioned.

![Image](https://github.com/liudasbar/Authentity/raw/master/IMG_9554.jpg)

Authentity has one more security feature enabled. That is, related to the user being shown the initial authentication view when application is switched to the *background* state. He needs to re-authenticate when application is reopened.

Lastly, there is no other way to access 2FA/MFA authentication tokens. Only Face ID / Touch ID.

## OneTimePassword

Link to OneTimePassword GitHub: [OneTimePassword](https://github.com/mattrubin/OneTimePassword)

## Privacy Policy and support

If you are the user of the application, as mentioned above, there is no other way to access the information you put inside the application. Only Face ID / Touch ID entry you have enrolled with your iOS device will grant the permission to access the data inside Authentity. If you have questions regarding our privacy policy, please contact us: liudasbar2@gmail.com

## License

MIT License

Copyright © 2020 Liudas Baronas.

Copyright © 2014-2020 Matt Rubin and the OneTimePassword authors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
