/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */
 
package temple.ui.scroll 
{
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.common.interfaces.IShowable;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.buttons.behaviors.ClickRepeater;
	import temple.ui.buttons.behaviors.ScrubBehavior;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.ui.slider.Slider;
	import temple.ui.slider.SliderEvent;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * A ScrollBar is used to control the scrolling of a ScrollPane or ScrollComponent.
	 * 
	 * <p>A ScrollBar need at least a button and a track which can be set in the Flash IDE or by code. If set in the IDE
	 * name the object which must act as track 'track' or 'mcTrack'. The button must be called 'button' or 'mcButton'.</p>
	 * 
	 * @includeExample ScrollComponentExample.as
	 * @includeExample LiquidScrollComponentExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrollBar extends LiquidContainer implements IScrollable, IShowable 
	{
		/**
		 * Instance name of a child which acts as button for the ScrollBar.
		 */
		public static var buttonInstanceName:String = "mcButton";

		/**
		 * Instance name of a child which acts as track for the ScrollBar.
		 */
		public static var trackInstanceName:String = "mcTrack";

		/**
		 * Instance name of a child which acts as upButton for the ScrollBar.
		 */
		public static var upButtonInstanceName:String = "mcUpButton";
		
		/**
		 * Instance name of a child which acts as downButton for the ScrollBar.
		 */
		public static var downButtonInstanceName:String = "mcDownButton";
		
		/**
		 * Instance name of a child which acts as leftButton for the ScrollBar.
		 */
		public static var leftButtonInstanceName:String = "mcLeftButton";
		
		/**
		 * Instance name of a child which acts as rightButton for the ScrollBar.
		 */
		public static var rightButtonInstanceName:String = "mcRightButton";
		
		private static const _DEFAULT_STEP_SIZE:Number = 1/10;

		private static var _scrollProxy:IPropertyProxy;
		private static var _showProxy:IPropertyProxy;
		
		/**
		 * Default IPropertyProxy that is used for scrolling for all ScrollBars if the ScrollBar does not have an own scrollProxy 
		 */
		public static function get scrollProxy():IPropertyProxy
		{
			return ScrollBar._scrollProxy;
		}
		
		/**
		 * @private
		 */
		public static function set scrollProxy(value:IPropertyProxy):void
		{
			ScrollBar._scrollProxy = value;
		}
		
		/**
		 * Default IPropertyProxy that is used for showing and hiding the ScrollBar for all ScrollBars if the ScrollBar does not have an own showProxy 
		 */
		public static function get showProxy():IPropertyProxy
		{
			return ScrollBar._showProxy;
		}
		
		/**
		 * @private
		 */
		public static function set showProxy(value:IPropertyProxy):void
		{
			ScrollBar._showProxy = value;
		}
		
		private var _button:InteractiveObject;
		private var _track:InteractiveObject;
		private var _upButton:InteractiveObject;
		private var _downButton:InteractiveObject;
		private var _leftButton:InteractiveObject;
		private var _rightButton:InteractiveObject;
		private var _upRepeater:ClickRepeater;
		private var _downRepeater:ClickRepeater;
		private var _leftRepeater:ClickRepeater;
		private var _rightRepeater:ClickRepeater;
		private var _slider:Slider;
		private var _scrollPane:IScrollPane;
		private var _autoSizeButton:Boolean;
		private var _minimalButtonSize:Number;
		private var _autoHide:Boolean;
		private var _shown:Boolean = true;
		private var _scrollProxy:IPropertyProxy;
		private var _showProxy:IPropertyProxy;
		private var _trackScrubber:ScrubBehavior;
		private var _dontUpdateScrollPane:Boolean;
		private var _orientation:String;
		private var _blockUpdate:Boolean;
		private var _stepSize:Number = _DEFAULT_STEP_SIZE;
		private var _mouseWheelEnabled:Boolean = true;
		private var _mouseWheelScrollSpeed:Number;
		private var _initialized:Boolean;
		private var _targetScrollH:Number;
		private var _targetScrollV:Number;
		private var _debug:Boolean;
		
		public function ScrollBar()
		{
			this.liquidBehavior.adjustRelated = true;
			this.addEventListener(ScrollEvent.SCROLL, this.handleScroll);
			this.addEventListener(Event.ACTIVATE, this.handleActivate);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);

			this.track ||= this.getChildByName(trackInstanceName) as InteractiveObject;
			this.button ||= this.getChildByName(buttonInstanceName) as InteractiveObject;
			this.upButton ||= this.getChildByName(upButtonInstanceName) as InteractiveObject;
			this.downButton ||= this.getChildByName(downButtonInstanceName) as InteractiveObject;
			this.leftButton ||= this.getChildByName(leftButtonInstanceName) as InteractiveObject;
			this.rightButton ||= this.getChildByName(rightButtonInstanceName) as InteractiveObject;
			
			this.toStringProps.push("orientation");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return this._slider && this.orientation == Orientation.HORIZONTAL ? this._slider.value : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollH", type="Number")]
		public function set scrollH(value:Number):void
		{
			if (!this._blockUpdate && this._slider && this.orientation == Orientation.HORIZONTAL)
			{
				this._slider.value = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			if (this._blockUpdate || isNaN(value)) return;

			this._targetScrollH = value;
			
			if (this._scrollProxy)
			{
				this._scrollProxy.setValue(this, "scrollH", this._targetScrollH);
			}
			else if (ScrollBar._scrollProxy)
			{
				ScrollBar._scrollProxy.setValue(this, "scrollH", this._targetScrollH);
			}
			else
			{
				this.scrollH = this._targetScrollH;
			}
			this._blockUpdate = true;
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, this._targetScrollH, NaN, this.maxScrollH, this.maxScrollV));
			this._blockUpdate = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return this._targetScrollH;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return this._slider && this.orientation == Orientation.HORIZONTAL ? 1 : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return this._slider && this.orientation == Orientation.VERTICAL ? this._slider.value : NaN;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollV", type="Number")]
		public function set scrollV(value:Number):void
		{
			if (!this._blockUpdate && this._slider && this.orientation == Orientation.VERTICAL)
			{
				this._slider.value = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			if (this._blockUpdate || isNaN(value)) return;

			this._targetScrollV = value;
			
			if (this._scrollProxy)
			{
				this._scrollProxy.setValue(this, "scrollV", this._targetScrollV);
			}
			else if (ScrollBar._scrollProxy)
			{
				ScrollBar._scrollProxy.setValue(this, "scrollV", this._targetScrollV);
			}
			else
			{
				this.scrollV = this._targetScrollV;
			}
			this._blockUpdate = true;
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, this._targetScrollV, this.maxScrollH, this.maxScrollV));
			this._blockUpdate = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return this._targetScrollV;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return this._slider && this.orientation == Orientation.VERTICAL ? 1 : NaN;
		}
		
		/**
		 * Get or set the reference to the ScrollPane. Needed of you want the ScrollBar to update his size of the Button according to the ScrollPane
		 */
		public function get scrollPane():IScrollPane
		{
			return this._scrollPane;
		}
		
		/**
		 * @private
		 */
		public function set scrollPane(value:IScrollPane):void
		{
			if (this._scrollPane)
			{
				this._scrollPane.removeEventListener(ScrollEvent.SCROLL, this.handleScrollPaneScroll);
				this._scrollPane.removeEventListener(Event.RESIZE, this.handleScrollPaneResize);
			}
			this._scrollPane = value;
			if (this._scrollPane)
			{
				this._scrollPane.addEventListener(ScrollEvent.SCROLL, this.handleScrollPaneScroll);
				this._scrollPane.addEventListener(Event.RESIZE, this.handleScrollPaneResize);
				this.updateToScrollPane();
			}
		}
		
		/**
		 * The Button of the ScrollBar. The Button is the DisplayObject that is dragged.
		 */
		public function get button():InteractiveObject
		{
			return this._button;
		}
		
		/**
		 * @private
		 */
		public function set button(value:InteractiveObject):void
		{
			if (this._button)
			{
				if (this._slider)
				{
					this._slider.destruct();
					this._slider = null;
				}
			}
			this._button = value;
			if (this._button)
			{
				this._slider = new Slider(this._button, this._track ? this._track.getRect(this) : null, this.orientation);
				this._slider.addEventListener(SliderEvent.SLIDE_START, this.handleSlideStart);
				this._slider.addEventListener(SliderEvent.SLIDING, this.handleSliding);
				this._slider.addEventListener(SliderEvent.SLIDE_STOP, this.handleSlideStop);
				
				// auto flip orientation of ScrollBar is rotated
				if (this.rotation == 90 || this.rotation == -90) this.orientation = this._slider.orientation == Orientation.VERTICAL ? Orientation.HORIZONTAL : Orientation.VERTICAL;
			}
		}
		
		/**
		 * The Track of the ScrollBar. A track is the background of the Button and defines the bounds of the Button.
		 */
		public function get track():InteractiveObject
		{
			return this._track;
		}
		
		/**
		 * @private
		 */
		public function set track(value:InteractiveObject):void
		{
			if (this._track)
			{
				this._track.removeEventListener(MouseEvent.CLICK, this.handleTrackClick);
				this._track.removeEventListener(Event.RESIZE, this.handleTrackResize);
				if (this._trackScrubber)
				{
					this._trackScrubber.destruct();
					this._trackScrubber = null;
				}
			}
			
			this._track = value;
			
			if (this._track)
			{
				this._track.addEventListener(MouseEvent.CLICK, this.handleTrackClick);
				this._track.addEventListener(Event.RESIZE, this.handleTrackResize);
				this._trackScrubber = new ScrubBehavior(this._track);
				
				if (this._initialized && !LiquidBehavior.getInstance(this._track) && this.rotation == 0)
				{
					if (this.orientation == Orientation.VERTICAL)
					{
						new LiquidBehavior(this._track, null,
						{
							top: (this._upButton ? this._upButton.height : 0)
						, 	bottom: (this._downButton ? this._downButton.height : 0)
						,	adjustRelated: true
						,	minimalHeight: this._minimalButtonSize
						});
					}
					else
					{
						new LiquidBehavior(this._track, null,
						{
						 	left: (this._leftButton ? this._leftButton.width : 0)
						, 	right: (this._rightButton ? this._rightButton.width : 0)
						,	adjustRelated: true
						,	minimalWidth: this._minimalButtonSize
						});
					}
				}
				
				if (this._slider)
				{
					this._slider.bounds = this._track.getRect(this);
					this._slider.orientation = this._track.width < this._track.height ? Orientation.VERTICAL : Orientation.HORIZONTAL;
					
					// auto flip orientation of ScrollBar is rotated
					if (this.rotation == 90 || this.rotation == -90) this.orientation = this._slider.orientation == Orientation.VERTICAL ? Orientation.HORIZONTAL : Orientation.VERTICAL;
				}
			}
		}
		
		/**
		 * Button used to scroll up one step
		 */
		public function get upButton():InteractiveObject
		{
			return this._upButton;
		}
		
		/**
		 * @private
		 */
		public function set upButton(value:InteractiveObject):void
		{
			if (this._upButton)
			{
				this._upButton.removeEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._upRepeater.destruct();
				this._upRepeater = null;
			}
			
			this._upButton = value;
			
			if (this._upButton)
			{
				this._upButton.addEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._upRepeater = new ClickRepeater(this._upButton);
				if (this._initialized && this.rotation == 0)
				{
					if (!LiquidBehavior.getInstance(this._upButton)) new LiquidBehavior(this._upButton, null, {top: 0, adjustRelated: true});
					if (this._track) LiquidBehavior.getInstance(this._track).top = this._upButton.height;
				}
			}
		}
		
		/**
		 * Button used to scroll down one step
		 */
		public function get downButton():InteractiveObject
		{
			return this._downButton;
		}
		
		/**
		 * @private
		 */
		public function set downButton(value:InteractiveObject):void
		{
			if (this._downButton) 
			{
				this._downButton.removeEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._downRepeater.destruct();
				this._downRepeater = null;
			}
			
			this._downButton = value;
			
			if (this._downButton)
			{
				this._downButton.addEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._downRepeater = new ClickRepeater(this._downButton);
				
				if (this._initialized && this.rotation == 0)
				{
					if (!LiquidBehavior.getInstance(this._downButton)) new LiquidBehavior(this._downButton, this, {bottom: 0, adjustRelated: true});
					if (this._track) LiquidBehavior.getInstance(this._track).bottom = this._downButton.height;
				}
			}
		}

		/**
		 * Button used to scroll left one step
		 */
		public function get leftButton():InteractiveObject
		{
			return this._leftButton;
		}
		
		/**
		 * @private
		 */
		public function set leftButton(value:InteractiveObject):void
		{
			if (this._leftButton)
			{
				this._leftButton.removeEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._leftRepeater.destruct();
				this._leftRepeater = null;
			}
			
			this._leftButton = value;
			
			if (this._leftButton)
			{
				this._leftButton.addEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._leftRepeater = new ClickRepeater(this._leftButton);
				if (this._initialized && this.rotation == 0)
				{
					if (!LiquidBehavior.getInstance(this._leftButton)) new LiquidBehavior(this._leftButton, this, {left: 0, adjustRelated: true});
					if (this._track) LiquidBehavior.getInstance(this._track).left = this._leftButton.width;
				}
			}
		}
		
		/**
		 * Button used to scroll right one step
		 */
		public function get rightButton():InteractiveObject
		{
			return this._rightButton;
		}
		
		/**
		 * @private
		 */
		public function set rightButton(value:InteractiveObject):void
		{
			if (this._rightButton)
			{
				this._rightButton.removeEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._rightRepeater.destruct();
				this._rightRepeater = null;
			}
			
			this._rightButton = value;
			
			if (this._rightButton)
			{
				this._rightButton.addEventListener(MouseEvent.CLICK, this.handleScrollButtonClick);
				this._rightRepeater = new ClickRepeater(this._rightButton);
				if (this._initialized && this.rotation == 0)
				{
					if (!LiquidBehavior.getInstance(this._rightButton)) new LiquidBehavior(this._rightButton, this, {right: 0, adjustRelated: true});
					if (this._track) LiquidBehavior.getInstance(this._track).right = this._rightButton.width;
				}
			}
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the upButton 
		 */
		public function get upRepeater():ClickRepeater
		{
			return this._upRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the downButton 
		 */
		public function get downRepeater():ClickRepeater
		{
			return this._downRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the leftButton 
		 */
		public function get leftRepeater():ClickRepeater
		{
			return this._leftRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the rightButton .
		 */
		public function get rightRepeater():ClickRepeater
		{
			return this._rightRepeater;
		}
		
		/**
		 * IPropertyProxy that is used for scrolling.
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return this._scrollProxy;
		}
		
		/**
		 * @private
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			this._scrollProxy = value;
		}
		
		/**
		 * IPropertyProxy that is used for showing and hiding the ScrollBar.
		 */
		public function get showProxy():IPropertyProxy
		{
			return this._showProxy;
		}
		
		/**
		 * @private
		 */
		public function set showProxy(value:IPropertyProxy):void
		{
			this._showProxy = value;
		}
	
		/**
		 * A Boolean which indicates if the size of the buttons should we changed according to the size of the
		 * content height and visible height (scrollFactor) of the ScrollPane.
		 */
		public function get autoSizeButton():Boolean
		{
			return this._autoSizeButton;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Auto Size Button", type="Boolean", defaultValue="false")]
		public function set autoSizeButton(value:Boolean):void
		{
			this._autoSizeButton = value;
			if (this._autoSizeButton) this.updateToScrollPane();
		}
		
		/**
		 * The minimal size of the button. This value is only used when 'autoSizeButton' is set to true.
		 */
		public function get minimalButtonSize():Number
		{
			return this._minimalButtonSize;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Minimal Button Size", type="Number")]
		public function set minimalButtonSize(value:Number):void
		{
			this._minimalButtonSize = value;
			
			if (this._minimalButtonSize) this.updateToScrollPane();
			
			var liquid:LiquidBehavior;
			if (this._track && (liquid = LiquidBehavior.getInstance(this._track)))
			{
				switch (this.orientation)
				{
					case Orientation.HORIZONTAL:
					{
						liquid.minimalWidth = this._minimalButtonSize;
						break;
					}
					case Orientation.VERTICAL:
					{
						liquid.minimalHeight = this._minimalButtonSize;
						break;
					}
				}
			}
		}
		
		/**
		 * A Boolean which indicates if the ScrollBar should be hidden when no scrolling is needed.
		 */
		public function get autoHide():Boolean
		{
			return this._autoHide;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Auto Hide", type="Boolean", defaultValue="true")]
		public function set autoHide(value:Boolean):void
		{
			this._autoHide = value;
			if (this._autoHide) this.updateToScrollPane();
		}
		
		/**
		 * @inheritDoc
		 */
		public function show(instant:Boolean = false):void
		{
			if (!this._shown)
			{
				this._shown = true;

				if (!instant && this._showProxy)
				{
					this._showProxy.setValue(this, "visible", true);
				}
				else if (!instant && ScrollBar._showProxy)
				{
					ScrollBar._showProxy.setValue(this, "visible", true);
				}
				else
				{
					this.visible = true;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hide(instant:Boolean = false):void
		{
			if (this._shown)
			{
				this._shown = false;
				
				if (!instant && this._showProxy)
				{
					this._showProxy.setValue(this, "visible", false);
				}
				else if (!instant && ScrollBar._showProxy)
				{
					ScrollBar._showProxy.setValue(this, "visible", false);
				}
				else
				{
					this.visible = false;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get shown():Boolean
		{
			return this._shown;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Shown", type="Boolean", defaultValue="true")]
		public function set shown(value:Boolean):void
		{
			if (value)
			{
				this.show();
			}
			else
			{
				this.hide();
			}
		}
		
		/**
		 * Get or set the orientation (Orientation.HORIZONTAL or Orientation.VERTICAL)
		 * 
		 * @see temple.common.enum.Orientation
		 */
		public function get orientation():String
		{
			if (this._orientation)
			{
				return this._orientation;
			}
			else if (this._slider)
			{
				return this._slider.orientation;
			}
			else if (this._track)
			{
				return this._track.width > this._track.height ? Orientation.HORIZONTAL : Orientation.VERTICAL;
			}
			return null;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Orientation", type="String", defaultValue="auto", enumeration="auto,vertical,horizontal")]
		public function set orientation(value:String):void
		{
			switch (value)
			{
				case null:
				case "":
				case "auto":
				{
					this._orientation = null;
					break;
				}
				case Orientation.HORIZONTAL:
				case Orientation.VERTICAL:
				{
					this._orientation = value;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for orientation '" + value + "'"));
					break;
				}
			}
		}
		
		/**
		 * Get or set the direction (Direction.ASCENDING or Direction.DESCENDING)
		 * 
		 * @see temple.common.enum.Direction
		 */
		public function get direction():String
		{
			return this._slider.direction;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Direction", type="String", defaultValue="ascending", enumeration="ascending,descending")]
		public function set direction(value:String):void
		{
			this._slider.direction = value;
		}
		
		/**
		 * The size of one step. Used by the upButton, downButton, leftButton and rightButton, but only if the ScrollBar has no IScrollPane.
		 * Value muste be between 0 and 1, where 1 means the maximum scroll.
		 */
		public function get stepSize():Number
		{
			return this._stepSize;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="StepSize", type="Number", defaultValue="0.1")]
		public function set stepSize(value:Number):void
		{
			value = Math.max(Math.min(value, 1), 0);
			
			this._stepSize = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSize is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return this._mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="MouseWheelScrollSpeed", type="Number")]
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			this._mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollBar is automaticly scrolled when the user rolls the mouse wheel over the ScrollBar.
		 * By default, this value is true.
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return this._mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="MouseWheelEnabled", type="Boolean", defaultValue="true")]
		public function set mouseWheelEnabled(value:Boolean):void
		{
			this._mouseWheelEnabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
		
		/**
		 * @private
		 */
		override protected function initLiquid():void
		{
			super.initLiquid();
			
			this._initialized = true;
			
			/**
			 * reset buttons and track to init liquid (can't be done before since width and height are not set)
			 */
			this.track = this.track;
			this.upButton = this.upButton;
			this.downButton = this.downButton;
			this.leftButton = this.leftButton;
			this.rightButton = this.rightButton;
		}

		/**
		 * @private
		 */
		protected function updateToScrollPane():void
		{
			if (this._scrollPane)
			{
				var visibleFactor:Number;
				
				if (this.orientation == Orientation.HORIZONTAL)
				{
					if (this._autoSizeButton || this._autoHide)
					{
						visibleFactor = Math.min(this._scrollPane.width / this._scrollPane.contentWidth, 1);
						if (isNaN(visibleFactor) || visibleFactor < 0) visibleFactor = 1;
						
						if (this._autoHide) this.shown = visibleFactor < 1;
						
						if (this._autoSizeButton)
						{
							this._button.width = this._track.width * visibleFactor;
							if (this._button.width < this._minimalButtonSize / this.scaleX) this._button.width = this._minimalButtonSize / this.scaleX;
						}
					}
					this.scrollH = this._scrollPane.maxScrollH ? this._scrollPane.scrollH / this._scrollPane.maxScrollH : 0;
					if (this.debug) this.logDebug("updateToScrollPane: orientation=" + this.orientation + ", width=" + this._scrollPane.width + ", contentWidth=" + this._scrollPane.contentWidth + ", visibleFactor=" + visibleFactor + ", scrollH=" + scrollH);
				}
				else
				{
					if (this._autoSizeButton || this._autoHide)
					{
						visibleFactor = Math.min(this._scrollPane.height / (this._scrollPane.contentHeight-1), 1);
						if (isNaN(visibleFactor) || visibleFactor < 0) visibleFactor = 1;
						
						if (this._autoHide) this.shown = visibleFactor < 1;
						
						if (this._autoSizeButton)
						{
							this._button.height = this._track.height * visibleFactor;
							if (this._button.height < this._minimalButtonSize / this.scaleY) this._button.height = this._minimalButtonSize / this.scaleY;
						}
					}
					this.scrollV = this._scrollPane.maxScrollV ? this._scrollPane.scrollV / this._scrollPane.maxScrollV : 0;
					if (this.debug) this.logDebug("updateToScrollPane: orientation=" + this.orientation + ", height=" + this._scrollPane.height + ", contentHeight=" + this._scrollPane.contentHeight + ", visibleFactor=" + visibleFactor + ", scrollV=" + scrollV);
				}
			}
		}
		
		private function handleSlideStart(event:SliderEvent):void
		{
			this._blockUpdate = true;
			if (this._scrollProxy) this._scrollProxy.cancel();
		}
		
		private function handleSliding(event:SliderEvent):void
		{
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, this.scrollH, this.scrollV, this.maxScrollH, this.maxScrollV));
		}
		
		private function handleSlideStop(event:SliderEvent):void
		{
			this._blockUpdate = false;
		}
		
		private function handleScroll(event:ScrollEvent):void
		{
			if (this._scrollPane && !this._dontUpdateScrollPane)
			{
				if (!isNaN(event.scrollH)) this._scrollPane.scrollHTo(event.scrollH * this._scrollPane.maxScrollH);
				if (!isNaN(event.scrollV)) this._scrollPane.scrollVTo(event.scrollV * this._scrollPane.maxScrollV);
			}
		}
		
		private function handleTrackClick(event:MouseEvent):void
		{
			var scroll:Number;
			
			if (this._slider.orientation == Orientation.HORIZONTAL)
			{
				scroll = this._track.mouseX * this._track.scaleX / this._track.width;
			}
			else
			{
				scroll = (this._track.mouseY * this._track.scaleY -.5 * this._button.height) / (this._track.height - this._button.height);
			}
			
			if (this.orientation == Orientation.HORIZONTAL)
			{
				if (this.direction == Direction.ASCENDING)
				{
					this.scrollHTo(scroll);
				}
				else
				{
					this.scrollHTo(1 - scroll);
				}
			}
			else
			{
				
				if (this.direction == Direction.ASCENDING)
				{
					this.scrollVTo(scroll);
				}
				else
				{
					this.scrollVTo(1 - scroll);
				}
			}
		}
		
		private function handleTrackResize(event:Event):void
		{
			if (this._slider) this._slider.bounds = this._track.getBounds(this);
			this.updateToScrollPane();
		}
		
		private function handleScrollPaneScroll(event:ScrollEvent):void
		{
			if (this._blockUpdate) return;
			
			this._dontUpdateScrollPane = true;
			this.scrollHTo(event.scrollH / event.maxScrollH);
			this.scrollVTo(event.scrollV / event.maxScrollV);
			this._dontUpdateScrollPane = false;
		}
		
		private function handleScrollPaneResize(event:Event):void
		{
			this.updateToScrollPane();
		}
		
		private function handleScrollButtonClick(event:MouseEvent):void
		{
			if (this.orientation == this._slider.orientation)
			{
				switch (event.target)
				{
					case this._upButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollUp();
						}
						else
						{
							this.scrollVTo(this.scrollV - this._stepSize);
						}
						break;
					}
					case this._downButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollDown();
						}
						else
						{
							this.scrollVTo(this.scrollV + this._stepSize);
						}
						break;
					}
					case this._leftButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollLeft();
						}
						else
						{
							this.scrollHTo(this.scrollH - this._stepSize);
						}
						break;
					}
					case this._rightButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollRight();
						}
						else
						{
							this.scrollHTo(this.scrollH + this._stepSize);
						}
						break;
					}
				}
			}
			else
			{
				// Swap horizontal - vertical
				switch (event.target)
				{
					case this._upButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollLeft();
						}
						else
						{
							this.scrollHTo(this.scrollH - this._stepSize);
						}
						break;
					}
					case this._downButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollRight();
						}
						else
						{
							this.scrollHTo(this.scrollH + this._stepSize);
						}
						break;
					}
					case this._leftButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollUp();
						}
						else
						{
							this.scrollVTo(this.scrollV - this._stepSize);
						}
						break;
					}
					case this._rightButton:
					{
						if (this._scrollPane)
						{
							this._scrollPane.scrollDown();
						}
						else
						{
							this.scrollVTo(this.scrollV + this._stepSize);
						}
						break;
					}
				}
			}
		}
		
		private function handleMouseWheel(event:MouseEvent):void
		{
			if (this._mouseWheelEnabled)
			{
				if (this.orientation == Orientation.VERTICAL)
				{
					this.scrollVTo(this.scrollV + (!isNaN(this._mouseWheelScrollSpeed) ? this._mouseWheelScrollSpeed: this._stepSize) * -event.delta);
				}
				else
				{
					this.scrollHTo(this.scrollH + (!isNaN(this._mouseWheelScrollSpeed) ? this._mouseWheelScrollSpeed: this._stepSize) * -event.delta);
				}
			}
		}
		
		private function handleActivate(event:Event):void
		{
			this.removeEventListener(Event.ACTIVATE, this.handleActivate);
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.scrollPane = null;
			this.button = null;
			this.track = null;
			this.upButton = null;
			this.downButton = null;
			this.leftButton = null;
			this.rightButton = null;
			this._scrollProxy = null;
			this._showProxy = null;
			this._trackScrubber = null;
			
			super.destruct();
		}
	}
}