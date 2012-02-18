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
