# iterable-roku-sdk

<a href="https://ibb.co/jZXCD7D"><img height="200px" src="https://i.ibb.co/PzH2gBg/featured-roku-tv.webp" alt="featured-roku-tv" border="0"></a>

 The Roku SDK is currently available for Beta. Contact your organization's CSM for access.

### Project Structure
-----
```
├── source
  ├── itbl-sdk/ (main sdk code)
  ├── itblHelpers.brs (helper methods)
  ├── main.brs (app root main file)
├── test-app (tester-app, wraps the parent level source folder)
```

### Getting started
1. Make sure you are setup with a roku developer account and have your TV setup to test. See more [here](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md).
2. Zip the `sub-contents` of the `source/itbl-sdk` folder. Rename it `itbl-sdk.zip`. Emphasis here on `sub-contents`. If you try and zip the folder itself, the SDK will not work. You must zip all of the contents *under* the folder.
3. In your app's `initialization` method, please call `ItblInitializeSDK` with your own Iterable API key. 
4. Take the `source` folder and place it in your app, similar to how the `test-app` does it.