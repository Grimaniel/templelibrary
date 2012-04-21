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

package temple.data
{
	import temple.core.CoreObject;

	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * Class for storing information about a file.
	 * 
	 * @author Arjan van Wijk
	 */
	public class FileData extends CoreObject
	{
		public static function createFromFileReference(fileRef:FileReference):FileData
		{
			var fd:FileData = new FileData();
			
			fd.name = fileRef.name;
			fd.type = fileRef.type;
			fd.size = fileRef.size;
			fd.creator = fileRef.creator;
			fd.creationDate = fileRef.creationDate;
			fd.modificationDate = fileRef.modificationDate;
			// Fix for Flash Player 9
			fd.data = fileRef.hasOwnProperty('data') ? fileRef['data'] : null;
			
			return fd;
		}
		
		/**
		 * The name of the File
		 */
		[Transient(whenNull)]
		public var name:String;
		
		/**
		 * The file type.
		 * 
		 * In Windows or Linux, this property is the file extension. On the Macintosh, this property is the
		 * four-character file type, which is only used in Mac OS versions prior to Mac OS X. If the FileReference
		 * object was not populated, a call to get the value of this property returns null.
		 */
		[Transient(whenNull)]
		public var type:String;
		
		/**
		 * The size
		 */
		[Transient(whenNull)]
		public var size:uint;
		
		/**
		 * The creator of the file.
		 */
		[Transient(whenNull)]
		public var creator:String;
		
		/**
		 * The date when the file was created
		 */
		[Transient(whenNull)]
		public var creationDate:Date;
		
		/**
		 * The last date when the file was modified 
		 */
		[Transient(whenNull)]
		public var modificationDate:Date;
		
		/**
		 * The data of the file.
		 */
		[Transient(whenNull)]
		public var data:ByteArray;
		
		/**
		 * The URL of the file.
		 */
		[Transient(whenNull)]
		public var url:String;
		
		/**
		 * @private
		 * 
		 * The name of the Multi-part field which contains the data of this object when the file is submitted.
		 */
		[Transient(whenNull)]
		public var pointer:String;
		
		public function clone():FileData
		{
			var fd:FileData = new FileData();
			
			fd.name = this.name;
			fd.type = this.type;
			fd.size = this.size;
			fd.creator = this.creator;
			fd.creationDate = this.creationDate;
			fd.modificationDate = this.modificationDate;
			fd.data = this.data;
			fd.pointer = this.pointer;
			fd.url = this.url;
			
			return fd;
		}
	}
}
