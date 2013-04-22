(c) 2006-2013 Mochi Media, Inc.

This is version 4.0 of Mochi Ads, Mochi Achievements and Mochi Scores API.

Please contact support@mochimedia.com or visit our community forums at
http://www.mochimedia.com/community/ if you have any questions or comments.

For instructions, please see the README.html file in the 'docs' folder in this archive.

New in 4.0.0:
- Added support for Group ads. A new format for handling CPA (click per action) advertising.

New in 3.9.5:
- Changed as3 ad requests for improved ad performance.

New in 3.9.3:
- Added achievements API

New in 3.9:
- Added social API
- New examples

New in 3.8:
- Added tracking API

New in 3.7:
- Workaround for _global space bugs in previous security release of flash player 10
- Fixed static initializer in MochiCoins space

New in 3.6:
- Created MochiSocial namespace

New in 3.5:
- Bug fixes in MochiInventory API

New in 3.4:
- New MochiUserData AS3 API for user data persistence
- New MochiInventory AS3 API (beta)

New in 3.12:
- Updated documentation

New in 3.11:
- Support for MochiLocalConnection

New in 3.1:
- Mochi Coins

New in 3.0:
- Merged Mochi Ads 2.7 and MochiServices 1.41
- Added the MochiDigits score obfuscation class

For older, individual change logs of MochiAds.as and MochiServices, see below

------------------------------------------------

This is version 2.7 of MochiAd.as and examples.

New in 2.7
- Fixed swf cache issue when loading consecutive ads in AS3

New in 2.6:
- Fixed issue when using MochiCrypt with AS3 API

New in 2.5:
- Documentation includes click-away ads

New in 2.4:

- New showClickAwayAd function for click-away ads
- New no_progress_bar option to disable the progress bar
- New ad_progress callback to get percentage of ad show completion or game load whichever is more

New in 2.3:

- New ad_loaded callback to get ad dimensions when the ad is loaded
- New ad_failed callback to get notification when an ad failed to load due to ad blocking or network failure

New in 2.2:

- More readable error reporting in thrown exceptions with regards to the clip parameter
- Memory usage improvements in the as3 API
- New AS3 Flex SDK 2 example

New in 2.1:

- Fixed Preloader.as in mxmlc example, no longer throws exception if
  there's a partial load (navigate away from the page while loading)
- Much improved as3 example, built in the same style as the as2 example.

New in 2.0:
    
- Fixed unhandled exceptions in ActionScript 3 API
- Renamed MochiAd.showPreloaderAd to MochiAd.showPreGameAd
- Renamed MochiAd.showTimedAd to MochiAd.showInterLevelAd

Contents:

as1/
    ActionScript 1 compatible MochiAd code and example FLA.

as2/
    ActionScript 2 compatible MochiAd code and example FLA.

as3/
    ActionScript 3 compatible MochiAd code and example FLA.

mtasc/
    MTASC compatible ActionScript 2 code and example project.

mxmlc/
    Flex 2 SDK compatible ActionScript 3 code and example project.
    
Note that while we officially support Flash 7 and above, the MochiAd code
is currently Flash 6 compatible.


----------------------------------------

This is version 1.40 of MochiServices and examples.

Please contact team@mochimedia.com or visit our publisher forum at
http://www.mochimedia.com/community/ if you have any questions or comments.

Contents:

as2/
    ActionScript 2 compatible MochiServices code and example FLA.

as3/
    ActionScript 3 compatible MochiServices code and example FLA.


Note that the MochiScores code
is currently Flash 7 compatible.

RELEASE NOTES:
------------------
Version 1.40
Fix issue with multiple buttons in AS3 Link Tracking

Version 1.36
Support fail over URL for Link Tracking

Version 1.35
Support Mochi Link Tracking

Version 1.34
Pass correct parent URL for AS3 games for Peel Away Ads

Version 1.33:
Maintenance release
Docs update

Version 1.32:
Passing MochiSerivices.connect errors on to showLeaderboard.

Version 1.31:
AS2, recovery from services unload
AS3, better error messaging
new display options: hideDoneButton, showTableRank, previewScores, width

Version 1.3:
Added score type-checking
Added closeLeaderboard method
Added displayPreloader parameter to showLeaderboard options
Added numScores parameter to showLeaderboard options
Added scores conversion method to MochiScores

Version 1.2:
Enhanced error checking
Intermittent connection recovery

Version 1.1:
Added onError callbacks
Fix to showLeaderboard when clip is specified
ActionScript 3 error handling enhancements

Version 1.0:
Initial Release
