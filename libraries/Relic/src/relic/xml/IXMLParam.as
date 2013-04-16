package relic.xml {
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author George
	 */
	public interface IXMLParam extends IEventDispatcher{
		function setParameters(params:Object):IXMLParam;
	}
	
}