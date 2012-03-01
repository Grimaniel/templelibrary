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
		
		private var _player:IPlayer;
		private var _loadBar:DisplayObject;
		private var _progressBar:DisplayObject;
		private var _progressLabel:ILabel;
		
		public function PlayerProgressBar()
		{
			this.loadBar ||= this.getChildByName(loadBarInstanceName) as DisplayObject;
			this.progressBar ||= this.getChildByName(progressBarInstanceName) as DisplayObject;
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.width = this.contentWidth = this.width;
			this.height = this.contentHeight = this.height;
			
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
			
			new ScrubBehavior(this);
		}

		public function get player():IPlayer
		{
			return this._player;
		}

		public function set player(value:IPlayer):void
		{
			this._player = value;
			if (this.debug) this.logDebug("player: ");
		}

		public function get loadBar():DisplayObject
		{
			return this._loadBar;
		}

		public function set loadBar(value:DisplayObject):void
		{
			this._loadBar = value;
		}

		public function get progressBar():DisplayObject
		{
			return this._progressBar;
		}

		public function set progressBar(value:DisplayObject):void
		{
			this._progressBar = value;
		}
		
		public function get progressLabel():ILabel
		{
			return this._progressLabel;
		}

		public function set progressLabel(value:ILabel):void
		{
			this._progressLabel = value;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this.debug) this.logDebug("handleEnterFrame: ");
			
			if (this._player)
			{
				if (this._progressBar)
				{
					this._progressBar.width = this._player.currentPlayFactor * this.width || .1;
				}
				if (this._loadBar && this._player is IProgressiveDownloadPlayer)
				{
					this._loadBar.width = IProgressiveDownloadPlayer(this._player).bytesLoaded / IProgressiveDownloadPlayer(this._player).bytesTotal * this.width || .1; 
				}
				if (this._progressLabel)
				{
					this._progressLabel.label = TimeUtils.secondsToString(this._player.currentPlayTime);
				}
			}
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (this._player)
			{
				this._player.seek(this._player.duration * (this.mouseX / this.width));
			}
		}
	}
}
