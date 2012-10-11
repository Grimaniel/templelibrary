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

package temple.ui.behaviors 
{
	import temple.core.behaviors.AbstractBehavior;

	import flash.display.DisplayObject;
	import flash.events.Event;


	/**
	 * Abstract base class for all Behaviors designed for DisplayObjects.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractDisplayObjectBehavior extends AbstractBehavior 
	{
		private var _destructOnRemove:Boolean;
		
		public function AbstractDisplayObjectBehavior(target:DisplayObject, destructOnRemove:Boolean = false)
		{
			super(target);
			
			construct::abstractDisplayObjectBehavior(target, destructOnRemove);
		}
		
		construct function abstractDisplayObjectBehavior(target:Object, destructOnRemove:Boolean):void
		{
			this.destructOnRemove = destructOnRemove;
			target;
		}
		
		/**
		 * Returns a reference to the DisplayObject. Same value as target, but typed as DisplayObject.
		 */
		public function get displayObject():DisplayObject
		{
			return this.target as DisplayObject;
		}

		/**
		 * A Boolean which indicates if this behavior should be destructed when the target is removed from stage.
		 */
		public function get destructOnRemove():Boolean
		{
			return this._destructOnRemove;
		}

		/**
		 * @private
		 */
		public function set destructOnRemove(value:Boolean):void
		{
			this._destructOnRemove = value;
			
			if (this._destructOnRemove)
			{
				this.displayObject.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, int.MIN_VALUE);
			}
			else
			{
				this.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			}
		}

		private function handleRemovedFromStage(event:Event):void
		{
			this.destruct();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.displayObject) this.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
			super.destruct();
		}

	}
}