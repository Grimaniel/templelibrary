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

package temple.liveinspector
{
	import temple.core.CoreObject;
	import temple.core.Temple;
	import temple.core.debug.DebugMode;
	import temple.core.destruction.Destructor;
	import temple.core.display.StageProvider;
	import temple.reflection.ReflectionUtils;
	import temple.ui.layout.VBox;
	import temple.utils.DefinitionProvider;
	import temple.utils.color.ColorUtils;
	import temple.utils.types.ObjectUtils;

	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;

	/**
	 * The LiveInspector visualizes the change of property values over time and makes it possible to update the values at run-time using a simple GUI. There is no need to instantiate the LiveInspector manually, it should work when the <code>add</code> function is called.
	 * 
	 * @see temple.liveinspector.#liveInspectorInstance
	 * @see ../../../readme.html readme.html
	 * 
	 * @includeExample LiveInspectorExample.as
	 * 
	 * @author	Mark Knol
	 */
	public class LiveInspector extends CoreObject
	{
		public static var THEME_BACKGROUND_COLOR:uint = 0xFFFFFF;
		public static var THEME_BORDER_COLOR:uint = 0xBBBBBB;
		public static var THEME_PROPERTY_TYPE_COLOR:uint = 0xAAAAAA;
		public static var THEME_ALPHA:Number = .88;
		public static var THEME_TEXTFORMAT:TextFormat = new TextFormat("_sans", 11, 0x666666, null, null, null, null, null, null, 3, 10);
		public static var THEME_EDITOR_TEXTFORMAT:TextFormat = new TextFormat("_sans", 11, 0, null, null, null, null, null, null, 3, 10);
		public static var THEME_MIN_WIDTH:uint = 240;
		
		private const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		
		private var _container:VBox;
        private var r:uint = 777; // fixed color seed

		public function LiveInspector(initObject:Object = null)
		{
			_container = new VBox(-1);
			
			if (initObject)
			{
				for (var prop:String in initObject)
				{
					if (prop in _container) _container[prop] = initObject[prop];
				}
			}
		}
		
		/**
		 * <code>
		 * // Inspect a property of the scope-object<br/>
		 * liveInspectorInstance.add(this.txtLabel, "text");<br/><br/>
		 * 
	     * // Inspect multiple property names, by providing an Array with property names.<br/>
		 * liveInspectorInstance.add(this.mcBall, ["x", "y"]);<br/><br/>
		 * 
		 * // Inspect all Strings inside scope-object<br/>
		 * liveInspectorInstance.add(this.mcClip, String);<br/><br/>
		 * 
		 * // Inspect an object as one item, 3 levels deep (recursively). This uses the dump() function of the Temple.<br/>
		 * liveInspectorInstance.add(this, "myData", 3);<br/><br/>
		 * 
		 * // Inspect an object as one item, but uses the toString() for inspection.<br/>
		 * liveInspectorInstance.add(this.myData);<br/><br/>
		 * </code>
		 * 
		 * @param scope 		Parent object of the property you want to visualize.
		 * @param props			* names as Array,<br/> * name as String,<br/> * or Class name.<br/> If not defined, the scope itself will be used as target.
		 * @param depth			Depth indicates the recursive factor of inspection (used by objects)
		 * @param propertyColor			Custom color for property.<br/>If propertyColor equals -1, a random color will be picked
		 */
		public function add(scope:Object, props:* = null, depth:uint = 0, propertyColor:int = -1):void
		{
			if (Temple.defaultDebugMode != DebugMode.NONE)
			{
				if (StageProvider.stage && !StageProvider.stage.contains(_container)) 
				{
					StageProvider.stage.addChild(_container);
					
					if (!DefinitionProvider.isInitialized)
					{
						DefinitionProvider.init();
						DefinitionProvider.registerApplicationDomain(StageProvider.stage.loaderInfo.applicationDomain);
					}
				}
				
				if (propertyColor === -1) propertyColor = getRandomColor();
				
				if (!props)
				{
					addPropertyWithName(scope, null, depth, propertyColor);
				}
				else
				{
					switch (props)
					{
						case props as Array:
						{
							addPropertiesWithNames(scope, props as Array, depth, propertyColor);
							break;
						}
						case props as Class:
						{
							addPropertyWithClassType(scope, props as Class, depth, propertyColor);
							break;
						}
						default:
						{
							addPropertyWithName(scope, props, depth, propertyColor);
							break;
						}
					}
				}
			}
		}
		
		/**
		 * output one property, propertyName is the key
		 */ 
		private function addPropertyWithName(scope:Object, propertyName:*, depth:uint = 0, propertyColor:int = -1):void
		{
			_container.addChild(new LiveInspectorItem(scope, propertyName, depth, propertyColor));
		}
		
		/**
		 * output all property names from array
		 */ 
		private function addPropertiesWithNames(scope:Object, propertyNames:Array, depth:uint = 0, propertyColor:int = -1):void
		{
			var i:uint = 0, leni:uint;
			for (i = 0, leni = propertyNames.length; i < leni; i++)
			{
				_container.addChild(new LiveInspectorItem(scope, propertyNames[i], depth, propertyColor));
			}
		}
		
		/**
		 * inspect all properties with certain Class inside scope-object
		 */
		private function addPropertyWithClassType(scope:Object, className:Class, depth:uint = 0, propertyColor:int = -1):void
		{
			var properties:Vector.<String> = ObjectUtils.getProperties(scope);
			var i:uint = 0, leni:uint;
			for (i = 0, leni = properties.length; i < leni; i++)
			{
				// in some cases your not allowed to read, which causes Error #1077: Illegal read of write-only property
				try
				{
					if (ReflectionUtils.getNameOfTypeOfProperty(scope, properties[i]) === getQualifiedClassName(className))
					{
						_container.addChild(new LiveInspectorItem(scope, properties[i], depth, propertyColor));
					}
				}
				catch(e:Error)
				{
				}
			}
		}
		
		/**
		 * Put the container of the LiveInspector on top of the stage.
		 */
		public function placeContainerOnTopOfStage():void
		{
			StageProvider.stage.setChildIndex(_container, StageProvider.stage.numChildren - 1);
		}

		private function getRandomColor():uint
		{
			return ColorUtils.getColor(30 + getRandom() * 160, 30 + getRandom() * 160, 30 + getRandom() * 160);
		}
 
        //  returns a seeded random Number from 0 � 1
        private function getRandom():Number
        {
            r ^= (r << 21);
            r ^= (r >>> 35);
            r ^= (r << 4);
            return (r * MAX_RATIO);
        }

		override public function destruct():void
		{
			_container = Destructor.destruct(_container);
			
			super.destruct();
		}
	}
}
