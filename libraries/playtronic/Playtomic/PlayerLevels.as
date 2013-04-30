﻿/* Playtomic ActionScript 3 API----------------------------------------------------------------------- Documentation is available at:  	https://playtomic.com/api/as3 Support is available at: 	https://playtomic.com/community  	https://playtomic.com/issues 	https://playtomic.com/support has more options if you're a premium user Github repositories: 	https://github.com/playtomicYou may modify this SDK if you wish but be kind to our servers.  Becareful about modifying the analytics stuff as it may give you borked reports.Pull requests are welcome if you spot a bug or know a more efficientway to implement something.Copyright (c) 2011 Playtomic Inc.  Playtomic APIs and SDKs are licensed under the MIT license.  Certain portions may come from 3rd parties and carry their own licensing terms and are referenced where applicable.*/ package Playtomic{	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.geom.Matrix;	import flash.net.SharedObject;		public final class PlayerLevels	{				public function PlayerLevels() { } 				public static const NEWEST:String = "newest";		public static const POPULAR:String = "popular";				private static var KongAPI:* = null;		private static var KongLevelReceiver:Function;				private static var SECTION:String;		private static var SAVE:String;		private static var LIST:String;		private static var LOAD:String;		private static var RATE:String;				internal static function Initialise(apikey:String):void		{			SECTION = Encode.MD5("playerlevels-" + apikey);			RATE = Encode.MD5("playerlevels-rate-" + apikey);			LIST = Encode.MD5("playerlevels-list-" + apikey);			SAVE = Encode.MD5("playerlevels-save-" + apikey);			LOAD = Encode.MD5("playerlevels-load-" + apikey);		}				/**		 * Defers all level operations to Kongregate if you are using their level sharing API		 * @param	kongapi			Their API object		 * @param	levelreceiver	Your function to receive a PlayerLevel-formatted Kongregate level		 */		public static function DeferToKongregate(kongapi:*, levelreceiver:Function):void		{			KongLevelReceiver = levelreceiver;			KongAPI = kongapi;			KongAPI.sharedContent.addLoadListener("level", KongLevelLoaded);		}		/**		 * Logs a start on a player level		 * @param	levelid			The playerLevel.LevelId 		 */		public static function LogStart(levelid:String):void		{			Log.PlayerLevelStart(levelid);		}		/**		 * Logs a win on a player level		 * @param	levelid			The playerLevel.LevelId 		 */		public static function LogWin(levelid:String):void		{			Log.PlayerLevelWin(levelid);		}		/**		 * Logs a quit on a player level		 * @param	levelid			The playerLevel.LevelId 		 */		public static function LogQuit(levelid:String):void		{			Log.PlayerLevelQuit(levelid);		}				/**		 * Logs a retry on a player level		 * @param	levelid			The playerLevel.LevelId 		 */		public static function LogRetry(levelid:String):void		{			Log.PlayerLevelRetry(levelid);		}		/**		 * Flags a player level		 * @param	levelid			The playerLevel.LevelId 		 */		public static function Flag(levelid:String):void		{			Log.PlayerLevelFlag(levelid);		}				/**		 * Rates a player level		 * @param	levelid			The playerLevel.LevelId 		 * @param	rating			Integer from 1 to 10		 * @param	callback		Your function to receive the response:  function(response:Response)		 */		public static function Rate(levelid:String, rating:int, callback:Function = null):void		{						var cookie:SharedObject = SharedObject.getLocal("ratings");			if(cookie.data[levelid] != null)			{				if(callback != null)				{					callback(new Response(0, 402));				}								return;			}						if(rating < 0 || rating > 10)			{				if(callback != null)				{					callback(new Response(0, 401));				}								return;			}						var postdata:Object = new Object();			postdata["levelid"] = levelid;			postdata["rating"] = rating;						cookie.data[levelid] = rating;			PRequest.Load(SECTION, RATE, RateComplete, callback, postdata);		}				/**		 * Processes the response received from the server, returns the data and response to the user's callback		 * @param	callback	The user's callback function		 * @param	postdata	The data that was posted		 * @param	data		The XML returned from the server		 * @param	response	The response from the server		 */		private static function RateComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null):void		{			if(callback == null)				return;											callback(response);			data = data;			postdata = postdata;		}		/**		 * Loads a player level		 * @param	levelid			The playerLevel.LevelId 		 * @param	callback		Your function to receive the response:  function(response:Response)		 */		public static function Load(levelid:String, callback:Function = null):void		{				var postdata:Object = new Object();			postdata["levelid"] = levelid;							PRequest.Load(SECTION, LOAD, LoadComplete, callback, postdata);		}					/**		 * Processes the response received from the server, returns the data and response to the user's callback		 * @param	callback	The user's callback function		 * @param	postdata	The data that was posted		 * @param	data		The XML returned from the server		 * @param	response	The response from the server		 */		private static function LoadComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null):void		{			if(callback == null)				return;									var level:PlayerLevel = null;						if(response.Success)			{				var item:XML = XML(data["level"]);				var datestring:String = item["sdate"];								var year:int = int(datestring.substring(datestring.lastIndexOf("/") + 1));				var month:int = int(datestring.substring(0, datestring.indexOf("/")));				var day:int = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));								level = new PlayerLevel();				level.LevelId = item["levelid"];				level.PlayerName = item["playername"];				level.PlayerId = item["playerid"];				level.Name = item["name"];				level.Score = item["score"];				level.Votes = item["votes"];				level.Rating = item["rating"];				level.Data = item["data"];				level.Wins = item["wins"];				level.Starts = item["starts"];				level.Retries = item["retries"];				level.Quits = item["quits"];				level.Flags = item["flags"];				level.SDate = new Date(year, month-1, day);				level.RDate = item["rdate"];				level.SetThumb(item["thumb"]);											if(item["custom"])				{								var custom:XMLList = item["custom"];							for each(var cfield:XML in custom.children())					{						level.CustomData[cfield.name()] = cfield.text();					}				}			}						callback(level, response);			postdata = postdata;			}		/**		 * Lists player levels		 * @param	callback		Your function to receive the response:  function(response:Response)		 * @param	options			The list options, see http://playtomic.com/api/as3#PlayerLevels		 */		public static function List(callback:Function = null, options:Object = null):void		{						if(options == null)				options = new Object();									var mode:String = options.hasOwnProperty("mode") ? options["mode"] : "popular";			var page:int = options.hasOwnProperty("page") ? options["page"] : 1;			var perpage:int = options.hasOwnProperty("perpage") ? options["perpage"] : 20;			var datemin:String = options.hasOwnProperty("datemin") ? options["datemin"] : "";			var datemax:String = options.hasOwnProperty("datemax") ? options["datemax"] : "";			var data:Boolean = options.hasOwnProperty("data") ? options["data"] : false;			var thumbs:Boolean = options.hasOwnProperty("thumbs") ? options["thumbs"] : false;			var customfilters:Object = options.hasOwnProperty("customfilters") ? options["customfilters"] : {};						// defer to kongregate			if(KongAPI != null)			{				if(mode == "popular")				{					KongAPI.sharedContent.browse("level", KongAPI.sharedContent.BY_RATING);				}				else				{					KongAPI.sharedContent.browse("level", KongAPI.sharedContent.BY_NEWEST);				}								return;			}						var postdata:Object = new Object();				postdata["mode"] = mode;			postdata["page"] = page;				postdata["perpage"] = perpage;			postdata["data"] = data ? "y" : "n";			postdata["thumbs"] = thumbs ? "y" : "n";			postdata["datemin"] = datemin;			postdata["datemax"] = datemax;							var numcustomfilters:int = 0;						if(customfilters != null)			{				for(var key:String in customfilters)				{					postdata["ckey" + numcustomfilters] = key;					postdata["cdata" + numcustomfilters] = customfilters[key];					numcustomfilters++;				}			}						postdata["filters"] = numcustomfilters;						PRequest.Load(SECTION, LIST, ListComplete, callback, postdata);		}				/**		 * Processes the response received from the server, returns the data and response to the user's callback		 * @param	callback	The user's callback function		 * @param	postdata	The data that was posted		 * @param	data		The XML returned from the server		 * @param	response	The response from the server		 */		private static function ListComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null):void		{			if(callback == null)				return;						var levels:Array = [];				var numresults:int = 0;				if(response.Success)			{				var entries:XMLList = data["level"];				var cfield:XML;				var datestring:String;				var year:int;				var month:int;				var day:int;								numresults = data["numresults"];									for each(var item:XML in entries) 				{					datestring = item["sdate"];									year = int(datestring.substring(datestring.lastIndexOf("/") + 1));					month = int(datestring.substring(0, datestring.indexOf("/")));					day = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));										var level:PlayerLevel = new PlayerLevel();					level.LevelId = item["levelid"];					level.PlayerId = item["playerid"];					level.PlayerName = item["playername"];					level.Name = item["name"];					level.Score = item["score"];					level.Rating = item["rating"];					level.Votes = item["votes"];					level.Wins = item["wins"];					level.Starts = item["starts"];					level.Retries = item["retries"];					level.Quits = item["quits"];					level.Flags = item["flags"];					level.SDate = new Date(year, month-1, day);					level.RDate = item["rdate"];						if(item["data"])					{						level.Data = item["data"];					}										level.SetThumb(item["thumb"]);						var custom:XMLList = item["custom"];							if(custom != null)					{										for each(cfield in custom.children())						{							level.CustomData[cfield.name()] = cfield.text();						}					}										levels.push(level);				}			}			callback(levels, numresults, response);			postdata = postdata;		}						/**		 * Saves a player level		 * @param	level			The PlayerLevel to save		 * @param	thumb			A movieclip or other displayobject (optional)		 * @param	callback		Your function to receive the response:  function(level:PlayerLevel, response:Response)		 */		public static function Save(level:PlayerLevel, thumb:DisplayObject = null, callback:Function = null):void		{			// defer to kongregate			if(KongAPI != null)			{				var kcallback:Function = function(kparam:Object):void				{					level.LevelId = kparam["id"];					level.Permalink = kparam["permalink"];					level.Name = kparam["name"];										if(callback != null)					{						callback(level, new Response(kparam["success"] ? 1 : 0, 0));					}				};								KongAPI.sharedContent.save("level", level.Data, kcallback, thumb, level.Name);				return;			}						var postdata:Object = new Object();			postdata["data"] = level.Data;			postdata["playerid"] = level.PlayerId;			postdata["playersource"] = level.PlayerSource;			postdata["playername"] = level.PlayerName;			postdata["name"] = level.Name;			if(thumb != null)			{				var scale:Number = 1;				var w:int = thumb.width;				var h:int = thumb.height;								if(thumb.width > 100 || thumb.height > 100)				{					if(thumb.width >= thumb.height)					{						scale = 100 / thumb.width;						w = 100;						h = Math.ceil(scale * thumb.height);					}					else if(thumb.height > thumb.width)					{						scale = 100 / thumb.height;						w = Math.ceil(scale * thumb.width);						h = 100;					}				}								var scaler:Matrix = new Matrix();				scaler.scale(scale, scale);					var image:BitmapData = new BitmapData(w, h, true, 0x00000000);				image.draw(thumb, scaler, null, null, null, true);							postdata["image"] = Encode.Base64(Encode.PNG(image));				postdata["arrp"] = RandomSample(image);				postdata["hash"] = Encode.MD5(postdata["image"] + postdata["arrp"]);			}			else			{				postdata["nothumb"] = "y";			}						var customfields:int = 0;						if(level.CustomData != null)			{				for(var key:String in level.CustomData)				{					postdata["ckey" + customfields] = key;					postdata["cdata" + customfields] = level.CustomData[key];					customfields++;				}			}			postdata["customfields"] = customfields;						PRequest.Load(SECTION, SAVE, SaveComplete, callback, postdata);			}				/**		 * Processes the response received from the server, returns the data and response to the user's callback		 * @param	callback	The user's callback function		 * @param	postdata	The data that was posted		 * @param	data		The XML returned from the server		 * @param	response	The response from the server		 */		private static function SaveComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null):void		{			if(callback == null)				return;							var level:PlayerLevel = new PlayerLevel();			level.Data = postdata["data"];			level.PlayerId = postdata["playerid"];			level.PlayerSource = postdata["playersource"];			level.PlayerName = postdata["playername"];			level.Name = postdata["name"];						for(var key:String in postdata)			{				if(key.indexOf("ckey") == 0)				{					var num:String = key.substring(4);					var name:String = postdata["ckey" + num];					var value:String = postdata["cdata" + num];										level.CustomData[name] = value;				}			}						postdata["data"] = level.Data;			postdata["playerid"] = level.PlayerId;			postdata["playersource"] = level.PlayerSource;			postdata["playername"] = level.PlayerName;			postdata["name"] = level.Name;									if(response.Success || response.ErrorCode == 406)			{				level.LevelId = data["levelid"];				level.SDate = new Date();				level.RDate = "Just now";			}			callback(level, response);					}									/**		 * Bridge used when deferring to Kongregate and loading a level		 * @param	params		The object Kongregate gives us		 */		private static function KongLevelLoaded(params:Object):void		{		  			var level:PlayerLevel = new PlayerLevel();			level.Data = params["content"];			level.Permalink = params["permalink"];			level.Name = params["name"];			level.LevelId = params["id"];						if(KongLevelReceiver != null)			{				KongLevelReceiver(level);			}		}		/**		 * Gets a random sampling of pixels from an image		 * @param	b	The image		 */		private static function RandomSample(b:BitmapData):String		{			var arr:Array = new Array();			var x:int;			var y:int;			var c:String;						while(arr.length < 10)			{				x = Math.random() * b.width;				y = Math.random() * b.height;				c = b.getPixel32(x, y).toString(16);								while(c.length < 6)  					c = "0" + c;  												arr.push(x + "/" + y + "/" + c);			}						return arr.join(",");		}			}}