﻿/* Playtomic ActionScript 3 API----------------------------------------------------------------------- Documentation is available at:  	https://playtomic.com/api/as3 Support is available at: 	https://playtomic.com/community  	https://playtomic.com/issues 	https://playtomic.com/support has more options if you're a premium user Github repositories: 	https://github.com/playtomicYou may modify this SDK if you wish but be kind to our servers.  Becareful about modifying the analytics stuff as it may give you borked reports.Pull requests are welcome if you spot a bug or know a more efficientway to implement something.Copyright (c) 2011 Playtomic Inc.  Playtomic APIs and SDKs are licensed under the MIT license.  Certain portions may come from 3rd parties and carry their own licensing terms and are referenced where applicable.*/package Playtomic{	import flash.net.URLRequest;	import flash.net.navigateToURL;	public final class Link	{		private static var Clicks:Array = new Array();		/**		 * Attempts to open a URL, tracking the unique/total/failed clicks the user experiences.		 * @param	url			The url to open		 * @param	name		A name for the URL (eg splashscreen)		 * @param	group		The group for the reports (eg sponsor links)		 * @param	options		Object with day, month, year properties or null for all time		 * @param	trackonly	Do not try and open the link, just log the click		 * @param	target		The target to open the link in (usually 'blank' the default)		 */		public static function Open(url:String, name:String, group:String, trackonly:Boolean = false, target:String = "_blank"):Boolean		{			var unique:int = 0;			var bunique:int = 0;			var total:int = 0;			var btotal:int = 0;			var fail:int = 0;			var bfail:int = 0;			var key:String = url + "." + name;			var result:Boolean;			var baseurl:String = url;			baseurl = baseurl.replace("http://", "");						if(baseurl.indexOf("/") > -1)				baseurl = baseurl.substring(0, baseurl.indexOf("/"));							if(baseurl.indexOf("?") > -1)				baseurl = baseurl.substring(0, baseurl.indexOf("?"));											baseurl = "http://" + baseurl + "/";			var baseurlname:String = baseurl;						if(baseurlname.indexOf("//") > -1)				baseurlname = baseurlname.substring(baseurlname.indexOf("//") + 2);						baseurlname = baseurlname.replace("www.", "");			if(baseurlname.indexOf("/") > -1)			{				baseurlname = baseurlname.substring(0, baseurlname.indexOf("/"));			}			try			{				if(!trackonly)				{					navigateToURL(new URLRequest(url), target);				}				if(Clicks.indexOf(key) > -1)				{					total = 1;				}				else				{					total = 1;					unique = 1;					Clicks.push(key);				}				if(Clicks.indexOf(baseurlname) > -1)				{					btotal = 1;				}				else				{					btotal = 1;					bunique = 1;					Clicks.push(baseurlname);				}				result = true;			}			catch(err:Error)			{				fail = 1;				bfail = 1;				result = false;			}									Log.Link(baseurl, baseurlname.toLowerCase(), "DomainTotals", bunique, btotal, bfail);			Log.Link(url, name, group, unique, total, fail);			Log.ForceSend();			return result;		}	}}