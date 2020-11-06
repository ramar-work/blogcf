component extends="std.base.model" {
	//property name="dependencies" default="";
	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="category_uuid";
	property name="IDColumnName" type="string" default="category_id";
	function init(myst, model) {
		//Settings, etc might be needed here...
		return Super.init( myst );
	}
}
