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

package temple.codecomponents.players.controls
{
	import temple.codecomponents.buttons.CodePauseButton;
	import temple.codecomponents.buttons.CodePlayButton;
	import temple.mediaplayers.players.IPlayer;
	import temple.mediaplayers.players.controls.PlayerControls;
	import temple.mediaplayers.players.controls.PlayerProgressBar;
	import temple.ui.layout.liquid.LiquidContainer;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;

	/**
	 * @author Thijs Broerse
	 */
	public class CodePlayerControls extends LiquidContainer
	{
		private var _controls:PlayerControls;
		
		public function CodePlayerControls(player:IPlayer = null, width:Number = NaN)
		{
			width ||= (player is DisplayObject && DisplayObject(player).width ? DisplayObject(player).width : 400);
			
			super(width, 20);
			
			this.background = true;
			this.backgroundAlpha = .5;
			
			this._controls = new PlayerControls();
			this._controls.player = player;
			
			this._controls.resumeButton = this.addChild(new CodePlayButton(14, 12)) as InteractiveObject;
			this._controls.pauseButton = this.addChild(new CodePauseButton(14, 12)) as InteractiveObject;
			
			this._controls.resumeButton.x = this._controls.resumeButton.y = 3;
			this._controls.pauseButton.x = this._controls.pauseButton.y = 3;
			
			this._controls.toggleResumePauseButtonsVisibility = true;
			this._controls.progressBar = this.addChild(new CodePlayerProgressBar(player, width - 40)) as PlayerProgressBar;
			
			this._controls.progressBar.y = 3;
			this._controls.progressBar.left = 20;
			this._controls.progressBar.right = 20;
		}

		public function get player():IPlayer
		{
			return this._controls.player;
		}
		
		public function set player(value:IPlayer):void
		{
			this._controls.player = value;
		}
	}
}
