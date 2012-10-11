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

package temple.ui.form.components
{
	import temple.utils.types.VectorUtils;

	import flash.net.FileFilter;

	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.core.debug.IDebuggable;
	import temple.core.destruction.DestructEvent;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.net.CoreFileReference;
	import temple.data.FileData;
	import temple.ui.form.validation.IHasError;

	import flash.display.InteractiveObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.utils.Dictionary;

	/**
	 * A form element for selecting a file from the filesystem.
	 * 
	 * @author Thijs Broerse
	 */
	public class FileField extends CoreEventDispatcher implements IHasValue, IDebuggable, IFocusable, IHasError, IResettable, IEnableable
	{
		private var _fileReference:CoreFileReference;
		private var _fileData:FileData;
		private var _inputField:InputField;
		private var _maxFileSize:uint;
		private var _maxFileSizeErrorMessage:String;
		private var _debug:Boolean;
		private var _fileFilters:Vector.<FileFilter>;
		private var _fileFilterErrorMessage:String;
		private var _isBrowsing:Boolean;
		private var _buttons:Dictionary;
		private var _enabled:Boolean = true;

		public function FileField(inputField:InputField = null, fileFilters:Vector.<FileFilter> = null, maxFileSize:uint = 2 * 1024 * 1024, browseButton:InteractiveObject = null)
		{
			this._fileReference = new CoreFileReference();
			this._fileReference.addEventListener(Event.CANCEL, this.handleFileEvent);
			this._fileReference.addEventListener(Event.COMPLETE, this.handleFileComplete);
			this._fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.handleFileEvent);
			this._fileReference.addEventListener(IOErrorEvent.IO_ERROR, this.handleFileEvent);
			this._fileReference.addEventListener(Event.OPEN, this.handleFileEvent);
			this._fileReference.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
			this._fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleFileEvent);
			this._fileReference.addEventListener(Event.SELECT, this.handleFileSelect);

			if (inputField) this.inputField = inputField;
			this._fileFilters = fileFilters;
			this._maxFileSize = maxFileSize;
			if (browseButton) this.addBrowseButton(browseButton);
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return this.fileData;
		}

		/**
		 * Returns the data as FileData
		 */
		public function get fileData():FileData
		{
			return this._fileData;
		}

		/**
		 * Displays a file-browsing dialog box that lets the user select a file to upload
		 * Use the FileFilerType class for getting the correct FileFilter
		 * 
		 * @return Returns true if the parameters are valid and the file-browsing dialog box opens.
		 */
		public function browse(fileFilters:Vector.<FileFilter> = null):Boolean
		{
			if (this._isBrowsing)
			{
				if (this.debug) this.logDebug("Browsing session already open.");
				return false;
			}
			if (this._fileData)
			{
				this._fileData.destruct();
				this._fileData = null;
			}
			if (this._inputField)
			{
				this._inputField.reset();
			}


			if (fileFilters) this._fileFilters = fileFilters;

			return this._isBrowsing = this._fileReference.browse(this._fileFilters ? VectorUtils.toArray(this._fileFilters) : null);
		}

		/**
		 * Returns a reference to the FileReference
		 */
		public function get file():FileReference
		{
			return this._fileReference;
		}

		/**
		 * Set the fileFilter for file selecting
		 * Use the FileFilerType class for getting the correct FileFilter
		 */
		public function get fileFilters():Vector.<FileFilter>
		{
			return this._fileFilters;
		}

		/**
		 * @private
		 */
		public function set fileFilters(value:Vector.<FileFilter>):void
		{
			this._fileFilters = value;
		}

		/**
		 * Error message which is shown when selected file doesn't match with the FileFilters
		 */
		public function get fileFilterErrorMessage():String
		{
			return this._fileFilterErrorMessage;
		}

		/**
		 * @private
		 */
		public function set fileFilterErrorMessage(value:String):void
		{
			this._fileFilterErrorMessage = value;
		}

		/**
		 * Set an InputField as FileField, for displaying filename after selection and show error state.
		 */
		public function get inputField():InputField
		{
			return this._inputField;
		}

		/**
		 * @private
		 */
		public function set inputField(value:InputField):void
		{
			if (this._inputField)
			{
				this._inputField.removeEventListener(MouseEvent.CLICK, this.handleClick);
				this._inputField.removeEventListener(FocusEvent.FOCUS_IN, this.handleInputFocus);
				this._inputField.removeEventListener(DestructEvent.DESTRUCT, this.handleInputDestruct);
			}
			this._inputField = value;
			if (this._inputField)
			{
				this._inputField.addEventListener(MouseEvent.CLICK, this.handleClick);
				this._inputField.addEventListener(FocusEvent.FOCUS_IN, this.handleInputFocus);
				this._inputField.addEventListener(DestructEvent.DESTRUCT, this.handleInputDestruct);
			}
		}

		/**
		 * 
		 */
		public function get maxFileSize():uint
		{
			return this._maxFileSize;
		}

		/**
		 * @private
		 */
		public function set maxFileSize(value:uint):void
		{
			this._maxFileSize = value;
		}

		/**
		 * Error message which will be shown when file exceeded max filesize
		 */
		public function get maxFileSizeErrorMessage():String
		{
			return this._maxFileSizeErrorMessage;
		}

		/**
		 * @private
		 */
		public function set maxFileSizeErrorMessage(value:String):void
		{
			this._maxFileSizeErrorMessage = value;
		}

		/**
		 * Add a buttons which will open the browse dialog when clicked on.
		 */
		public function addBrowseButton(button:InteractiveObject):void
		{
			this._buttons = new Dictionary(true);
			this._buttons[button];
			button.addEventListener(MouseEvent.CLICK, this.handleClick, false, 0, true);
		}

		/**
		 * Remove a buttons which will open the browse dialog when clicked on.
		 */
		public function removeBrowseButton(button:InteractiveObject):void
		{
			if (this._buttons)
			{
				delete this._buttons[button];
				button.removeEventListener(MouseEvent.CLICK, this.handleClick);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._inputField && this._inputField.focus;
		}

		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (this._inputField) this._inputField.focus = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get hasError():Boolean
		{
			return this._inputField && this._inputField.hasError;
		}

		/**
		 * @inheritDoc
		 */
		public function set hasError(value:Boolean):void
		{
			if (this._inputField) this._inputField.hasError = value;
		}

		/**
		 * @inheritDoc
		 */
		public function showError(message:String = null):void
		{
			if (this._inputField) this._inputField.showError(message);
			this.dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.SHOW_ERROR, message));
		}

		/**
		 * @inheritDoc
		 */
		public function hideError():void
		{
			if (this._inputField) this._inputField.hideError();
			this.dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.HIDE_ERROR));
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			if (this._inputField) this._inputField.reset();
			this._fileReference.cancel();
			if (this._fileData)
			{
				this._fileData.destruct();
				this._fileData = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}

		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
		}

		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this._enabled = true;
		}

		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this._enabled = false;
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

		private function handleInputFocus(event:FocusEvent):void
		{
			if (this.debug) this.logDebug("handleInputFocus: " + event.target);
			this.browse();
		}

		private function handleClick(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleClick: " + event.target);
			this.browse();
		}

		private function handleFileEvent(event:Event):void
		{
			if (event.type == Event.CANCEL) this._isBrowsing = false;

			if (event is ErrorEvent)
			{
				this.logError("Event: " + event.type + ": " + ErrorEvent(event).text);
			}
			else if (this.debug)
			{
				this.logDebug("Event: " + event.type);
			}
			this.dispatchEvent(event);
		}

		private function handleFileSelect(event:Event):void
		{
			if (this.debug) this.logDebug("Event: " + event.type);

			this._isBrowsing = false;

			var fileValid:Boolean;

			if (this._fileFilters && this._fileFilters.length && this._fileReference.type)
			{
				for each (var filter:FileFilter in this._fileFilters)
				{
					if (filter.extension.toLowerCase().indexOf(this._fileReference.type.toLowerCase()) != -1)
					{
						fileValid = true;
						break;
					}
				}
			}
			else
			{
				fileValid = true;
			}

			if (!fileValid)
			{
				if (this.debug) this.logDebug("handleFileSelect: file not valid");
				this._inputField.showError(this._fileFilterErrorMessage);
			}
			else if (!isNaN(this._maxFileSize) && this._fileReference.size > this._maxFileSize)
			{
				if (this.debug) this.logDebug("handleFileSelect: max filesize exceeded");
				this._inputField.showError(this._maxFileSizeErrorMessage);
			}
			else
			{
				if (this._inputField)
				{
					this._inputField.text = this._fileReference.name;
					this._inputField.hideError();
				}

				this._fileReference.load();

			}
			this.dispatchEvent(event);
		}

		private function handleFileComplete(event:Event):void
		{
			this._fileData = FileData.createFromFileReference(this._fileReference);
			this.dispatchEvent(event);
		}

		private function handleInputDestruct(event:DestructEvent):void
		{
			this.destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._buttons)
			{
				for (var button : *	in this._buttons) this.removeBrowseButton(button);
				this._buttons = null;
			}

			this.inputField = null;

			if (this._fileReference)
			{
				this._fileReference.destruct();
				this._fileReference = null;
			}
			this._fileFilters = null;

			super.destruct();
		}
	}
}
