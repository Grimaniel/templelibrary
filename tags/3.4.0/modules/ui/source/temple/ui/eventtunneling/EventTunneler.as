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
			
			_eventType = eventType;
			
			target.addEventListener(_eventType, handleTunnelEvent);
		}
		
		/**
		 * Returns a reference to the Sprite. Same value as target, but typed as Sprite
		 */
		public function get sprite():Sprite
		{
			return target as Sprite;
		}
		
		/**
		 * The type of TunnelEvent that must be tunnelled
		 */
		public function get eventType():String
		{
			return _eventType;
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

		private function handleTunnelEvent(event:Event):void
		{
			if (event is TunnelingEvent)
			{
				if ((event as TunnelingEvent).tunnels && (event as TunnelingEvent).tunnelTarget == target)
				{
					if (_debug) logDebug("Tunnel Event '" + event.type + "'");
					dispatchOnChildren(sprite, TunnelingEvent(event));
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
						dispatchOnChildren(child as Sprite, event);
					}
				}
			}
		}
	}
}
