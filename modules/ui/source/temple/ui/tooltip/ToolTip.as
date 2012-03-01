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

package temple.ui.tooltip 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.utils.CoreTimer;
	import temple.ui.label.LiquidLabel;
	import temple.utils.types.DisplayObjectUtils;

	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * The tooltip is a graphical user interface element. It is used in conjunction with a cursor, usually a pointer.
	 * The user hovers the pointer over an item, without clicking it, and a tooltip may appear—a small "hover box" with
	 * information about the item being hovered over
	 * 
	 * @see http://en.wikipedia.org/wiki/Tooltip
	 * 
	 * @author Thijs Broerse
	 */
	public class ToolTip extends LiquidLabel implements IToolTip
	{
		private static var _clip:IToolTip;
		private static var _offset:Point;
		private static var _showDelayTimer:CoreTimer;
		private static var _hideDelayTimer:CoreTimer;
		private static var _minimumStageMargin:Number;
		private static var _followMouse:Boolean; 
		private static var _debug:Boolean;
		
		private static var _nextMessage:String;
		private static var _nextAlignObject:DisplayObject;
		private static var _nextOffet:Point;
		private static var _messages:Dictionary;

		private static function init():void
		{
			_showDelayTimer = new CoreTimer(0, 1);
			_showDelayTimer.addEventListener(TimerEvent.TIMER, handleShowDelayTimer);
			
			_hideDelayTimer = new CoreTimer(0, 1);
			_hideDelayTimer.addEventListener(TimerEvent.TIMER, handleHideDelayTimer);
		}
		
		init();

		/**
		 * Set the clip that is as ToolTip. Clip must be set before ToolTip can be used.
		 */
		public static function get clip():IToolTip
		{
			return ToolTip._clip;
		}
		
		/**
		 * @private
		 */
		public static function set clip(value:IToolTip):void
		{
			ToolTip._clip = value;
		}
		
		/**
		 * The default offset for the ToolTip
		 */
		public static function get offset():Point
		{
			return ToolTip._offset;
		}
		
		/**
		 * @private
		 */
		public static function set offset(value:Point):void
		{
			 ToolTip._offset = value;
		}
		
		/**
		 * Delay in milliseconds before the ToolTip is shown
		 */
		public static function get showDelay():Number
		{
			return ToolTip._showDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public static function set showDelay(value:Number):void
		{
			ToolTip._showDelayTimer.delay = value;
		}
		
		/**
		 * Delay in milliseconds before the ToolTip is hidden
		 */
		public static function get hideDelay():Number
		{
			return ToolTip._hideDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public static function set hideDelay(value:Number):void
		{
			ToolTip._hideDelayTimer.delay = value;
		}
		
		/**
		 * Debug
		 */
		public static function get debug():Boolean
		{
			return ToolTip._debug;
		}
		
		/**
		 * @private
		 */
		public static function set debug(debug:Boolean):void
		{
			ToolTip._debug = debug;
		}
		
		/**
		 * Show the ToolTip with the specific message
		 * @param message the message to be shown
		 * @param alignObject the DisplayObject that is used to align the ToolTip. If null mouse position is used
		 * @param offset the offset (x and y) that is used to position the ToolTip according to the alignObject. If null the default is used
		 */
		public static function show(message:String, alignObject:DisplayObject = null, offset:Point = null):void
		{
			if (ToolTip._debug) Log.debug("show: " + message, ToolTip);
			
			ToolTip._nextMessage = message;
			ToolTip._nextAlignObject = alignObject;
			ToolTip._nextOffet = offset;
			
			ToolTip._showDelayTimer.reset();
			ToolTip._showDelayTimer.start();
		}
		
		/**
		 * Hides the ToolTip
		 */
		public static function hide():void
		{
			if (ToolTip._debug) Log.debug("hide", ToolTip);
			
			ToolTip._showDelayTimer.reset();
			ToolTip._hideDelayTimer.reset();
			ToolTip._hideDelayTimer.start();
		}

		/**
		 * Add a ToolTip message to a DisplayObject. The ToolTip will show when the user mouse over the object.
		 */
		public static function add(displayObject:DisplayObject, message:String, offset:Point = null):void 
		{
			if (!ToolTip._messages) ToolTip._messages = new Dictionary(true);
			
			ToolTip._messages[displayObject] = new ToolTipData(message, offset);
			
			displayObject.addEventListener(MouseEvent.ROLL_OVER, ToolTip.handleRollOver, false, 0, true);
			displayObject.addEventListener(MouseEvent.ROLL_OUT, ToolTip.handleRollOut, false, 0, true);
		}

		/**
		 * Removes the ToolTip of a DisplayObject
		 */
		public static function remove(displayObject:DisplayObject):void 
		{
			if (ToolTip._messages && displayObject in ToolTip._messages)
			{
				ToolTipData(ToolTip._messages[displayObject]).destruct();
				delete ToolTip._messages[displayObject];
			}
			displayObject.removeEventListener(MouseEvent.ROLL_OVER, ToolTip.handleRollOver);
			displayObject.removeEventListener(MouseEvent.ROLL_OUT, ToolTip.handleRollOut);
		}

		
		/**
		 * Mimimal distance between ToolTip and border of the stage.
		 */
		public static function get minimumStageMargin():Number
		{
			return ToolTip._minimumStageMargin;
		}
		
		/**
		 * @private
		 */
		public static function set minimumStageMargin(value:Number):void
		{
			ToolTip._minimumStageMargin = value;
		}
		
		/**
		 * Indicates if the ToolTip should follow the mouse.
		 */
		public static function get followMouse():Boolean
		{
			return ToolTip._followMouse;
		}
		
		/**
		 * @private
		 */
		public static function set followMouse(value:Boolean):void
		{
			ToolTip._followMouse = value;
		}

		private static function handleRollOver(event:MouseEvent):void 
		{
			var data:ToolTipData = ToolTip._messages[event.target] as ToolTipData;
			
			if (data)
			{
				ToolTip.show(data.message, data.offset ? event.target as DisplayObject : null, data.offset);
				
				if (event.type == MouseEvent.ROLL_OVER && ToolTip._followMouse)
				{
					IEventDispatcher(event.target).addEventListener(MouseEvent.MOUSE_MOVE, handleRollOver, false, 0, true);
				}
			}
		}

		private static function handleRollOut(event:MouseEvent):void 
		{
			ToolTip.hide();
			IEventDispatcher(event.target).removeEventListener(MouseEvent.MOUSE_MOVE, handleRollOver);
		}

		private static function handleShowDelayTimer(event:TimerEvent):void
		{
			if (ToolTip._debug) Log.debug("handleShowDelayTimer", ToolTip);
			
			ToolTip._hideDelayTimer.reset();
			
			if (ToolTip._clip == null)
			{
				Log.error("No ToolTip defined, message = '" + ToolTip._nextMessage + "'", ToolTip);
			}
			else
			{
				ToolTip._clip.label = ToolTip._nextMessage;
				ToolTip._clip.show();
				
				if (ToolTip._clip.parent == null)
				{
					Log.warn("ToolTip has no parent, so ToolTips position can not be set", ToolTip);
				}
				else
				{
					if (ToolTip._nextAlignObject)
					{
						ToolTip._clip.position = DisplayObjectUtils.localToLocal(new Point(0,0), ToolTip._nextAlignObject, ToolTip._clip.parent);
					}
					else
					{
						ToolTip._clip.x = ToolTip._clip.parent.mouseX;
						ToolTip._clip.y = ToolTip._clip.parent.mouseY;
					}
					var offset:Point = ToolTip._nextOffet;
					
					if (offset == null) offset = ToolTip._offset;
					
					if (offset)
					{
						ToolTip._clip.x += offset.x;
						ToolTip._clip.y += offset.y;
					}
					
					if (!isNaN(ToolTip._minimumStageMargin))
					{
						offset = new Point();
						
						// keep in stage view
						var rect:Rectangle = ToolTip._clip.getBounds(ToolTip._clip.stage);
						if (rect.right > ToolTip._clip.stage.stageWidth)
						{
							offset.x = rect.right - ToolTip._clip.stage.stageWidth + ToolTip._minimumStageMargin;
						}
						else if (rect.left < 0)
						{
							offset.x = rect.left - ToolTip._minimumStageMargin;
						}
						
						if (rect.top < 0)
						{
							offset.y = rect.top - ToolTip._minimumStageMargin;
						}
						else if (rect.bottom > ToolTip._clip.stage.stageHeight)
						{
							offset.y = rect.bottom - ToolTip._clip.stage.stageHeight + ToolTip._minimumStageMargin;
						}
						
						ToolTip._clip.x -= offset.x;
						ToolTip._clip.y -= offset.y;
						ToolTip._clip.setStageMarginOffset(offset);
					}
				}
			}
		}
		
		private static function handleHideDelayTimer(event:TimerEvent):void
		{
			if (ToolTip._debug) Log.debug("handleHideDelayTimer", ToolTip);
			
			if (ToolTip._clip) ToolTip._clip.hide();
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(ToolTip);
		}
		
		private var _arrow:DisplayObject;
		private var _originalArrowPosition:Point;
		
		/**
		 * 
		 */
		public function ToolTip()
		{
			this.mouseChildren = this.mouseEnabled = false;
			this.visible = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function show(instant:Boolean = false):void
		{
			this.visible = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hide(instant:Boolean = false):void
		{
			this.visible = false;
		}

		/**
		 * @inheritDoc
		 */
		public function get shown():Boolean
		{
			return this.visible;
		}

		/**
		 * @inheritDoc
		 */
		public function set shown(value:Boolean):void
		{
			this.visible = value;
		}

		/**
		 * @inheritDoc
		 */
		public function setStageMarginOffset(offset:Point):void
		{
			if (this._arrow && this._originalArrowPosition)
			{
				this._arrow.x = this._originalArrowPosition.x + offset.x;
				this._arrow.y = this._originalArrowPosition.y + offset.y;
			}
		}

		/**
		 * An optional Arrow for the ToolTip
		 */
		public function get arrow():DisplayObject
		{
			return this._arrow;
		}

		/**
		 * @private
		 */
		public function set arrow(value:DisplayObject):void
		{
			this._arrow = value;
			this._originalArrowPosition = new Point(this._arrow.x, this._arrow.y);
		}
	}
}
import temple.core.CoreObject;

import flash.geom.Point;

final class ToolTipData extends CoreObject
{
	public var message:String;
	public var offset:Point;

	public function ToolTipData(message:String, offset:Point)
	{
		this.message = message;
		this.offset = offset;
		
		this.toStringProps.push('message', 'offset');
	}

	override public function destruct():void
	{
		this.message = null;
		this.offset = null;
		
		super.destruct();
	}
}
