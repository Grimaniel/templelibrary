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

package temple.core.destruction 
{
	import temple.core.CoreObject;
	import temple.core.templelibrary;

	import flash.utils.Dictionary;

	/**
	 * The DestructController us used to destruct multiple objects at once.
	 * 
	 * <p>Add objects to the DestructController, call destructAll() to destruct all objects.
	 * Objects are stored using a weak-reference, so the DestructController will not block
	 * objects for garbage collection.</p>
	 * 
	 * @author Bart van der Schoor, Thijs Broerse
	 */
	public class DestructController extends CoreObject
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.1";
		
		protected static var _instance:DestructController;

		private var _list:Dictionary;
		private var _debug:Boolean = false;

		/**
		 * Creates a new DestructController
		 */
		public function DestructController()
		{
			this._list = new Dictionary(true);
		}

		/**
		 * Add an object to the DestructController for later destruction.
		 */
		public function add(object:Object):void
		{
			this._list[object] = true;
			if (this._debug) this.logDebug("Add " + object);
		}

		/**
		 * Destruct all objects of the DestructController
		 */
		public function destructAll():void
		{
			for (var object:Object in this._list) 
			{
				if (this._debug) this.logDebug("Destruct " + object);
				Destructor.destruct(object);
				delete this._list[object];
			}
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

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._list)
			{
				this.destructAll();
				this._list = null;
			}
			super.destruct();
		}
	}
}
