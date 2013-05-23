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

package temple.ui.states 
{
	import temple.data.collections.HashMap;
	import temple.utils.types.MovieClipUtils;

	import flash.display.FrameLabel;

	/**
	 * This class uses a timeline animation to display the state object.
	 * 
	 * <p>The timeline can be used using framelabels or without framelabels</p>
	 * 
	 * <p><strong>With framelabel</strong><br/>
	 * Use 'show' as label to define the show animation. Use 'hide' to define the hide animation.
	 * The animation will automatically stop on the last frame of the animation. DO NOT use frame scripts to stop the animation!!! 
	 * </p>
	 * 
	 * <p><strong>Withoutframelabel</strong><br/>
	 * The first frame of the animation is use as hide, the last frame for show. The timeline animation will be played forward and backwards
	 * to toggle between these states. 
	 * </p>
	 * 
	 * @author Thijs Broerse
	 */
	public class BaseTimelineState extends AbstractState implements IState 
	{
		protected static var _LABEL_SHOW:String = 'show';
		protected static var _LABEL_HIDE:String = 'hide';

		private var _labels:HashMap;

		public function BaseTimelineState()
		{
			// init labels
			this._labels = new HashMap("TimelineState Labels");
			this.currentScene.labels.map(this.addLabelHashEntry);
			this.addFrameScript(this.totalFrames - 1, this.onLastFrame);
			if (this._labels[BaseTimelineState._LABEL_HIDE])
			{
				this.addFrameScript((FrameLabel(this._labels[BaseTimelineState._LABEL_HIDE]).frame - 1), this.stop);
			}
			this.stop();
		}

		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			super.stop();
			MovieClipUtils.stop(this, false);
		}

		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false):void
		{
			if (this.enabled == false || this._shown && !instant) return;
			this._shown = true;
			MovieClipUtils.stop(this);
			
			if (instant)
			{
				if (this._labels[BaseTimelineState._LABEL_HIDE])
				{
					this.gotoAndStop(FrameLabel(this._labels[BaseTimelineState._LABEL_HIDE]).frame - 1);
				}
				else
				{
					this.gotoAndStop(this.totalFrames);
				}
			}
			else
			{
				if (this._labels[BaseTimelineState._LABEL_SHOW])
				{
					this.gotoAndStop(BaseTimelineState._LABEL_SHOW);
				}
				MovieClipUtils.play(this);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false):void
		{
			if (this.enabled == false || !this._shown && !instant) return;
			this._shown = false;
			MovieClipUtils.stop(this);
			
			if (instant)
			{
				if (this._labels[BaseTimelineState._LABEL_HIDE])
				{
					this.gotoAndStop(this.totalFrames);
				}
				else
				{
					this.gotoAndStop(1);
				}
			}
			else
			{
				if (this._labels[BaseTimelineState._LABEL_HIDE])
				{
					this.gotoAndStop(BaseTimelineState._LABEL_HIDE);
					MovieClipUtils.play(this);
				}
				else
				{
					MovieClipUtils.playBackwards(this);
				}
			}
		}
		
		private function addLabelHashEntry(item:FrameLabel, index:int, array:Array):void 
		{
			var frameLabel:FrameLabel = FrameLabel(item);
			this._labels[frameLabel.frame] = frameLabel;
			this._labels[frameLabel.name] = frameLabel;
			
			// Just use vars here, to get rid of 'parameter never used'-warning
			index;
			array;
		}

		private function onLastFrame():void
		{
			MovieClipUtils.stop(this);
			if (this._shown)
			{
				this.show();
			}
		}

		override public function destruct():void
		{
			this._labels = null;
			
			super.destruct();
		}
	}
}