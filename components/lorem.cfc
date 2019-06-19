/* -------------------------------------------------------------------------- *
 * lorem
 * =====
 *
 * Summary
 * -------
 * Generates typeface test code.
 *
 * Author 
 * ------
 * Antonio R. Collins II
 * ramar@tubularmodular.com
 *
 * Usage
 * -----
 * ...
 *
 * TODO 
 * ----
 * - Fix the counts
 *
 * -------------------------------------------------------------------------- */
component 
name="lorem"
extends="Base"
accessors=true 
{
	property name="count" default="9";
	property name="start" default="1";

	//Output some ipsum, using a specified count or the predefined one.
	public function generate( Numeric count, Numeric start ) {
		//read file
		var mpath = Replace(getPrivatePath('lorem.txt'),"/","");
		var src = FileRead( "#getMyst().getRootDir()##mpath#" );
		var list = ListToArray( src, Chr(10), false, true );
		var a = arguments;
		var str = "";
		var cnt = StructKeyExists(a,"count") ? a.count : getCount();
		for ( var cc=getStart(); cc <= cnt; cc++ ) str &= list[ cc ];
		return str;
	}
}
