/* ------------------------------------------------------ *
 * comment.cfc
 * ------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * ...
 * 
 * @todo
 * - Finish CRUD backend
 * - Come up with a better way to handle lack of auth for general commenting
 * ------------------------------------------------------ */
component name="comment" extends="base" accessors=true {
	//Table long ID column name
	property name="uuidColumnName" type="string" default="comment_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="comment_id";

	public function create( required args ) {
		var r = myst.dbExec(
			string = "
				INSERT INTO cms_comments 
					( comment_postmatch_id, comment_owner, comment_owner_avatar, comment_text )
				VALUES	
					( :id, :owner, :avatar, :text )"
		,	bindArgs = {
				id = 0
			, owner = ""
			, avatar = ""
			, text = ""
			}
		);
	}

	public function single( required args ) {
	}

	public function allAssociated( required args ) {
	}

	public function all( required args ) {
	}

	public function update( required args ) {
	}

	public function remove( required args ) {
	}

	function init( myst, model ) {
		Super.init( myst );
		return this;
	}
}
