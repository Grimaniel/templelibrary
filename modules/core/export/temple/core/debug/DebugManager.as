/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.core.debug 
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import temple.core.CoreObject;
	import temple.core.Temple;
	import temple.core.debug.log.Log;
	import temple.core.display.StageProvider;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.utils.BuildMode;
	import temple.core.utils.Environment;
	import temple.core.templelibrary;


	/**
	 * This class is used to manage objects that can be debugged.
	 * <p>Object(-trees) can be added so they can be listed and managed by external tools.</p>
	 * <p>There also is a global setting to apply debugging to all added objects.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * // open the file in the browser:
	 * // http://domain.com/index.html?debug=true
	 * 
	 * // add IDebuggable objects:
	 * DebugManager.add(this);
	 * // add IDebuggable children:
	 * if (button is IDebuggable) DebugManager.addAsChild(button as IDebuggable, this);
	 * // debugging for this added objects are set to the value in the URL
	 * 
	 * // change the debugging value for an object:
	 * DebugManager.setDebugfor (12, false);
	 * 
	 * // set debugging globally ON
	 * DebugManager.debugMode = DebugManager.ALL;
	 * </listing>
	 * 
	 * @includeExample DebugManagerExample.as
	 * 
	 * @author Arjan van Wijk, Thijs Broerse
	 */
	public final class DebugManager extends CoreObject implements IDebuggable
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.3.0";
		
		/**
		 * Set this key if you want to enable runtime debugging
		 */
		templelibrary static var KEY:String;
		
		private static var _instance:DebugManager;
		private static var _debugMode:String;
		private static var _debug:Boolean;

		// pool of debuggables with there Registry-id
		private var _debuggables:Dictionary;
		
		// pool of debuggable children with there parent Registry-id for quick lookup
		private var _debuggableChildren:Dictionary;
		
		// list of parentId's with their childId's
		private var _debuggableChildList:Vector.<Vector.<uint>>;
		
		// pool of debuggable children with there parent Registry-id for quick lookup
		private var _debuggableChildQueue:Dictionary;
		

		public static function getInstance():DebugManager
		{
			return DebugManager._instance ||= new DebugManager();
		}
		
		/**
		 * Adds a IDebuggable object so it can be controlled by the DebugManager
		 * @param object The IDebuggable object to add
		 * 
		 * @see temple.core.debug.#addToDebugManager()
		 */
		public static function add(object:IDebuggable):void
		{
			if (DebugManager._debug) DebugManager.getInstance().logDebug("add: " + object);
			
			// check via javascript if debug is set in the url
			if (DebugManager.templelibrary::KEY && ExternalInterface.available)
			{
				try
				{
					var key:String = ExternalInterface.call(<script><![CDATA[function(){var a = document.location.href.toString().split("?").pop().split("#").shift().split("&");var o = {};for (var i = 0; i < a.length; ++i){var p = a[i].split("=");o[p[0]] = p[1];}return o["debug"];} ]]></script>);
					if (DebugManager.debug) DebugManager.getInstance().logInfo("debug key from query string: '" + key + "' (url='" + ExternalInterface.call(<script><![CDATA[function(){ return document.location.href; } ]]></script>) + "')");
					if (key == DebugManager.templelibrary::KEY) DebugManager.debugMode = DebugMode.ALL; 
				}
				catch (error:SecurityError)
				{
					DebugManager.getInstance().logWarn("application is running in sandbox, or isn't running in a browser at all");
				}
			}
			
			// if no debugsetting in URL, set to default
			if (!DebugManager._debugMode)
			{
				DebugManager.debugMode = Temple.defaultDebugMode;
				DebugManager.templelibrary::KEY = null;
			}
			
			var objectId:uint = Registry.getId(object);
			if (objectId == 0)
			{
				// If not in Registry, add it there
				objectId = Registry.add(object);
			}
			
			// store the object with their id
			DebugManager.getInstance()._debuggables[object] = objectId;
			
			// if _debugMode is set to ALL or NONE, apply it to the added object
			if (DebugManager._debugMode != DebugMode.CUSTOM) object.debug = (DebugManager._debugMode == DebugMode.ALL);
		}

		/**
		 * Add a IDebuggable object as child of a Debuggable 'group'
		 * <p>This function is only called in objects added with DebugManager.add(this);</p>
		 * <p>Using this construction a tree of Debuggables is created</p>
		 * <p>When the 'debug'-property of the parent is set via the DebugManager,
		 * the debugging for all children is also set to the same value</p>
		 * @param object The IDebuggable object to add
		 * @param parent The parent of the object (like a Form of an InputField)
		 * @example
		 * <listing version="3.0">
		 * if (button is IDebuggable) DebugManager.addAsChild(button as IDebuggable, this);
		 * </listing>
		 * 
		 * @see temple.core.debug#addToDebugManager()
		 */
		public static function addAsChild(object:IDebuggable, parent:IDebuggable):void
		{
			if (DebugManager._debug) DebugManager.getInstance().logDebug("addAsChild: " + object + " (parent=" + parent + ")");
			
			var parentId:uint = Registry.getId(parent);
			var objectId:uint = Registry.getId(object);
			
			var debugManager:DebugManager = DebugManager.getInstance();
			
			// if parent is not a debuggable
			if (!debugManager._debuggables[parent])
			{
				// check if parent is a child itself
				if (debugManager._debuggableChildren[parent])
				{
					// find parent recursively
					DebugManager.addAsChild(object, Registry.getObject(debugManager._debuggableChildren[parent]));
				}
				else
				{
					// parent is not found, place in queue
					debugManager._debuggableChildQueue[object] = parentId;
					
					if (debugManager._debuggableChildList.length < parentId) debugManager._debuggableChildList.length = parentId + 1;
					
					// if no child for parent is added yet, create the array
					if (!debugManager._debuggableChildList[parentId])
					{
						debugManager._debuggableChildList[parentId] = new Vector.<uint>();
					}
					// add child in parent-array
					debugManager._debuggableChildList[parentId].push(objectId);
				}
			}
			else
			{
				if (debugManager._debuggableChildList.length < parentId) debugManager._debuggableChildList.length = parentId + 1;
				
				// if no child for parent is added yet, create the array
				if (!debugManager._debuggableChildList[parentId])
				{
					debugManager._debuggableChildList[parentId] = new Vector.<uint>();
				}
				// add child in parent-array
				debugManager._debuggableChildList[parentId].push(objectId);
				
				// add child with its parentid
				// for quick lookup
				debugManager._debuggableChildren[object] = parentId;
				
				object.debug ||= parent.debug;	
				
				
				// check for children in the queue
				for (var i:* in debugManager._debuggableChildQueue)
				{
					// if parentid in list is equal to this objectid
					if (debugManager._debuggableChildQueue[i] == objectId)
					{
						// add child in list to this object as parent
						//DebugManager.addAsChild(i as IDebuggable, Registry.getObject(DebugManager._INSTANCE._debuggableChildQueue[i]));
						
						// add child with its parentid
						// for quick lookup
						debugManager._debuggableChildren[i as IDebuggable] = debugManager._debuggableChildQueue[i];
						
						object.debug ||= parent.debug;	
						
						debugManager._debuggableChildQueue[i] = null;
					}
				}
			}
		}

		/**
		 * Set the debug flag for an object by id
		 * @param id The id of the Debuggable object
		 * @param value The debug value
		 */
		public static function setDebugFor(objectId:uint, value:Boolean):void
		{
			var object:IDebuggable = Registry.getObject(objectId) as IDebuggable;
			if (object) object.debug = value;
		}
		
		/**
		 * Set the debug flag for the children of an object.
		 * <p>This function will be called from an IDebuggable 'parent' in the 'set debug' most of the time, to updated it's children.</p>
		 * @param parentObjectId The id of the Debuggable parent object
		 * @param value The debug value
		 */
		public static function setDebugForChildren(parentObject:IDebuggable, value:Boolean):void
		{
			var id:uint = Registry.getId(parentObject);
			if (!id) return;
			
			var list:Vector.<Vector.<uint>> = DebugManager.getInstance()._debuggableChildList;
			var children:Array = id < list.length ? Registry.getObjects(list[id]) : null;
			
			if (!children) return;
			
			for (var i:int = 0, len:uint = children.length, child:IDebuggable; i < len; ++i)
			{
				child = children[i] as IDebuggable;
				if (child) child.debug = value;
			}
		}
		
		/**
		 * @private
		 */
		public static function get debugMode():String
		{
			return DebugManager._debugMode ||= Temple.defaultDebugMode;
		}
		
		/**
		 * <p>Enable debugging for all objects</p>
		 *	The debugMode can be set to:
		 *	<ul>
		 * 	<li>DebugManager.NONE: debug nothing</li>
		 * 	<li>DebugManager.CUSTOM: let the user decide what to debug</li>
		 * 	<li>DebugManager.ALL: debug everything</li>
		 * 	</ul>
		 * 	
		 * 	@see temple.core.debug.DebugMode
		 */
		public static function set debugMode(value:String):void
		{
			switch (value)
			{
				case DebugMode.NONE:
				case DebugMode.CUSTOM:
				case DebugMode.ALL:
				{
					DebugManager._debugMode = value;
					break;
				}
				default:
				{
					Log.error("Invalid value for debugMode: " + value, DebugManager);
					return;
					break;
				}
			}
			if (DebugManager._debugMode != DebugMode.CUSTOM)
			{
				var debug:Boolean = (DebugManager._debugMode == DebugMode.ALL);
				
				if (debug) DebugManager.logInfo();
				
				for (var object:* in DebugManager.getInstance()._debuggables)
				{
					IDebuggable(object).debug = debug;
				}
			}
		}
		
		/**
		 * Logs some debug info, like Temple version and current date
		 * @return the info which is logged.
		 */
		public static function logInfo():String 
		{
			var info:String = "Debug info:";
			
			info += "\n\tTemple version: " + Temple.VERSION;
			info += "\n\tTemple date: " + Temple.DATE;
			var date:Date;
			if (StageProvider.stage)
			{
				info += "\n\tCompilation date: ";
				date = BuildMode.getCompilationDate(StageProvider.stage);
				if (date)
				{
					info += date.fullYear + "-" + (date.month+1) + "-" + date.date + " " + date.hours + ":" + date.minutes + ":" + date.seconds;
				}
				else
				{
					info += "not found";
				}
			}
			date = new Date();
			info += "\n\tCurrent date: " + date.fullYear + "-" + (date.month+1) + "-" + date.date;
			info += "\n\tPlayer version: " + Capabilities.version + (Capabilities.isDebugger ? " (Debug)" : "");
			info += "\n\tEnvironment: " + Environment.getEnvironment();
			info += "\n\tOperation System: " + Capabilities.os;
			info += "\n\tManufacturer: " + Capabilities.manufacturer;
			info += "\n\tBuildMode: " + (BuildMode.isDebugBuild() ? "debug" : "release");
			info += "\n\tDebugMode: " + DebugManager.debugMode;
			if (StageProvider.stage)
			{
				info += "\n\tURL: " + StageProvider.stage.loaderInfo.url;
				info += "\n\tFlashVars:";
				var vars:Object = StageProvider.stage.loaderInfo.parameters;
				for (var key : String in vars)
				{
					info += "\n\t\t" + key + ": " + vars[key];
				}
			}
			Log.debug(info, DebugManager);
			
			return info;
		}
		
		/**
		 *	Wrapper for DebugManager.getInstance().debug
		 */
		public static function get debug():Boolean
		{
			return DebugManager._debug;
		}
		
		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			if (value != DebugManager._debug)
			{
				DebugManager._debug = value;
				DebugManager.getInstance().logDebug("debug " + (DebugManager._debug ? "enabled" : "disabled"));
			}
		}
		
		/**
		 * @private
		 */
		public static function toString():String 
		{
			return objectToString(DebugManager);
		}
		
		/**
		 * @private
		 */
		public function DebugManager() 
		{
			if (DebugManager._instance) throwError(new TempleError(this, "Singleton, use DebugManager.getInstance()"));
			
			this._debuggables = new Dictionary(true);
			this._debuggableChildren = new Dictionary(true);
			this._debuggableChildList = new Vector.<Vector.<uint>>();
			this._debuggableChildQueue = new Dictionary(true);
			
			DebugManager._instance = this;
			DebugManager.add(this);
		}

		/**
		 *	For the DebugManager itself
		 *	
		 *	@inheritDoc 
		 */
		public function get debug():Boolean
		{
			return DebugManager._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			DebugManager._debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			DebugManager._instance = null;
			this._debuggables = null;
			this._debuggableChildren = null;
			this._debuggableChildList = null;
			this._debuggableChildQueue = null;
			
			super.destruct();
		}
	}
}
