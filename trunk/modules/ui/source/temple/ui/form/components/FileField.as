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
			_fileReference = new CoreFileReference();
			_fileReference.addEventListener(Event.CANCEL, handleFileEvent);
			_fileReference.addEventListener(Event.COMPLETE, handleFileComplete);
			_fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleFileEvent);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, handleFileEvent);
			_fileReference.addEventListener(Event.OPEN, handleFileEvent);
			_fileReference.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleFileEvent);
			_fileReference.addEventListener(Event.SELECT, handleFileSelect);

			if (inputField) this.inputField = inputField;
			_fileFilters = fileFilters;
			_maxFileSize = maxFileSize;
			if (browseButton) addBrowseButton(browseButton);
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return fileData;
		}

		/**
		 * Returns the data as FileData
		 */
		public function get fileData():FileData
		{
			return _fileData;
		}

		/**
		 * Displays a file-browsing dialog box that lets the user select a file to upload
		 * Use the FileFilerType class for getting the correct FileFilter
		 * 
		 * @return Returns true if the parameters are valid and the file-browsing dialog box opens.
		 */
		public function browse(fileFilters:Vector.<FileFilter> = null):Boolean
		{
			if (_isBrowsing)
			{
				if (debug) logDebug("Browsing session already open.");
				return false;
			}
			if (_fileData)
			{
				_fileData.destruct();
				_fileData = null;
			}
			if (_inputField)
			{
				_inputField.reset();
			}


			if (fileFilters) _fileFilters = fileFilters;

			return _isBrowsing = _fileReference.browse(_fileFilters ? VectorUtils.toArray(_fileFilters) : null);
		}

		/**
		 * Returns a reference to the FileReference
		 */
		public function get file():FileReference
		{
			return _fileReference;
		}

		/**
		 * Set the fileFilter for file selecting
		 * Use the FileFilerType class for getting the correct FileFilter
		 */
		public function get fileFilters():Vector.<FileFilter>
		{
			return _fileFilters;
		}

		/**
		 * @private
		 */
		public function set fileFilters(value:Vector.<FileFilter>):void
		{
			_fileFilters = value;
		}

		/**
		 * Error message which is shown when selected file doesn't match with the FileFilters
		 */
		public function get fileFilterErrorMessage():String
		{
			return _fileFilterErrorMessage;
		}

		/**
		 * @private
		 */
		public function set fileFilterErrorMessage(value:String):void
		{
			_fileFilterErrorMessage = value;
		}

		/**
		 * Set an InputField as FileField, for displaying filename after selection and show error state.
		 */
		public function get inputField():InputField
		{
			return _inputField;
		}

		/**
		 * @private
		 */
		public function set inputField(value:InputField):void
		{
			if (_inputField)
			{
				_inputField.removeEventListener(MouseEvent.CLICK, handleClick);
				_inputField.removeEventListener(FocusEvent.FOCUS_IN, handleInputFocus);
				_inputField.removeEventListener(DestructEvent.DESTRUCT, handleInputDestruct);
			}
			_inputField = value;
			if (_inputField)
			{
				_inputField.addEventListener(MouseEvent.CLICK, handleClick);
				_inputField.addEventListener(FocusEvent.FOCUS_IN, handleInputFocus);
				_inputField.addEventListener(DestructEvent.DESTRUCT, handleInputDestruct);
			}
		}

		/**
		 * 
		 */
		public function get maxFileSize():uint
		{
			return _maxFileSize;
		}

		/**
		 * @private
		 */
		public function set maxFileSize(value:uint):void
		{
			_maxFileSize = value;
		}

		/**
		 * Error message which will be shown when file exceeded max filesize
		 */
		public function get maxFileSizeErrorMessage():String
		{
			return _maxFileSizeErrorMessage;
		}

		/**
		 * @private
		 */
		public function set maxFileSizeErrorMessage(value:String):void
		{
			_maxFileSizeErrorMessage = value;
		}

		/**
		 * Add a buttons which will open the browse dialog when clicked on.
		 */
		public function addBrowseButton(button:InteractiveObject):void
		{
			_buttons = new Dictionary(true);
			_buttons[button];
			button.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}

		/**
		 * Remove a buttons which will open the browse dialog when clicked on.
		 */
		public function removeBrowseButton(button:InteractiveObject):void
		{
			if (_buttons)
			{
				delete _buttons[button];
				button.removeEventListener(MouseEvent.CLICK, handleClick);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return _inputField && _inputField.focus;
		}

		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (_inputField) _inputField.focus = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get hasError():Boolean
		{
			return _inputField && _inputField.hasError;
		}

		/**
		 * @inheritDoc
		 */
		public function set hasError(value:Boolean):void
		{
			if (_inputField) _inputField.hasError = value;
		}

		/**
		 * @inheritDoc
		 */
		public function showError(message:String = null):void
		{
			if (_inputField) _inputField.showError(message);
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.SHOW_ERROR, message));
		}

		/**
		 * @inheritDoc
		 */
		public function hideError():void
		{
			if (_inputField) _inputField.hideError();
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.HIDE_ERROR));
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			if (_inputField) _inputField.reset();
			_fileReference.cancel();
			if (_fileData)
			{
				_fileData.destruct();
				_fileData = null;
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
			_enabled = value;
		}

		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			_enabled = true;
		}

		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			_enabled = false;
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

		private function handleInputFocus(event:FocusEvent):void
		{
			if (debug) logDebug("handleInputFocus: " + event.target);
			browse();
		}

		private function handleClick(event:MouseEvent):void
		{
			if (debug) logDebug("handleClick: " + event.target);
			browse();
		}

		private function handleFileEvent(event:Event):void
		{
			if (event.type == Event.CANCEL) _isBrowsing = false;

			if (event is ErrorEvent)
			{
				logError("Event: " + event.type + ": " + ErrorEvent(event).text);
			}
			else if (debug)
			{
				logDebug("Event: " + event.type);
			}
			dispatchEvent(event);
		}

		private function handleFileSelect(event:Event):void
		{
			if (debug) logDebug("Event: " + event.type);

			_isBrowsing = false;

			var fileValid:Boolean;

			if (_fileFilters && _fileFilters.length && _fileReference.type)
			{
				for each (var filter:FileFilter in _fileFilters)
				{
					if (filter.extension.toLowerCase().indexOf(_fileReference.type.toLowerCase()) != -1)
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
				if (debug) logDebug("handleFileSelect: file not valid");
				_inputField.showError(_fileFilterErrorMessage);
			}
			else if (!isNaN(_maxFileSize) && _fileReference.size > _maxFileSize)
			{
				if (debug) logDebug("handleFileSelect: max filesize exceeded");
				_inputField.showError(_maxFileSizeErrorMessage);
			}
			else
			{
				if (_inputField)
				{
					_inputField.text = _fileReference.name;
					_inputField.hideError();
				}

				_fileReference.load();

			}
			dispatchEvent(event);
		}

		private function handleFileComplete(event:Event):void
		{
			_fileData = FileData.createFromFileReference(_fileReference);
			dispatchEvent(event);
		}

		private function handleInputDestruct(event:DestructEvent):void
		{
			destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_buttons)
			{
				for (var button : *	in _buttons) removeBrowseButton(button);
				_buttons = null;
			}

			inputField = null;

			if (_fileReference)
			{
				_fileReference.destruct();
				_fileReference = null;
			}
			_fileFilters = null;

			super.destruct();
		}
	}
}
