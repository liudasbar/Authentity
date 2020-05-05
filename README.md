# Authentity

## Security made easy

Authentity project is designed to safely keep your TOTP authentication codes in one place on the go. The project is fully open source and documented on GitHub and can be accessed by anyone at any time. The project uses mattrubin's OneTimePassword project as a base for configuring authentication details (via the detected QR code) and detecting any code changes.

![Image](https://raw.githubusercontent.com/liudasbar/Authentity/master/IMG_9553.PNG)

![Image](https://raw.githubusercontent.com/liudasbar/Authentity/master/IMG_9556.jpg)

![Image](https://github.com/liudasbar/Authentity/raw/master/IMG_9557.PNG)

### Abbreviations

2FA - Two-Factor Authentication (Pick any two: Something you __know__, something you __have__, something you __are__).

MFA - Multi-Factor Authentication (Pick all of them: Something you __know__, something you __have__, something you __are__).

### Versions

The project is written on Xcode 11.5 for iOS/iPadOS devices from iOS 13. Could be available for devices under iOS 13 but code changes may be required if any.

### Privacy permissions

User needs to grant these privacy permissions:
* Camera - Used for adding new authentication entries via the QR code.
* Face ID/Touch ID usage - Used for authenticating user via biometrics

### Offline

Authentity is fully offline. Thus, no data is being sent or received to and from any server. Data collection is not implemented in any way.

### Security

Authentity uses Apple's Face ID/Touch ID so only people who have access to this device could reach his 2FA/MFA authentication codes.

Authentity does not use any passcode to access 2FA/MFA authentication codes.

When user exceeds Face ID / Touch ID attempts, the application will throw a message saying the following:
*To continue using Authentity, quit Authentity, lock and unlock your phone*.

In addition, it will provide a button to quit the application for the user so he could continue to the lock/unlock process that resets Face ID / Touch ID attempts.

In case user still cannot access his details inside the application, he is prompted with a button to remove all the data inside the application and continue using it. What is more, Face ID is disabled after pressing the button mentioned.

![Image](https://github.com/liudasbar/Authentity/raw/master/IMG_9554.jpg)

Authentity has one more security feature enabled. That is related to the details being hidden when application is switched to the *background* state. The details are brought back when application state comes back to *foreground*.

![Image](https://raw.githubusercontent.com/liudasbar/Authentity/master/IMG_9562.PNG)

Lastly, there is no other way to access 2FA/MFA authentication codes. Only Face ID / Touch ID.

### OneTimePassword

Link to OneTimePassword GitHub: [OneTimePassword](https://github.com/mattrubin/OneTimePassword)

### License

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
