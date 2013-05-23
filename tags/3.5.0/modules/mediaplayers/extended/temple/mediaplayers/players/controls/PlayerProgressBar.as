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

package temple.mediaplayers.players.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import temple.mediaplayers.players.IPlayer;
	import temple.mediaplayers.players.IProgressiveDownloadPlayer;
	import temple.ui.buttons.behaviors.ScrubBehavior;
	import temple.ui.label.ILabel;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.utils.TimeUtils;

	/**
	 * @author Thijs Broerse
	 */
	public class PlayerProgressBar extends LiquidContainer
	{
		/**
		 * Instance name of a child which acts as loadBar.
		 */
		public static var loadBarInstanceName:String = "mcLoadBar";
		
		/**
		 * Instance name of a child which acts as progressBar.
		 */
		public static var progressBarInstanceName:String = "mcProgressBar";
		
		/**
		 * Instance name of a child which acts as knob.
		 */
		public static var knobInstanceName:String = "mcKnob";
		
		/**
		 * Instance name of a child which acts as progressLabel.
		 */
		public static var progressLabelInstanceName:String = "mcProgressLabel";
		
		/**
		 * Instance name of a child which acts as durationLabel.
		 */
		public static var durationLabelInstanceName:String = "mcDurationLabel";

		private var _player:IPlayer;
		private var _loadBar:DisplayObject;
		private var _progressBar:DisplayObject;
		private var _knob:DisplayObject;
		private var _progressLabel:ILabel;
		private var _durationLabel:ILabel;
		
		public function PlayerProgressBar(width:Number = NaN, height:Number = NaN)
		{
			super(width, height);
			
			construct::playerProgressBar(width, height);
		}
		
		/**
		 * @private
		 */
		construct function playerProgressBar(width:Number = NaN, height:Number = NaN):void
		{
			this.loadBar ||= getChildByName(loadBarInstanceName) as DisplayObject;
			this.progressBar ||= getChildByName(progressBarInstanceName) as DisplayObject;
			this.knob ||= getChildByName(knobInstanceName) as DisplayObject;
			this.progressLabel ||= getChildByName(progressLabelInstanceName) as ILabel;
			this.durationLabel ||= getChildByName(durationLabelInstanceName) as ILabel;
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.width = contentWidth = width;
			this.height = contentHeight = height;
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			addEventListener(MouseEvent.CLICK, handleClick);
			
			new ScrubBehavior(this);
			
			toStringProps.push("player");
			
			width;
			height;
		}

		public function get player():IPlayer
		{
			return _player;
		}

		public function set player(value:IPlayer):void
		{
			_player = value;
			if (debug) logDebug("player: ");
		}

		public function get loadBar():DisplayObject
		{
			return _loadBar;
		}

		public function set loadBar(value:DisplayObject):void
		{
			_loadBar = value;
		}

		public function get progressBar():DisplayObject
		{
			return _progressBar;
		}

		public function set progressBar(value:DisplayObject):void
		{
			_progressBar = value;
		}
		
		public function get progressLabel():ILabel
		{
			return _progressLabel;
		}

		public function set progressLabel(value:ILabel):void
		{
			_progressLabel = value;
		}
		
		public function get durationLabel():ILabel
		{
			return _durationLabel;
		}

		public function set durationLabel(value:ILabel):void
		{
			_durationLabel = value;
		}
				
		public function get knob():DisplayObject
		{
			return _knob;
		}

		public function set knob(value:DisplayObject):void
		{
			_knob = value;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (debug) logDebug("handleEnterFrame: ");
			
			if (_player)
			{
				if (_progressBar)
				{
					_progressBar.width = Math.max(_player.currentPlayFactor * this.width, .1);
				}
				if (_loadBar && _player is IProgressiveDownloadPlayer)
				{
					_loadBar.width = IProgressiveDownloadPlayer(_player).bytesLoaded / IProgressiveDownloadPlayer(_player).bytesTotal * this.width || .1;
				}
				else if (_loadBar)
				{
					_loadBar.width = width;
				}
				if (_progressLabel)
				{
					_progressLabel.label = TimeUtils.secondsToString(_player.currentPlayTime);
				}
				if (_durationLabel)
				{
					_durationLabel.label = TimeUtils.secondsToString(_player.duration);
				}
				if (_knob)
				{
					_knob.x = _player.currentPlayFactor * width;
				}
			}
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (_player && enabled)
			{
				_player.seek(_player.duration * (mouseX / width));
			}
		}
	}
}