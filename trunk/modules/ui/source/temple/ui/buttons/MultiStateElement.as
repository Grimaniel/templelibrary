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

package temple.ui.buttons 
{
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreMovieClip;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelinePlayMode;

	/**
	 * A MultiStateElement can be used inside a <code>MultiStateButton</code>. Is will automatically respond to the
	 * state of the <code>MultiStateButton</code> and will show the same state.
	 * 
	 * <p>A MultiStateElement can be nested inside objects which has a <code>ButtonBehavior</code>. Nesting means that
	 * it is placed on the timeline of an object. But also on the timeline of a child or grand-child of the object.
	 * There can be an unlimited amount of sub-children between the object and the MultiStateElement.</p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiStateElement extends CoreMovieClip implements IDebuggable
	{
		private var _timelineBehavior:ButtonTimelineBehavior;
		private var _stateBehavior:ButtonStateBehavior;
		private var _debug:Boolean;

		public function MultiStateElement()
		{
			super();
			
			this.stop();
			
			if (this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
			this._stateBehavior = new ButtonStateBehavior(this);
		}
		
		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonTimelineBehavior():ButtonTimelineBehavior
		{
			return this._timelineBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonStateBehavior():ButtonStateBehavior
		{
			return this._stateBehavior;
		}

		/**
		 * Define how the timeline should be played when the ButtonTimelineBehavior must go to an other label.
		 * More specific playModes for every state can be set on the buttonTimelineBehavior 
		 * 
		 * @see temple.ui.buttons.behaviors.ButtonTimelinePlayMode
		 * @see temple.ui.buttons.behaviors.ButtonTimelineBehavior
		 */
		public function get playMode():ButtonTimelinePlayMode
		{
			return this._timelineBehavior ? this._timelineBehavior.playMode : null;
		}

		/**
		 * @private
		 */
		[Inspectable(name="PlayMode", type="String", defaultValue="reversed", enumeration="reversed,continue,immediately")]
		public function set playMode(value:*):void
		{
			if (this._timelineBehavior) this._timelineBehavior.playMode = value;
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
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			if (this._timelineBehavior) this._timelineBehavior.debug = value;
			if (this._stateBehavior) this._stateBehavior.debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._timelineBehavior = null;
			this._stateBehavior = null;
			
			super.destruct();
		}
	}
}
