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
	import flash.events.Event;

	/**
	 * A TunnelEvent is the opposite of a bubbling Event.
	 * If a TunnelEvent is dispatched on a DisplayObjectContainer the event will also be dispatched on all his children (and grandchildren etc.)
	 * 
	 * The actual tunning (dispatching) of the event is done by the EventTunneler. In order to make Event tunneling work you need to create
	 * an EventTunneler for the object.
	 * 
	 * @see temple.ui.eventtunneling.EventTunneler
	 * 
	 * @includeExample ../buttons/behaviors/NestedMultiStateButtonsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class TunnelingEvent extends Event 
	{
		internal var _tunnelTarget:Object;
		private var _tunnels:Boolean;
		
		public function TunnelingEvent(type:String, tunnels:Boolean = true)
		{
			super(type, false);
			
			this._tunnels = tunnels;
		}

		/**
		 * A Boolean which indicates if this event will be tunneled.
		 */
		public function get tunnels():Boolean
		{
			return this._tunnels;
		}

		/**
		 * @inheritDoc
		 * 
		 * Stops tunneling of the event.
		 */
		override public function stopPropagation():void
		{
			this.stopTunneling();
		}

		/**
		 * @inheritDoc
		 * 
		 * Stops tunneling of the event.
		 */
		override public function stopImmediatePropagation():void
		{
			this.stopTunneling();
		}

		/**
		 * Stops tunneling of the event.
		 */
		public function stopTunneling():void
		{
			this._tunnels = false;
		}
		
		/**
		 * get the original target of the tunneling.
		 */
		public function get tunnelTarget():Object
		{
			return this._tunnelTarget != null ? this._tunnelTarget : this.target;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new TunnelingEvent(this.type, this.tunnels);
		}
	}
}
