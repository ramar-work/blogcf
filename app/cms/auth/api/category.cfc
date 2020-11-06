component extends="base" name="category" {
	property name="dependencies" default="app.cms.shared.category";
	property name="requiredOnCreate" type="struct" default="name";
	property name="requiredOnUpdate" type="struct" default="";
	property name="optionalOnCreate" type="struct" default="";
	property name="optionalOnUpdate" type="struct" default="name,description";

	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="category_uuid";
	property name="IDColumnName" type="string" default="category_id";

	//Pull all categories belonging to a specific post
	private struct function inside( args ) {
		return category.matching( route.active );
	}

	private struct function all( args ) {
		return category.all();
	}

	private struct function create( args ) {
		return category.create( args );	
	}

	private struct function delete( args ) {
		return category.delete( args.id );	
	}

	private struct function update( args ) {
		return category.update( args.id, args );	
	}

	private struct function retrieve( args ) {
		return category.single( args );
	}

	function init(myst, model) {
		return Super.init( myst );
	}
}
