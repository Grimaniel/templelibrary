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
			this._container = new VBox(-1);
			
			if (initObject)
			{
				for (var prop:String in initObject)
				{
					if (prop in this._container) this._container[prop] = initObject[prop];
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
				if (StageProvider.stage && !StageProvider.stage.contains(this._container)) 
				{
					StageProvider.stage.addChild(this._container);
					
					if (!DefinitionProvider.isInitialized)
					{
						DefinitionProvider.init();
						DefinitionProvider.registerApplicationDomain(StageProvider.stage.loaderInfo.applicationDomain);
					}
				}
				
				if (propertyColor === -1) propertyColor = this.getRandomColor();
				
				if (!props)
				{
					this.addPropertyWithName(scope, null, depth, propertyColor);
				}
				else
				{
					switch (props)
					{
						case props as Array:
						{
							this.addPropertiesWithNames(scope, props as Array, depth, propertyColor);
							break;
						}
						case props as Class:
						{
							this.addPropertyWithClassType(scope, props as Class, depth, propertyColor);
							break;
						}
						default:
						{
							this.addPropertyWithName(scope, props, depth, propertyColor);
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
			this._container.addChild(new LiveInspectorItem(scope, propertyName, depth, propertyColor));
		}
		
		/**
		 * output all property names from array
		 */ 
		private function addPropertiesWithNames(scope:Object, propertyNames:Array, depth:uint = 0, propertyColor:int = -1):void
		{
			var i:uint = 0, leni:uint;
			for (i = 0, leni = propertyNames.length; i < leni; i++)
			{
				this._container.addChild(new LiveInspectorItem(scope, propertyNames[i], depth, propertyColor));
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
						this._container.addChild(new LiveInspectorItem(scope, properties[i], depth, propertyColor));
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
			StageProvider.stage.setChildIndex(this._container, StageProvider.stage.numChildren - 1);
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
			this._container = Destructor.destruct(this._container);
			
			super.destruct();
		}
	}
}
