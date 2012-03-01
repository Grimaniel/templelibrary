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

package temple.camera 
{
	import temple.core.debug.IDebuggable;
	import temple.core.events.CoreEventDispatcher;
	import temple.utils.FrameDelay;
	import temple.utils.TimeOut;

	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;

	/**
	 * Class for detecting an active webcam.
	 * 
	 * @includeExample CameraDetectorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CameraDetector extends CoreEventDispatcher implements IDebuggable
	{
		private var _debug:Boolean;
		private var _videos:Array;
		private var _cameras:Array;
		private var _defaultCamera:Camera;
		private var _timerOut:TimeOut;
		private var _activeCamera:Camera;

		public function CameraDetector(debug:Boolean = false)
		{
			this._videos = new Array();
			this._cameras = new Array();
			
			this.debug = debug;
		}

		/**
		 * Searches for an active camera
		 */
		public function detectActiveCamera():void
		{
			this._defaultCamera = Camera.getCamera();

			if (this._activeCamera)
			{
				this.dispatchEvent(new CameraDetectorEvent(CameraDetectorEvent.ACTIVE_CAMERA_FOUND, this._activeCamera));
			}
			else if (this._defaultCamera == null)
			{
				if (this._debug) this.logDebug("detectActiveCamera: no camera's found");
				this.dispatchEvent(new CameraDetectorEvent(CameraDetectorEvent.NO_CAMERA_FOUND));
				this.clear();
			}
			else
			{
				if (this._debug) this.logDebug("detectActiveCamera: available webcams: " + Camera.names);
				
				this.checkCamera(this._defaultCamera);
			}
		}
		
		/**
		 * The found active camera
		 */
		public function get activeCamera():Camera
		{
			return this._activeCamera;
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

		private function checkCamera(camera:Camera):void
		{
			if (camera == null) return;
			if (this._debug) this.logDebug("checkCamera: '" + camera.name + "'");
			
			camera.addEventListener(ActivityEvent.ACTIVITY, this.handleCameraActivity);
			camera.addEventListener(StatusEvent.STATUS, this.handleCameraStatus);
			
			this._cameras.push(camera);
			
			var video:Video = new Video();
			video.attachCamera(camera);
			this._videos.push(video);
		}

		private function handleCameraActivity(event:ActivityEvent):void
		{
			var camera:Camera = Camera(event.target);
			if (this._debug) this.logDebug("handleCameraActivity: '" + camera.name + "', activating :" + event.activating);
			
			if (event.activating)
			{
				this._activeCamera = camera;
				this.dispatchEvent(new CameraDetectorEvent(CameraDetectorEvent.ACTIVE_CAMERA_FOUND, camera));
				this.clear();
			}
			else if (camera == this._defaultCamera)
			{
				this.checkAllCameras();
				this._defaultCamera = null;
			}
		}
		
		private function checkAllCameras():void
		{
			this._timerOut.destruct();
			
			var camera:Camera;
			var leni:int = Camera.names.length;
			for (var i:int = 0; i < leni; i++)
			{
				camera = Camera.getCamera(String(i));
				if (camera != this._defaultCamera)
				{
					this.checkCamera(camera);
				}
			}
		}

		private function handleCameraStatus(event:StatusEvent):void
		{
			var camera:Camera = Camera(event.target);
			if (this._debug) this.logDebug("handleCameraStatus: '" + camera.name + "', status " + event.code);
			
			if (camera == this._defaultCamera)
			{
				switch (event.code)
				{
					case CameraStatusEventCode.CAMERA_MUTED:
						this.dispatchEvent(new CameraDetectorEvent(CameraDetectorEvent.CAMERA_NOT_ALLOWED));
						this.clear();
						break;
					case CameraStatusEventCode.CAMERA_UNMUTED:
						if (Camera.names.length > 1) this._timerOut = new TimeOut(this.checkAllCameras, 2000);
						break;
				}
			}
		}
		
		private function clear():void
		{
			if (this._debug) this.logDebug("clear: ");
			
			if (this._cameras)
			{
				for each (var camera : Camera in this._cameras) 
				{
					camera.removeEventListener(ActivityEvent.ACTIVITY, this.handleCameraActivity);
					camera.removeEventListener(StatusEvent.STATUS, this.handleCameraStatus);
				}
				this._cameras = null;
			}
			
			if (this._timerOut)
			{
				this._timerOut.destruct();
				this._timerOut = null;
			}
			new FrameDelay(this.destruct);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._debug) this.logDebug("destruct: ");
			
			if (this._cameras)
			{
				for each (var camera : Camera in this._cameras) 
				{
					camera.removeEventListener(ActivityEvent.ACTIVITY, this.handleCameraActivity);
					camera.removeEventListener(StatusEvent.STATUS, this.handleCameraStatus);
				}
				this._cameras = null;
			}
			if (this._videos)
			{
				for each (var video : Video in this._videos) 
				{
					video.attachCamera(null);
				}
				this._videos = null;
			}
			if (this._timerOut)
			{
				this._timerOut.destruct();
				this._timerOut = null;
			}
			
			this._defaultCamera = null;
			
			super.destruct();
		}
	}
}