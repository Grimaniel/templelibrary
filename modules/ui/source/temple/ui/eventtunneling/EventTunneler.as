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

package temple.ui.eventtunneling 
{
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * An EventTunneler will automatically dispatch TunnelEvents on all children (and grandchildren) of a Sprite if there
	 * is a TunnelEvent dispatched on the Sprite.
	 * 
	 * @includeExample ../buttons/behaviors/NestedMultiStateButtonsExample.as
	 * 
	 * @see temple.ui.eventtunneling.TunnelingEvent
	 * 
	 * @author Thijs Broerse
	 */
	public class EventTunneler extends AbstractDisplayObjectBehavior implements IDebuggable
	{
		private var _eventType:String;
		private var _debug:Boolean;

		public function EventTunneler(target:Sprite, eventType:String)
		{
			super(target);
			
			this._eventType = eventType;
			
			target.addEventListener(this._eventType, this.handleTunnelEvent);
		}
		
		/**
		 * Returns a reference to the Sprite. Same value as target, but typed as Sprite
		 */
		public function get sprite():Sprite
		{
			return this.target as Sprite;
		}
		
		/**
		 * The type of TunnelEvent that must be tunnelled
		 */
		public function get eventType():String
		{
			return this._eventType;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		private function handleTunnelEvent(event:Event):void
		{
			if (event is TunnelingEvent)
			{
				if ((event as TunnelingEvent).tunnels && (event as TunnelingEvent).tunnelTarget == this.target)
				{
					if (this._debug) this.logDebug("Tunnel Event '" + event.type + "'");
					this.dispatchOnChildren(this.sprite, TunnelingEvent(event));
				}
			}
			else
			{
				throwError(new TempleArgumentError(this, "EventTunneler can only handle TunnelEvents"));
			}
		}

		private function dispatchOnChildren(parent:Sprite, event:TunnelingEvent):void
		{
			var child:DisplayObject;
			var leni:int = parent.numChildren;
			var e:TunnelingEvent;
			for (var i:int = 0; i < leni; i++)
			{
				child = parent.getChildAt(i);
				if (child)
				{
					e = event.clone() as TunnelingEvent;
					e._tunnelTarget = event.tunnelTarget;
					child.dispatchEvent(e);
					if (e.tunnels && child is Sprite)
					{
						this.dispatchOnChildren(child as Sprite, event);
					}
				}
			}
		}
	}
}
