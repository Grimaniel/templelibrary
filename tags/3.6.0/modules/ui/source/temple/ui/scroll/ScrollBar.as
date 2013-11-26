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
			construct::scrollBar();
		}

		/**
		 * @private
		 */
		construct function scrollBar():void
		{
			liquidBehavior.adjustRelated = true;
			addEventListener(ScrollEvent.SCROLL, handleScroll);
			addEventListener(Event.ACTIVATE, handleActivate);
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);

			track ||= getChildByName(trackInstanceName) as InteractiveObject;
			button ||= getChildByName(buttonInstanceName) as InteractiveObject;
			upButton ||= getChildByName(upButtonInstanceName) as InteractiveObject;
			downButton ||= getChildByName(downButtonInstanceName) as InteractiveObject;
			leftButton ||= getChildByName(leftButtonInstanceName) as InteractiveObject;
			rightButton ||= getChildByName(rightButtonInstanceName) as InteractiveObject;
			
			toStringProps.push("orientation");
			
			if (!_track) logError("No track found.");
			if (!_button) logError("No button found.");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return _slider && orientation == Orientation.HORIZONTAL ? _slider.value : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollH", type="Number")]
		public function set scrollH(value:Number):void
		{
			if (!_blockUpdate && _slider && orientation == Orientation.HORIZONTAL)
			{
				_slider.value = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			if (_blockUpdate || isNaN(value)) return;

			_targetScrollH = value;
			
			if (_scrollProxy)
			{
				_scrollProxy.setValue(this, "scrollH", _targetScrollH);
			}
			else if (ScrollBar._scrollProxy)
			{
				ScrollBar._scrollProxy.setValue(this, "scrollH", _targetScrollH);
			}
			else
			{
				scrollH = _targetScrollH;
			}
			_blockUpdate = true;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, _targetScrollH, NaN, maxScrollH, maxScrollV));
			_blockUpdate = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return _targetScrollH;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return _slider && orientation == Orientation.HORIZONTAL ? 1 : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return _slider && orientation == Orientation.VERTICAL ? _slider.value : NaN;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollV", type="Number")]
		public function set scrollV(value:Number):void
		{
			if (!_blockUpdate && _slider && orientation == Orientation.VERTICAL)
			{
				_slider.value = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			if (_blockUpdate || isNaN(value)) return;

			_targetScrollV = value;
			
			if (_scrollProxy)
			{
				_scrollProxy.setValue(this, "scrollV", _targetScrollV);
			}
			else if (ScrollBar._scrollProxy)
			{
				ScrollBar._scrollProxy.setValue(this, "scrollV", _targetScrollV);
			}
			else
			{
				scrollV = _targetScrollV;
			}
			_blockUpdate = true;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, _targetScrollV, maxScrollH, maxScrollV));
			_blockUpdate = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return _targetScrollV;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return _slider && orientation == Orientation.VERTICAL ? 1 : NaN;
		}
		
		/**
		 * Get or set the reference to the ScrollPane. Needed of you want the ScrollBar to update his size of the Button according to the ScrollPane
		 */
		public function get scrollPane():IScrollPane
		{
			return _scrollPane;
		}
		
		/**
		 * @private
		 */
		public function set scrollPane(value:IScrollPane):void
		{
			if (_scrollPane)
			{
				_scrollPane.removeEventListener(ScrollEvent.SCROLL, handleScrollPaneScroll);
				_scrollPane.removeEventListener(Event.RESIZE, handleScrollPaneResize);
			}
			_scrollPane = value;
			if (_scrollPane)
			{
				_scrollPane.addEventListener(ScrollEvent.SCROLL, handleScrollPaneScroll);
				_scrollPane.addEventListener(Event.RESIZE, handleScrollPaneResize);
				updateToScrollPane();
			}
		}
		
		/**
		 * The Button of the ScrollBar. The Button is the DisplayObject that is dragged.
		 */
		public function get button():InteractiveObject
		{
			return _button;
		}
		
		/**
		 * @private
		 */
		public function set button(value:InteractiveObject):void
		{
			if (_button)
			{
				if (_slider)
				{
					_slider.destruct();
					_slider = null;
				}
			}
			_button = value;
			if (_button && _track)
			{
				_slider = new Slider(_button, _track ? _track.getRect(this) : null, orientation);
				_slider.addEventListener(SliderEvent.SLIDE_START, handleSlideStart);
				_slider.addEventListener(SliderEvent.SLIDING, handleSliding);
				_slider.addEventListener(SliderEvent.SLIDE_STOP, handleSlideStop);
				
				// auto flip orientation of ScrollBar is rotated
				if (rotation == 90 || rotation == -90) orientation = _slider.orientation == Orientation.VERTICAL ? Orientation.HORIZONTAL : Orientation.VERTICAL;
			}
		}
		
		/**
		 * The Track of the ScrollBar. A track is the background of the Button and defines the bounds of the Button.
		 */
		public function get track():InteractiveObject
		{
			return _track;
		}
		
		/**
		 * @private
		 */
		public function set track(value:InteractiveObject):void
		{
			if (_track)
			{
				_track.removeEventListener(MouseEvent.CLICK, handleTrackClick);
				_track.removeEventListener(Event.RESIZE, handleTrackResize);
				if (_trackScrubber)
				{
					_trackScrubber.destruct();
					_trackScrubber = null;
				}
			}
			
			_track = value;
			
			if (_track)
			{
				_track.addEventListener(MouseEvent.CLICK, handleTrackClick);
				_track.addEventListener(Event.RESIZE, handleTrackResize);
				_trackScrubber = new ScrubBehavior(_track);
				
				if (_initialized && !LiquidBehavior.getInstance(_track) && rotation == 0)
				{
					if (orientation == Orientation.VERTICAL)
					{
						new LiquidBehavior(_track,
						{
							top: (_upButton ? _upButton.height : 0)
						, 	bottom: (_downButton ? _downButton.height : 0)
						,	adjustRelated: true
						,	minimalHeight: _minimalButtonSize
						});
					}
					else
					{
						new LiquidBehavior(_track,
						{
						 	left: (_leftButton ? _leftButton.width : 0)
						, 	right: (_rightButton ? _rightButton.width : 0)
						,	adjustRelated: true
						,	minimalWidth: _minimalButtonSize
						});
					}
				}
				
				if (_slider)
				{
					_slider.bounds = _track.getRect(this);
					
					// don't overwrite the orientation if an orientation has been set!
					if (!_orientation)
					{
						_orientation = _slider.orientation =_track.width < _track.height ? Orientation.VERTICAL : Orientation.HORIZONTAL;

						// auto flip orientation of ScrollBar is rotated
						if (this.rotation == 90 || this.rotation == -90) this.orientation = this._slider.orientation == Orientation.VERTICAL ? Orientation.HORIZONTAL : Orientation.VERTICAL;
					}
				}
				else if (_button)
				{
					// reset button to force creation of Slider
					button = _button;
				}
			}
		}
		
		/**
		 * Button used to scroll up one step
		 */
		public function get upButton():InteractiveObject
		{
			return _upButton;
		}
		
		/**
		 * @private
		 */
		public function set upButton(value:InteractiveObject):void
		{
			if (_upButton)
			{
				_upButton.removeEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_upRepeater.destruct();
				_upRepeater = null;
			}
			
			_upButton = value;
			
			if (_upButton)
			{
				_upButton.addEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_upRepeater = new ClickRepeater(_upButton);
				if (_initialized && rotation == 0)
				{
					if (!LiquidBehavior.getInstance(_upButton)) new LiquidBehavior(_upButton, {top: 0, adjustRelated: true});
					if (_track) LiquidBehavior.getInstance(_track).top = _upButton.height;
				}
			}
		}
		
		/**
		 * Button used to scroll down one step
		 */
		public function get downButton():InteractiveObject
		{
			return _downButton;
		}
		
		/**
		 * @private
		 */
		public function set downButton(value:InteractiveObject):void
		{
			if (_downButton) 
			{
				_downButton.removeEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_downRepeater.destruct();
				_downRepeater = null;
			}
			
			_downButton = value;
			
			if (_downButton)
			{
				_downButton.addEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_downRepeater = new ClickRepeater(_downButton);
				
				if (_initialized && rotation == 0)
				{
					if (!LiquidBehavior.getInstance(_downButton)) new LiquidBehavior(_downButton, {bottom: 0, adjustRelated: true}, this);
					if (_track) LiquidBehavior.getInstance(_track).bottom = _downButton.height;
				}
			}
		}

		/**
		 * Button used to scroll left one step
		 */
		public function get leftButton():InteractiveObject
		{
			return _leftButton;
		}
		
		/**
		 * @private
		 */
		public function set leftButton(value:InteractiveObject):void
		{
			if (_leftButton)
			{
				_leftButton.removeEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_leftRepeater.destruct();
				_leftRepeater = null;
			}
			
			_leftButton = value;
			
			if (_leftButton)
			{
				_leftButton.addEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_leftRepeater = new ClickRepeater(_leftButton);
				if (_initialized && rotation == 0)
				{
					if (!LiquidBehavior.getInstance(_leftButton)) new LiquidBehavior(_leftButton, {left: 0, adjustRelated: true}, this);
					if (_track) LiquidBehavior.getInstance(_track).left = _leftButton.width;
				}
			}
		}
		
		/**
		 * Button used to scroll right one step
		 */
		public function get rightButton():InteractiveObject
		{
			return _rightButton;
		}
		
		/**
		 * @private
		 */
		public function set rightButton(value:InteractiveObject):void
		{
			if (_rightButton)
			{
				_rightButton.removeEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_rightRepeater.destruct();
				_rightRepeater = null;
			}
			
			_rightButton = value;
			
			if (_rightButton)
			{
				_rightButton.addEventListener(MouseEvent.CLICK, handleScrollButtonClick);
				_rightRepeater = new ClickRepeater(_rightButton);
				if (_initialized && rotation == 0)
				{
					if (!LiquidBehavior.getInstance(_rightButton)) new LiquidBehavior(_rightButton, {right: 0, adjustRelated: true}, this);
					if (_track) LiquidBehavior.getInstance(_track).right = _rightButton.width;
				}
			}
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the upButton 
		 */
		public function get upRepeater():ClickRepeater
		{
			return _upRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the downButton 
		 */
		public function get downRepeater():ClickRepeater
		{
			return _downRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the leftButton 
		 */
		public function get leftRepeater():ClickRepeater
		{
			return _leftRepeater;
		}
		
		/**
		 * Returns a reference to the ClickRepeater of the rightButton .
		 */
		public function get rightRepeater():ClickRepeater
		{
			return _rightRepeater;
		}
		
		/**
		 * IPropertyProxy that is used for scrolling.
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return _scrollProxy;
		}
		
		/**
		 * @private
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			_scrollProxy = value;
		}
		
		/**
		 * IPropertyProxy that is used for showing and hiding the ScrollBar.
		 */
		public function get showProxy():IPropertyProxy
		{
			return _showProxy;
		}
		
		/**
		 * @private
		 */
		public function set showProxy(value:IPropertyProxy):void
		{
			_showProxy = value;
		}
	
		/**
		 * A Boolean which indicates if the size of the buttons should we changed according to the size of the
		 * content height and visible height (scrollFactor) of the ScrollPane.
		 */
		public function get autoSizeButton():Boolean
		{
			return _autoSizeButton;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Auto Size Button", type="Boolean", defaultValue="false")]
		public function set autoSizeButton(value:Boolean):void
		{
			_autoSizeButton = value;
			if (_autoSizeButton) updateToScrollPane();
		}
		
		/**
		 * The minimal size of the button. This value is only used when 'autoSizeButton' is set to true.
		 */
		public function get minimalButtonSize():Number
		{
			return _minimalButtonSize;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Minimal Button Size", type="Number")]
		public function set minimalButtonSize(value:Number):void
		{
			_minimalButtonSize = value;
			
			if (_minimalButtonSize) updateToScrollPane();
			
			var liquid:LiquidBehavior;
			if (_track && (liquid = LiquidBehavior.getInstance(_track)))
			{
				switch (orientation)
				{
					case Orientation.HORIZONTAL:
					{
						liquid.minimalWidth = _minimalButtonSize;
						break;
					}
					case Orientation.VERTICAL:
					{
						liquid.minimalHeight = _minimalButtonSize;
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
			return _autoHide;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Auto Hide", type="Boolean", defaultValue="true")]
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			if (_autoHide) updateToScrollPane();
		}
		
		/**
		 * @inheritDoc
		 */
		public function show(instant:Boolean = false, onComplete:Function = null):void
		{
			if (!_shown)
			{
				_shown = true;

				if (!instant && _showProxy)
				{
					_showProxy.setValue(this, "visible", true, onComplete);
				}
				else if (!instant && ScrollBar._showProxy)
				{
					ScrollBar._showProxy.setValue(this, "visible", true, onComplete);
				}
				else
				{
					visible = true;
					if (onComplete != null) onComplete(); 
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hide(instant:Boolean = false, onComplete:Function = null):void
		{
			if (_shown)
			{
				_shown = false;
				
				if (!instant && _showProxy)
				{
					_showProxy.setValue(this, "visible", false, onComplete);
				}
				else if (!instant && ScrollBar._showProxy)
				{
					ScrollBar._showProxy.setValue(this, "visible", false, onComplete);
				}
				else
				{
					visible = false;
					if (onComplete != null) onComplete();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get shown():Boolean
		{
			return _shown;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Shown", type="Boolean", defaultValue="true")]
		public function set shown(value:Boolean):void
		{
			if (value)
			{
				show();
			}
			else
			{
				hide();
			}
		}
		
		/**
		 * Get or set the orientation (Orientation.HORIZONTAL or Orientation.VERTICAL)
		 * 
		 * @see temple.common.enum.Orientation
		 */
		public function get orientation():String
		{
			if (_orientation)
			{
				return _orientation;
			}
			else if (_slider)
			{
				return _slider.orientation;
			}
			else if (_track)
			{
				return _track.width > _track.height ? Orientation.HORIZONTAL : Orientation.VERTICAL;
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
					_orientation = null;
					break;
				}
				case Orientation.HORIZONTAL:
				case Orientation.VERTICAL:
				{
					_orientation = value;
					if (_slider) _slider.orientation = value;
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
			return _slider.direction;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Direction", type="String", defaultValue="ascending", enumeration="ascending,descending")]
		public function set direction(value:String):void
		{
			_slider.direction = value;
		}
		
		/**
		 * The size of one step. Used by the upButton, downButton, leftButton and rightButton, but only if the ScrollBar has no IScrollPane.
		 * Value muste be between 0 and 1, where 1 means the maximum scroll.
		 */
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="StepSize", type="Number", defaultValue="0.1")]
		public function set stepSize(value:Number):void
		{
			value = Math.max(Math.min(value, 1), 0);
			
			_stepSize = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSize is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return _mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="MouseWheelScrollSpeed", type="Number")]
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			_mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollBar is automaticly scrolled when the user rolls the mouse wheel over the ScrollBar.
		 * By default, this value is true.
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return _mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="MouseWheelEnabled", type="Boolean", defaultValue="true")]
		public function set mouseWheelEnabled(value:Boolean):void
		{
			_mouseWheelEnabled = value;
		}
		
		/**
		 * Returns a reference to the <code>Slider</code>.
		 */
		public function get slider():Slider
		{
			return _slider;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		/**
		 * @private
		 */
		override protected function initLiquid():void
		{
			super.initLiquid();
			
			_initialized = true;
			
			/**
			 * reset buttons and track to init liquid (can't be done before since width and height are not set)
			 */
			track = track;
			upButton = upButton;
			downButton = downButton;
			leftButton = leftButton;
			rightButton = rightButton;
		}

		/**
		 * @private
		 */
		protected function updateToScrollPane():void
		{
			if (_scrollPane)
			{
				var visibleFactor:Number;
				
				if (orientation == Orientation.HORIZONTAL)
				{
					if (_autoSizeButton || _autoHide)
					{
						visibleFactor = Math.min(_scrollPane.width / _scrollPane.contentWidth, 1);
						if (isNaN(visibleFactor) || visibleFactor <= 0) visibleFactor = 1;
						
						if (_autoHide) shown = visibleFactor < 1;
						
						if (_autoSizeButton)
						{
							_button.width = _track.width * visibleFactor;
							if (_button.width < _minimalButtonSize / scaleX) _button.width = _minimalButtonSize / scaleX;
						}
					}
					scrollH = _scrollPane.maxScrollH ? _scrollPane.scrollH / _scrollPane.maxScrollH : 0;
					if (debug) logDebug("updateToScrollPane: orientation=" + orientation + ", width=" + _scrollPane.width + ", contentWidth=" + _scrollPane.contentWidth + ", visibleFactor=" + visibleFactor + ", scrollH=" + scrollH);
				}
				else
				{
					if (_autoSizeButton || _autoHide)
					{
						visibleFactor = Math.min(_scrollPane.height / (_scrollPane.contentHeight-1), 1);
						if (isNaN(visibleFactor) || visibleFactor <= 0) visibleFactor = 1;
						
						if (_autoHide) shown = visibleFactor < 1;
						
						if (_autoSizeButton)
						{
							_button.height = _track.height * visibleFactor;
							if (_button.height < _minimalButtonSize / scaleY) _button.height = _minimalButtonSize / scaleY;
						}
					}
					scrollV = _scrollPane.maxScrollV ? _scrollPane.scrollV / _scrollPane.maxScrollV : 0;
					if (debug) logDebug("updateToScrollPane: orientation=" + orientation + ", height=" + _scrollPane.height + ", contentHeight=" + _scrollPane.contentHeight + ", visibleFactor=" + visibleFactor + ", scrollV=" + scrollV);
				}
			}
		}
		
		private function handleSlideStart(event:SliderEvent):void
		{
			_blockUpdate = true;
			if (_scrollProxy) _scrollProxy.cancel();
		}
		
		private function handleSliding(event:SliderEvent):void
		{
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, scrollH, scrollV, maxScrollH, maxScrollV));
		}
		
		private function handleSlideStop(event:SliderEvent):void
		{
			_blockUpdate = false;
		}
		
		protected function handleScroll(event:ScrollEvent):void
		{
			if (_scrollPane && !_dontUpdateScrollPane)
			{
				if (!isNaN(event.scrollH)) _scrollPane.scrollHTo(event.scrollH * _scrollPane.maxScrollH);
				if (!isNaN(event.scrollV)) _scrollPane.scrollVTo(event.scrollV * _scrollPane.maxScrollV);
			}
		}
		
		private function handleTrackClick(event:MouseEvent):void
		{
			var scroll:Number;
			
			if (_slider.orientation == Orientation.HORIZONTAL)
			{
				scroll = _track.mouseX * _track.scaleX / _track.width;
			}
			else
			{
				scroll = (_track.mouseY * _track.scaleY -.5 * _button.height) / (_track.height - _button.height);
			}
			
			if (orientation == Orientation.HORIZONTAL)
			{
				if (direction == Direction.ASCENDING)
				{
					scrollHTo(scroll);
				}
				else
				{
					scrollHTo(1 - scroll);
				}
			}
			else
			{
				
				if (direction == Direction.ASCENDING)
				{
					scrollVTo(scroll);
				}
				else
				{
					scrollVTo(1 - scroll);
				}
			}
		}
		
		private function handleTrackResize(event:Event):void
		{
			if (_slider) _slider.bounds = _track.getBounds(this);
			updateToScrollPane();
		}
		
		private function handleScrollPaneScroll(event:ScrollEvent):void
		{
			if (_blockUpdate) return;
			
			_dontUpdateScrollPane = true;
			scrollHTo(event.scrollH / event.maxScrollH);
			scrollVTo(event.scrollV / event.maxScrollV);
			_dontUpdateScrollPane = false;
		}
		
		private function handleScrollPaneResize(event:Event):void
		{
			updateToScrollPane();
		}
		
		private function handleScrollButtonClick(event:MouseEvent):void
		{
			if (orientation == _slider.orientation)
			{
				switch (event.target)
				{
					case _upButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollUp();
						}
						else
						{
							scrollVTo(scrollV - _stepSize);
						}
						break;
					}
					case _downButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollDown();
						}
						else
						{
							scrollVTo(scrollV + _stepSize);
						}
						break;
					}
					case _leftButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollLeft();
						}
						else
						{
							scrollHTo(scrollH - _stepSize);
						}
						break;
					}
					case _rightButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollRight();
						}
						else
						{
							scrollHTo(scrollH + _stepSize);
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
					case _upButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollLeft();
						}
						else
						{
							scrollHTo(scrollH - _stepSize);
						}
						break;
					}
					case _downButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollRight();
						}
						else
						{
							scrollHTo(scrollH + _stepSize);
						}
						break;
					}
					case _leftButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollUp();
						}
						else
						{
							scrollVTo(scrollV - _stepSize);
						}
						break;
					}
					case _rightButton:
					{
						if (_scrollPane)
						{
							_scrollPane.scrollDown();
						}
						else
						{
							scrollVTo(scrollV + _stepSize);
						}
						break;
					}
				}
			}
		}
		
		protected function handleMouseWheel(event:MouseEvent):void
		{
			if (_mouseWheelEnabled)
			{
				if (orientation == Orientation.VERTICAL)
				{
					scrollVTo(scrollV + (!isNaN(_mouseWheelScrollSpeed) ? _mouseWheelScrollSpeed: _stepSize) * -event.delta);
				}
				else
				{
					scrollHTo(scrollH + (!isNaN(_mouseWheelScrollSpeed) ? _mouseWheelScrollSpeed: _stepSize) * -event.delta);
				}
			}
		}
		
		private function handleActivate(event:Event):void
		{
			removeEventListener(Event.ACTIVATE, handleActivate);
			dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			scrollPane = null;
			button = null;
			track = null;
			upButton = null;
			downButton = null;
			leftButton = null;
			rightButton = null;
			_scrollProxy = null;
			_showProxy = null;
			_trackScrubber = null;
			
			super.destruct();
		}
	}
}