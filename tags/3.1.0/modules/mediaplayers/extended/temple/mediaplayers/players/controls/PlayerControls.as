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
	import flash.display.InteractiveObject;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.common.interfaces.ISelectable;
	import temple.core.debug.IDebuggable;
	import temple.core.utils.CoreTimer;
	import temple.mediaplayers.players.IPlayer;
	import temple.mediaplayers.players.PlayerStatus;
	import temple.ui.states.BaseFadeState;

	/**
	 * @author Thijs Broerse
	 */
	public class PlayerControls extends BaseFadeState implements IPlayer, IDebuggable, IAudible
	{
		/**
		 * Instance name of a child which acts as playButton.
		 */
		public static var playButtonInstanceName:String = "mcPlayButton";

		/**
		 * Instance name of a child which acts as pauseButton.
		 */
		public static var pauseButtonInstanceName:String = "mcPauseButton";
		
		/**
		 * Instance name of a child which acts as resumeButton.
		 */
		public static var resumeButtonInstanceName:String = "mcResumeButton";

		/**
		 * Instance name of a child which acts as muteButton.
		 */
		public static var muteButtonInstanceName:String = "mcMuteButton";

		/**
		 * Instance name of a child which acts as fullscreenButton.
		 */
		public static var fullScreenButtonInstanceName:String = "mcFullScreenButton";

		/**
		 * Instance name of a child which acts as progressBar.
		 */
		public static var progressBarInstanceName:String = "mcProgressBar";
		
		private var _player:IPlayer;
		private var _playButton:InteractiveObject;
		private var _pauseButton:InteractiveObject;
		private var _resumeButton:InteractiveObject;
		private var _muteButton:InteractiveObject;
		private var _fullScreenButton:InteractiveObject;
		private var _progressBar:PlayerProgressBar;
		private var _toggleResumePauseButtonsVisibility:Boolean;
		private var _autoHide:Boolean;
		private var _autoHideTimer:CoreTimer;
		private var _debug:Boolean;
		
		public function PlayerControls()
		{
			construct::playerControls();
		}

		construct function playerControls():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
			
			this.playButton ||= this.getChildByName(playButtonInstanceName) as InteractiveObject;
			this.pauseButton ||= this.getChildByName(pauseButtonInstanceName) as InteractiveObject;
			this.resumeButton ||= this.getChildByName(resumeButtonInstanceName) as InteractiveObject;
			this.muteButton ||= this.getChildByName(PlayerControls.muteButtonInstanceName) as InteractiveObject;
			this.fullScreenButton ||= this.getChildByName(PlayerControls.fullScreenButtonInstanceName) as InteractiveObject;
			this.progressBar ||= this.getChildByName(PlayerControls.progressBarInstanceName) as PlayerProgressBar;
			
			this._autoHideTimer = new CoreTimer(1000);
			this._autoHideTimer.addEventListener(TimerEvent.TIMER, this.handleAutoHideTimerEvent);
			this.show(true);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
		}

		/**
		 * @inheritDoc
		 */
		override public function play():void
		{
			if (this.debug) this.logDebug("play: ");
			if (this._player) this._player.play();
		}

		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			if (this.debug) this.logDebug("stop: ");
			if (this._player) this._player.stop();
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (this.debug) this.logDebug("seek: " + seconds);
			if (this._player) this._player.seek(seconds);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return this._player ? this._player.currentPlayTime : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._player ? this._player.duration : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return this._player ? this._player.currentPlayFactor : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._player ? this._player.autoRewind : false;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			if (this.debug) this.logDebug("autoRewind: " + value);
			if (this._player) this._player.autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (this.debug) this.logDebug("pause: ");
			if (this._player) this._player.pause();
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (this.debug) this.logDebug("resume: ");
			if (this._player) this._player.resume();
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._player ? this._player.paused : false;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this._player ? this._player.status : null;
		}
		
		public function get player():IPlayer
		{
			return this._player;
		}

		public function set player(value:IPlayer):void
		{
			if (this.debug) this.logDebug("player: " + value);
			if (this._player)
			{
				this._player.removeEventListener(StatusEvent.STATUS_CHANGE, this.handlePlayerStatusChange);
				this._player.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
				this._player.removeEventListener(MouseEvent.ROLL_OUT, this.handlePlayerRollOut);
				this._player.removeEventListener(SoundEvent.VOLUME_CHANGE, this.handlePlayerVolumeChanged);
			}
			this._player = value;
			if (this._progressBar) this._progressBar.player = this._player;
			if (this._player)
			{
				this._player.addEventListener(StatusEvent.STATUS_CHANGE, this.handlePlayerStatusChange);
				this._player.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
				this._player.addEventListener(MouseEvent.ROLL_OUT, this.handlePlayerRollOut);
				this._player.addEventListener(SoundEvent.VOLUME_CHANGE, this.handlePlayerVolumeChanged);
				this.updateToStatus(this._player.status);
			}
		}

		public function get playButton():InteractiveObject
		{
			return this._playButton;
		}

		public function set playButton(value:InteractiveObject):void
		{
			if (this._playButton) this._playButton.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this._playButton = value;
			if (this._playButton) this._playButton.addEventListener(MouseEvent.CLICK, this.handleClick);
		}

		public function get pauseButton():InteractiveObject
		{
			return this._pauseButton;
		}

		public function set pauseButton(value:InteractiveObject):void
		{
			if (this._pauseButton) this._pauseButton.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this._pauseButton = value;
			if (this._pauseButton) this._pauseButton.addEventListener(MouseEvent.CLICK, this.handleClick);
			if (this._player) this.updateToStatus(this._player.status);
		}

		public function get resumeButton():InteractiveObject
		{
			return this._resumeButton;
		}

		public function set resumeButton(value:InteractiveObject):void
		{
			if (this._resumeButton) this._resumeButton.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this._resumeButton = value;
			if (this._resumeButton) this._resumeButton.addEventListener(MouseEvent.CLICK, this.handleClick);
			if (this._player) this.updateToStatus(this._player.status);
		}
		
		public function get muteButton():InteractiveObject
		{
			return this._muteButton;
		}

		public function set muteButton(value:InteractiveObject):void
		{
			if (this._muteButton) this._muteButton.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this._muteButton = value;
			if (this._muteButton)
			{
				this._muteButton.addEventListener(MouseEvent.CLICK, this.handleClick);
				if (this._muteButton is ISelectable && this._player is IAudible)
				{
					ISelectable(this._muteButton).selected = !IAudible(this._player).volume;
				}
			}
		}

		public function get fullScreenButton():InteractiveObject
		{
			return this._fullScreenButton;
		}

		public function set fullScreenButton(value:InteractiveObject):void
		{
			if (this._fullScreenButton) this._fullScreenButton.removeEventListener(MouseEvent.CLICK, this.handleClick);
			this._fullScreenButton = value;
			if (this._fullScreenButton) this._fullScreenButton.addEventListener(MouseEvent.CLICK, this.handleClick);
		}
		
		public function get progressBar() : PlayerProgressBar
		{
			return this._progressBar;
		}
		
		public function set progressBar(value:PlayerProgressBar):void
		{
			this._progressBar = value;
			if (this._progressBar) this._progressBar.player = this._player;
		}
		
		public function get toggleResumePauseButtonsVisibility():Boolean
		{
			return this._toggleResumePauseButtonsVisibility;
		}

		public function set toggleResumePauseButtonsVisibility(value:Boolean):void
		{
			this._toggleResumePauseButtonsVisibility = value;
			if (this._player) this.updateToStatus(this._player.status);
		}
		
		override public function show(instant:Boolean = false):void
		{
			super.show(instant);
			this._autoHideTimer.reset();
			if (this._autoHide && this.enabled) this._autoHideTimer.start();
		}
		
		override public function hide(instant:Boolean = false):void
		{
			super.hide(instant);
			if (this._autoHideTimer) this._autoHideTimer.reset();
		}
		
		public function get autoHide():Boolean
		{
			return this._autoHide;
		}

		public function set autoHide(value:Boolean):void
		{
			this._autoHide = value;
			if (this._autoHide) this.hide(true);
		}
		
		public function get autoHideDelay():Number
		{
			return this._autoHideTimer.delay;
		}

		public function set autoHideDelay(value:Number):void
		{
			this._autoHideTimer.delay = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this._player is IAudible ? IAudible(this._player).volume : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			if (this._player is IAudible)
			{
				var audible:IAudible = this._player as IAudible;
				audible.volume = value;
				if (this._muteButton is ISelectable)
				{
					ISelectable(this._muteButton).selected = !audible.volume;
				}
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = super.enabled = value;
			if (this._progressBar) this._progressBar.enabled = value;
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

		private function handleClick(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleClick: " + event.target);
			
			switch (event.target)
			{
				case this._playButton:
					this.play();
					break;
				case this._pauseButton:
					this.pause();
					break;
				case this._resumeButton:
					if (this.status == PlayerStatus.STOPPED)
					{
						this.play();
					}
					else
					{
						this.resume();
					}
					break;
				case this._muteButton:
					this.volume = this.volume ? 0 : 1;
					break;
				case this._fullScreenButton:
					if (this.stage)
					{
						this.stage.displayState = this.stage.displayState == StageDisplayState.NORMAL ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
					}
					break;
			}
		}
		
		private function handlePlayerStatusChange(event:StatusEvent):void
		{
			this.updateToStatus(this.status);
			this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this.status));
		}

		private function updateToStatus(status:String):void
		{
			if (this._toggleResumePauseButtonsVisibility)
			{
				if (this._pauseButton) this._pauseButton.visible = status == PlayerStatus.PLAYING;
				if (this._resumeButton) this._resumeButton.visible = status != PlayerStatus.PLAYING;
			}
		}
		
		private function handleAutoHideTimerEvent(event:TimerEvent):void
		{
			if (this._autoHide && this.enabled) this.hide();
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if (this._autoHide && this.enabled && !this.shown) this.show();
		}
		
		private function handlePlayerRollOut(event:MouseEvent):void
		{
			if (this._autoHide && this.shown) this.hide();
		}
		
		private function handlePlayerVolumeChanged(event:SoundEvent):void
		{
			if (this._muteButton is ISelectable && this._player is IAudible) (this._muteButton as ISelectable).selected = !(this._player as IAudible).volume;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.player = null;
			this.playButton = null;
			this.pauseButton = null;
			this.resumeButton = null;
			this.muteButton = null;
			this.progressBar = null;
			
			if (this._autoHideTimer)
			{
				this._autoHideTimer.destruct();
				this._autoHideTimer = null;
			}
			
			super.destruct();
		}
	}
}
