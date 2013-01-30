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

package temple.core.behaviors 
{
	import flash.events.IEventDispatcher;
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.templelibrary;

	/**
	 * Abstract implementation of a Behavior. This class is used as super class 
	 * for other Behaviors.
	 * 
	 * <p>This class will never be instantiated directly but will always be derived. 
	 * So therefore this class is an 'Abstract' class.</p>
	 * 
	 * <p>This class watches his target. When the target is destructed, the behavior 
	 * will also be destructed (auto destruction). Since this class is useless 
	 * without its target</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehavior extends CoreEventDispatcher implements IBehavior 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.4.0";
		
		private var _target:Object;
		
		/**
		 * Creates a new AbstractBehavior
		 * @param target The target of this behavior, preferable an IEventDispatcher so the behavior will be destructed when the target is destructed.
		 */
		public function AbstractBehavior(target:Object)
		{
			construct::abstractBehavior(target);
		}

		construct function abstractBehavior(target:Object):void
		{
			if (target == null) throwError(new TempleArgumentError(this, "target cannot be null"));
			toStringProps.push('target');
			_target = target;
			if (_target is IEventDispatcher)
			{
				(_target as IEventDispatcher).addEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);
			}
			else
			{
				logWarn("This object is not an IEventDispatcher, so it will not be auto-destructed");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get target():Object
		{
			return _target;
		}
		
		private function handleTargetDestructed(event:DestructEvent):void
		{
			destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_target)
			{
				if (_target is IEventDispatcher) (_target as IEventDispatcher).removeEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);
				// Store target as String, so we do not have the real reverence anymore, but we can still see what is was.
				_target = String(_target);
			}
			super.destruct();
		}
	}
}
