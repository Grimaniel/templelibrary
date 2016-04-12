# Temple 3.7.1 - Release date November 2014 #
  * Updated to latest Greensock Animation Platform
  * Several [utility classes](https://code.google.com/p/templelibrary/source/detail?r=400) updated
  * Several [UI classes](https://code.google.com/p/templelibrary/source/detail?r=403) updated
  * [Yalog module](https://templelibrary.googlecode.com/svn/trunk/modules/yalog/readme.html) repackaged.
  * [Reflection module](https://templelibrary.googlecode.com/svn/trunk/modules/reflection/readme.html) updated

# Temple 3.7 - Release date 27 November 2013 #
  * Several methods of the [CoreMovieClip](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/display/CoreMovieClip.html) now also supports the usage of frame labels.
  * Localization update for [Date formatting](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/types/DateUtils.html#format%28%29). Localized values for Dates (like weekdays ("Monday", "Tuesday" etc) or months ("January", "February" etc)) are now stored inside '[IDateLabels](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/localization/IDateLabels.html)' objects. [English](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/localization/package.html#EnglishDateLabels) and [Dutch DataLabels](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/localization/package.html#DutchDateLabels) are already supplied with the Temple, but it's easy to add other languages.
  * Added support for [Field Expansion](https://developers.facebook.com/blog/post/2012/08/30/updates-to-the-graph-api/) in the [Facebook Module](http://templelibrary.googlecode.com/svn/trunk/modules/facebook/readme.html).
  * [TweenLite Module](http://templelibrary.googlecode.com/svn/trunk/modules/tweenlite/readme.html) updated to latest [GSAP (Animation Platform)](http://www.greensock.com/v12/) version 12
  * Many more optimizations and features added, check out the [Change List](http://code.google.com/p/templelibrary/source/list) for details.


**Downloads are no longer supported. Please use [SVN](http://code.google.com/p/templelibrary/source/checkout) to checkout the latest version.**



# Temple Library for ActionScript 3 by MediaMonks #

ActionScript 3 toolkit for stable, high performance and maintainable Flash applications. Special designed for general everyday development.

The Temple consists of classes we use on a regular basis. They are designed for re-usability and optimized for performance and memory usage. The Temple is specially designed to work with other frameworks like [Gaia](http://www.gaiaflashframework.com/), [Robotlegs](http://www.robotlegs.org/) or [TweenLite](http://www.tweenlite.com).

The Temple focuses on:
  * [Memory Management](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/debug/Memory.html)
  * [Event listeners management](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html) ([removeAllEventListeners()](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/display/CoreMovieClip.html#removeAllEventListeners%28%29), [addEventListenerOnce()](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/CoreEventDispatcher.html#addEventListenerOnce%28%29))
  * [Destruction](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/destruction/package-detail.html)
  * [Debugging](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/debug/package-detail.html)
  * [Utilities](http://templelibrary.googlecode.com/svn/trunk/modules/utils/readme.html)
  * [UI Components](http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html)
  * [Forms](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/Form.html)
  * [Data loading, parsing and handling](http://templelibrary.googlecode.com/svn/trunk/modules/data/readme.html)
  * [Layout](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/layout/liquid/LiquidBehavior.html)
  * [Caching](http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/cache/CacheLoader.html)
  * [Facebook Communication](http://templelibrary.googlecode.com/svn/trunk/modules/facebook/readme.html)
But the Temple contains many other classes which can help you in work as a Flash Developer. The Temple can also be useful for Flash Animators for creating easy, fast and stable interactive UI Components.

[Read more](http://templelibrary.googlecode.com/svn/trunk/readme.html)

### Modules ###
The Temple is divided into several modules. The Temple currently has the following modules:
  * [Core](http://templelibrary.googlecode.com/svn/trunk/modules/core/readme.html)
  * [Common](http://templelibrary.googlecode.com/svn/trunk/modules/common/readme.html)
  * [Utils](http://templelibrary.googlecode.com/svn/trunk/modules/utils/readme.html)
  * [TweenLite](http://templelibrary.googlecode.com/svn/trunk/modules/tweenlite/readme.html)
  * [Data](http://templelibrary.googlecode.com/svn/trunk/modules/data/readme.html)
  * [Control](http://templelibrary.googlecode.com/svn/trunk/modules/control/readme.html)
  * [UI](http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html)
  * [Yalog](http://templelibrary.googlecode.com/svn/trunk/modules/yalog/readme.html)
  * [CodeComponents](http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html)
  * [MediaPlayers](http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/readme.html)
  * [Camera](http://templelibrary.googlecode.com/svn/trunk/modules/camera/readme.html)
  * [Live Inspector](http://templelibrary.googlecode.com/svn/trunk/modules/liveinspector/readme.html)
  * [Reflection](http://templelibrary.googlecode.com/svn/trunk/modules/reflection/readme.html)
  * [Speech](http://templelibrary.googlecode.com/svn/trunk/modules/speech/readme.html)
  * [Microphone](http://templelibrary.googlecode.com/svn/trunk/modules/microphone/readme.html)
  * [Facebook](http://templelibrary.googlecode.com/svn/trunk/modules/facebook/readme.html)

### API Documentation ###
The API documenation can be found in the source files and [online](http://templelibrary.googlecode.com/svn/trunk/doc/index.html).

### Examples ###
There are examples included in the sources files. A list of all available examples can be found [online](http://templelibrary.googlecode.com/svn/trunk/examples/index.html).

### CodeComponents ###
CodeComponents are 'code-only' UI Components which are full-featured, lightweight and easy to use. The CodeComponents are special design for quick prototype development. The CodeComponents extends the regular Temple components and have the same features as their super classes.
[Read more](http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html)

### Facebook ###
Module for communication with Facebook, using the Graph API or FQL. Based on the Adobe ActionScript 3 SDK for Facebook Platform API, but with some big improvements.
[Read more](http://templelibrary.googlecode.com/svn/trunk/modules/facebook/readme.html)

### More ###
Follow us on Twitter: <a href='http://twitter.com/templelibrary'><a href='http://twitter.com/templelibrary'>http://twitter.com/templelibrary</a></a> or like us on Facebook: <a href='http://www.facebook.com/TempleLibrary'><a href='http://www.facebook.com/TempleLibrary'>http://www.facebook.com/TempleLibrary</a></a>.


## Change log ##

### Temple 3.6 - Release date 27 August 2013 ###

  * [EventListenerManager](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html) is now a multiton, an instance of the EventListenerManager can be retrieved using the '[getInstance](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html#getInstance%28%29)' method.
  * The EventListenerManager can now also be used to set event listeners on an object.
  * New "[listenTo](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html#listenTo%28%29)" and "[listenOnceTo](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html#listenOnceTo%28%29)" methods for setting an event listener on an other object (which can be removed automatically by the EventListenerManager)
  * All [ICoreEventDispatchers](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/ICoreEventDispatcher.html) (CoreSprite, CoreMovieClip, CoreEventListenerManager, etc) now have the new "listenTo" and "[listenOnceTo](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/events/EventListenerManager.html#listenOnceTo%28%29)" methods
  * [objectToString](http://templelibrary.googlecode.com/svn/trunk/doc/temple/core/debug/package.html#objectToString%28%29): properties of type 'int' of 'uint' with "color" in their name are automatically displayed as hex value
  * [IHasValue](http://templelibrary.googlecode.com/svn/trunk/doc/temple/common/interfaces/IHasValue.html): 'value' setter added
  * [IPauseable](http://templelibrary.googlecode.com/svn/trunk/doc/temple/common/interfaces/IPauseable.html): "paused" renamed to "isPaused"
  * 'getValue' method added in all [PropertyProxies](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/propertyproxy/package-detail.html)
  * [dump](http://templelibrary.googlecode.com/svn/trunk/doc/package.html#dump%28%29) method: "(readonly)" or "(writeonly)" added, type of property and type of value added. Optimized for iOS.
  * [TextFormatUtils](http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/types/TextFormatUtils.html) added, with "clone" method for creating a copy of a TextFormat
  * [DragBehavior](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/behaviors/DragBehavior.html): added threshold property, DragBehaviorEvent.DRAG\_START is dispatched when the dragging actually started (not on MOUSE\_DOWN). DragBehaviorEvent.DRAGGING is only dispatched when the position of the object has changed by the DragBehavior.
  * [FocusManager](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/focus/FocusManager.html): 'eventType' can be changed, so it's possible to listen for "CLICK" events instead of MOUSE\_DOWN
  * [InputField](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/components/InputField.html): added 'defaultTextFormat', 'hintTextFormat' and 'errorTextFormat' properties (replaces 'textColor', 'hintTextColor' and 'errorTextColor')
  * [Form](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/Form.html) now implemented IValidator. Added getNameForElement' method, added 'isValid' method, 'validate' method updated, validation errors generated by the [Validator](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/validation/Validator.html) are handled the same as errors from the [FormService](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/services/package-detail.html).
  * [Validator](http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/form/validation/Validator.html) class completely refactored.
  * Lots of minor updates in several classes.

### Temple 3.5 - Release date 30 January 2013 ###

New in this release:
  * [Facebook module](http://templelibrary.googlecode.com/svn/trunk/modules/facebook/readme.html) added
  * [Reflection module](http://templelibrary.googlecode.com/svn/trunk/modules/reflection/readme.html) improved

### Temple 3.4 - Release date 25 January 2013 ###

Coding standard update: deprecated the usage of keyword "this".

### Temple 3.3 - Release date 13 December 2012 ###

New in this release:
  * [Live Inspector module](http://templelibrary.googlecode.com/svn/trunk/modules/liveinspector/readme.html) added
  * [Reflection module](http://templelibrary.googlecode.com/svn/trunk/modules/reflection/readme.html) added
  * [Core module](http://code.google.com/p/templelibrary/source/detail?r=262) updated
  * [UI module](http://code.google.com/p/templelibrary/source/detail?r=269) updated
  * [Data module](http://code.google.com/p/templelibrary/source/detail?r=265) updated
  * [Utils module](http://code.google.com/p/templelibrary/source/detail?r=264) updated
  * And many other minor updates in other modules.

### Temple 3.2 - Release date 10 October 2012 ###

New in this release:
  * [Core](http://code.google.com/p/templelibrary/source/detail?r=241), [Utils](http://code.google.com/p/templelibrary/source/detail?r=243). [Data](http://code.google.com/p/templelibrary/source/detail?r=245), [UI](http://code.google.com/p/templelibrary/source/detail?r=247) modules updated
  * Added new modules [Net](http://templelibrary.googlecode.com/svn/trunk/modules/net/readme.html), [Microphone](http://templelibrary.googlecode.com/svn/trunk/modules/microphone/readme.html) and [Speech](http://templelibrary.googlecode.com/svn/trunk/modules/speech/readme.html)
  * Added more [CodeComponents](http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html)
  * And many other minor updates in several classes.

### Temple 3.1 - Release date 6 July 2012 ###

New in this release:
  * Some new features
  * Code optimization
Check out the [Change List](http://code.google.com/p/templelibrary/source/list) for details

### Temple 3.0 - Release date 20 February 2012 ###

New in this release:
  * [Module system](http://templelibrary.googlecode.com/svn/trunk/modules/index.html)
  * Less dependencies
  * Filesize and performance update
  * Lots of new features
  * More [examples](http://templelibrary.googlecode.com/svn/trunk/examples/index.html)
  * Better [documentation](http://templelibrary.googlecode.com/svn/trunk/doc/index.html)

### Note ###
**We make use of (and recommend) GreenSock’s Tweening Platform ([TweenLite](http://www.tweenlite.com) / [TweenMax](http://www.tweenlite.com)) which is licensed separately. Please see [GreenSock.com](http://www.greensock.com) for details.**