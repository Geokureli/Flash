﻿/* Playtomic ActionScript 3 API----------------------------------------------------------------------- Documentation is available at:  	https://playtomic.com/api/as3 Support is available at: 	https://playtomic.com/community  	https://playtomic.com/issues 	https://playtomic.com/support has more options if you're a premium user Github repositories: 	https://github.com/playtomicYou may modify this SDK if you wish but be kind to our servers.  Becareful about modifying the analytics stuff as it may give you borked reports.Pull requests are welcome if you spot a bug or know a more efficientway to implement something.Copyright (c) 2011 Playtomic Inc.  Playtomic APIs and SDKs are licensed under the MIT license.  Certain portions may come from 3rd parties and carry their own licensing terms and are referenced where applicable.*/package Playtomic{	public final class GeoIP	{		private static var SECTION:String;		private static var LOAD:String;				internal static function Initialise(apikey:String):void		{			SECTION = Encode.MD5("geoip-" + apikey);			LOAD = Encode.MD5("geoip-lookup-" + apikey);		}				/**		 * Performs a country lookup on the player IP address		 * @param	callback	Your function to receive the data:  callback(data:Object, response:Response);		 * @param	view	If it's a view or not		 */		public static function Lookup(callback:Function):void		{			PRequest.Load(SECTION, LOAD, LookupComplete, callback);		}					/**		 * Processes the response received from the server, returns the data and response to the user's callback		 * @param	callback	The user's callback function		 * @param	postdata	The data that was posted		 * @param	data		The XML returned from the server		 * @param	status		The request status returned from the esrver (1 for success)		 * @param	errorcode	The errorcode returned from the server (0 for none)		 */		private static function LookupComplete(callback:Function, postdata:Object, data:XML = null, response:Response = null):void		{			if(callback == null)				return;							var result:Object = {Code: "N/A", Name: "UNKNOWN"};			if(response.Success)			{								result["Code"] = data["location"]["code"];				result["Name"] = data["location"]["name"];			}						callback(result, response);			postdata = postdata;		}	}}