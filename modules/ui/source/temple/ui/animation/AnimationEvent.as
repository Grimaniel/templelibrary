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

package temple.ui.animation 
{
	import flash.events.Event;

	/**
	 * Event class for sending animation related events.
	 * 
	 * @author Thijs Broerse
	 */
	public class AnimationEvent extends Event 
	{
		/** 
		 * Event sent when in animation is started.
		 */
		public static const IN_ANIMATION_STARTED:String = "AnimationEvent.inAnimationStarted";

		/** 
		 * Event sent when in animation is done.
		 */
		public static const IN_ANIMATION_DONE:String = "AnimationEvent.inAnimationDone";

		/**
		 * Event sent when out animation is started.
		 */
		public static const OUT_ANIMATION_STARTED:String = "AnimationEvent.outAnimationStarted";

		/**
		 * Event sent when out animation is done.
		 */
		public static const OUT_ANIMATION_DONE:String = "AnimationEvent.outAnimationDone";

		/**
		 * Event sent when general animation is started.
		 */
		public static const ANIMATION_STARTED:String = "AnimationEvent.animationStarted";

		/**
		 * Event sent when general animation is done.
		 */
		public static const ANIMATION_DONE:String = "AnimationEvent.animationDone";
		
		/**
		 * Event sent when animating
		 */
		public static const ANIMATING:String = "AnimationEvent.animating";

		/**
		 * Creates a new AnimationEvent.
		 * @param subtype either subtype; see above
		 */
		function AnimationEvent(type:String, bubbles:Boolean = true) 
		{
			super(type, bubbles);
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new AnimationEvent(this.type, this.bubbles);
		}
	}
}
