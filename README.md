Ambiance is an app that allows you to move your work from a computer to another, or from your mobile phone to your computer, or from your iPad to your computer…

… you get the idea. Get up from device A, open Ambiance on device B and go back working.

At the moment this is basically a proof of concept — you can run it, and it works, but it needs **MAJOR INTERNAL REFACTORING**. Like now. There is a Mac app, an iOS app, a Java backend server and a Windows Phone 7 app, all In Need Of Love. For now, the only thing they move is the music they're listening to, but the backend is organized using 'services' (of which `music` is just one), so it can be extended in useful and interesting ways.

## Prerequisites

Surprisingly few! The apps have none. The backend requires:

* any RESTlet server edition: http://www.restlet.org/
* the official JSON classes: http://www.json.org/java/index.html

