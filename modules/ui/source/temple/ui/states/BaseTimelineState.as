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
