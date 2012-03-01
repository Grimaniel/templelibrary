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
