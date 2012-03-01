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
