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
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.common.interfaces.ISelectable;
	import temple.common.interfaces.IShowable;
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreSprite;
	import temple.core.utils.CoreTimer;
	import temple.mediaplayers.players.IPlayer;
	import temple.mediaplayers.players.PlayerStatus;

	import com.greensock.TweenLite;

	import flash.display.InteractiveObject;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	/**
	 * @author Thijs Broerse
	 */
	public class PlayerControls extends CoreSprite implements IPlayer, IDebuggable, IAudible, IShowable
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
		private var _shown:Boolean;
		private var _enabled:Boolean;
		private var _debug:Boolean;
		
		public function PlayerControls()
		{
			construct::playerControls();
		}

		construct function playerControls():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			playButton ||= getChildByName(playButtonInstanceName) as InteractiveObject;
			pauseButton ||= getChildByName(pauseButtonInstanceName) as InteractiveObject;
			resumeButton ||= getChildByName(resumeButtonInstanceName) as InteractiveObject;
			muteButton ||= getChildByName(PlayerControls.muteButtonInstanceName) as InteractiveObject;
			fullScreenButton ||= getChildByName(PlayerControls.fullScreenButtonInstanceName) as InteractiveObject;
			progressBar ||= getChildByName(PlayerControls.progressBarInstanceName) as PlayerProgressBar;
			
			_autoHideTimer = new CoreTimer(1000);
			_autoHideTimer.addEventListener(TimerEvent.TIMER, handleAutoHideTimerEvent);
			show(true);
			
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get shown():Boolean
		{
			return _shown;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set shown(value:Boolean):void
		{
			if (value)
			{
				show();
			}
			else
			{
				hide();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			enabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return _player && _player.isPlaying;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (debug) logDebug("play: ");
			if (_player) _player.play();
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (debug) logDebug("stop: ");
			if (_player) _player.stop();
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (debug) logDebug("seek: " + seconds);
			if (_player) _player.seek(seconds);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return _player ? _player.currentPlayTime : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _player ? _player.duration : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return _player ? _player.currentPlayFactor : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return _player ? _player.autoRewind : false;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			if (debug) logDebug("autoRewind: " + value);
			if (_player) _player.autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (debug) logDebug("pause: ");
			if (_player) _player.pause();
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (debug) logDebug("resume: ");
			if (_player) _player.resume();
		}

		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return _player ? _player.isPaused : false;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return _player ? _player.status : null;
		}
		
		public function get player():IPlayer
		{
			return _player;
		}

		public function set player(value:IPlayer):void
		{
			if (debug) logDebug("player: " + value);
			if (_player)
			{
				_player.removeEventListener(StatusEvent.STATUS_CHANGE, handlePlayerStatusChange);
				_player.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				_player.removeEventListener(MouseEvent.ROLL_OUT, handlePlayerRollOut);
				_player.removeEventListener(SoundEvent.VOLUME_CHANGE, handlePlayerVolumeChanged);
			}
			_player = value;
			if (_progressBar) _progressBar.player = _player;
			if (_player)
			{
				_player.addEventListener(StatusEvent.STATUS_CHANGE, handlePlayerStatusChange);
				_player.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				_player.addEventListener(MouseEvent.ROLL_OUT, handlePlayerRollOut);
				_player.addEventListener(SoundEvent.VOLUME_CHANGE, handlePlayerVolumeChanged);
				updateToStatus(_player.status);
			}
		}

		public function get playButton():InteractiveObject
		{
			return _playButton;
		}

		public function set playButton(value:InteractiveObject):void
		{
			if (_playButton) _playButton.removeEventListener(MouseEvent.CLICK, handleClick);
			_playButton = value;
			if (_playButton) _playButton.addEventListener(MouseEvent.CLICK, handleClick);
		}

		public function get pauseButton():InteractiveObject
		{
			return _pauseButton;
		}

		public function set pauseButton(value:InteractiveObject):void
		{
			if (_pauseButton) _pauseButton.removeEventListener(MouseEvent.CLICK, handleClick);
			_pauseButton = value;
			if (_pauseButton) _pauseButton.addEventListener(MouseEvent.CLICK, handleClick);
			if (_player) updateToStatus(_player.status);
		}

		public function get resumeButton():InteractiveObject
		{
			return _resumeButton;
		}

		public function set resumeButton(value:InteractiveObject):void
		{
			if (_resumeButton) _resumeButton.removeEventListener(MouseEvent.CLICK, handleClick);
			_resumeButton = value;
			if (_resumeButton) _resumeButton.addEventListener(MouseEvent.CLICK, handleClick);
			if (_player) updateToStatus(_player.status);
		}
		
		public function get muteButton():InteractiveObject
		{
			return _muteButton;
		}

		public function set muteButton(value:InteractiveObject):void
		{
			if (_muteButton) _muteButton.removeEventListener(MouseEvent.CLICK, handleClick);
			_muteButton = value;
			if (_muteButton)
			{
				_muteButton.addEventListener(MouseEvent.CLICK, handleClick);
				if (_muteButton is ISelectable && _player is IAudible)
				{
					ISelectable(_muteButton).selected = !IAudible(_player).volume;
				}
			}
		}

		public function get fullScreenButton():InteractiveObject
		{
			return _fullScreenButton;
		}

		public function set fullScreenButton(value:InteractiveObject):void
		{
			if (_fullScreenButton) _fullScreenButton.removeEventListener(MouseEvent.CLICK, handleClick);
			_fullScreenButton = value;
			if (_fullScreenButton) _fullScreenButton.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		public function get progressBar() : PlayerProgressBar
		{
			return _progressBar;
		}
		
		public function set progressBar(value:PlayerProgressBar):void
		{
			_progressBar = value;
			if (_progressBar) _progressBar.player = _player;
		}
		
		public function get toggleResumePauseButtonsVisibility():Boolean
		{
			return _toggleResumePauseButtonsVisibility;
		}

		public function set toggleResumePauseButtonsVisibility(value:Boolean):void
		{
			_toggleResumePauseButtonsVisibility = value;
			if (_player) updateToStatus(_player.status);
		}
		
		/**
		 * @inheritDoc
		 */
		public function show(instant:Boolean = false, onComplete:Function = null):void
		{
			if (instant)
			{
				autoAlpha = 1;
				if (onComplete != null) onComplete();
			}
			else
			{
				TweenLite.to(this, .5, {autoAlpha: 1, onComplete: onComplete});
			}
			_autoHideTimer.reset();
			if (_autoHide && _enabled) _autoHideTimer.start();
		}
		
		/**
		 * @inheritDoc
		 */
		public function hide(instant:Boolean = false, onComplete:Function = null):void
		{
			if (instant)
			{
				autoAlpha = 0;
				if (onComplete != null) onComplete();
			}
			else
			{
				TweenLite.to(this, .5, {autoAlpha: 0, onComplete: onComplete});
			}
			if (_autoHideTimer) _autoHideTimer.reset();
		}
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}

		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			if (_autoHide) hide(true);
		}
		
		public function get autoHideDelay():Number
		{
			return _autoHideTimer.delay;
		}

		public function set autoHideDelay(value:Number):void
		{
			_autoHideTimer.delay = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return _player is IAudible ? IAudible(_player).volume : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			if (_player is IAudible)
			{
				var audible:IAudible = _player as IAudible;
				audible.volume = value;
				if (_muteButton is ISelectable)
				{
					ISelectable(_muteButton).selected = !audible.volume;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = mouseEnabled = mouseChildren = value;
			if (_progressBar) _progressBar.enabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (debug) logDebug("handleClick: " + event.target);
			
			switch (event.target)
			{
				case _playButton:
					play();
					break;
				case _pauseButton:
					pause();
					break;
				case _resumeButton:
					if (status == PlayerStatus.STOPPED)
					{
						play();
					}
					else
					{
						resume();
					}
					break;
				case _muteButton:
					volume = volume ? 0 : 1;
					break;
				case _fullScreenButton:
					if (stage)
					{
						stage.displayState = stage.displayState == StageDisplayState.NORMAL ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
					}
					break;
			}
		}
		
		private function handlePlayerStatusChange(event:StatusEvent):void
		{
			updateToStatus(status);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, status));
		}

		private function updateToStatus(status:String):void
		{
			if (_toggleResumePauseButtonsVisibility)
			{
				if (_pauseButton) _pauseButton.visible = status == PlayerStatus.PLAYING;
				if (_resumeButton) _resumeButton.visible = status != PlayerStatus.PLAYING;
			}
		}
		
		private function handleAutoHideTimerEvent(event:TimerEvent):void
		{
			if (_autoHide && enabled) hide();
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if (_autoHide && enabled && !shown) show();
		}
		
		private function handlePlayerRollOut(event:MouseEvent):void
		{
			if (_autoHide && shown) hide();
		}
		
		private function handlePlayerVolumeChanged(event:SoundEvent):void
		{
			if (_muteButton is ISelectable && _player is IAudible) (_muteButton as ISelectable).selected = !(_player as IAudible).volume;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			player = null;
			playButton = null;
			pauseButton = null;
			resumeButton = null;
			muteButton = null;
			progressBar = null;
			
			if (_autoHideTimer)
			{
				_autoHideTimer.destruct();
				_autoHideTimer = null;
			}
			
			super.destruct();
		}
	}
}
