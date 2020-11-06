component name="users" extends="base" {
	property name="dependencies" type="list" default="app.cms.shared.user";
	function init( myst, model ) {
		Super.init(myst);
		if ( route.active eq "users" )
			return { users = user.all() };
		else {
			return { user = user.single( route.active ) };
		}
	}
}
