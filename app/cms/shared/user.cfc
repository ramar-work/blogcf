/* ------------------------------------------------------ *
 * user.cfc
 * ----------
 * 
 * things dealing with posts....
 * TODO: Hash a version of the title, and make this the unique id
 * Or rely on that other thing...
 * ------------------------------------------------------ */
component name="user" extends="base" accessors=true {
	//Table long ID column name
	property name="uuidColumnName" type="string" default="login_uuid";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="login_id";

	//Prime column
	property name="primeColumnName" type="string" default="login_usr";


	//Retrieve all categories
	public query function all() {
		var r = myst.dbExec(
		  datasource = myst.getDatasource() 
	  ,	string = "
				SELECT * FROM
					( SELECT * FROM #prefix#login ) AS login
				INNER JOIN
					( SELECT * FROM #prefix#login_metadata ) AS metad
				ON
					login.login_id = metad.lm_match_id
			"
		);

		//this is annoying...
		if ( !r.status ) {

		}

		return r.results;
	}


	//Retrieve one user 
	public query function single( required string id ) {
		return myst.dbExec(
	   	string = "
				SELECT
					*	
				FROM
					( SELECT * FROM #prefix#login ) AS login
				INNER JOIN
					( SELECT * FROM #prefix#login_metadata ) AS metad
				ON
					login.login_id = metad.lm_match_id
				WHERE
					login.login_uuid = :id
			"
		, bindArgs = { id = id }
		).results;
	}


	public struct function create ( required args ) {
		if ( exists( args.username ) ) {
			return myst.lfailure( 500, "User #args.username# already exists." );	
		}

		var r = myst.dbExec(
	   	string = "
				INSERT INTO #table#
					( login_usr, login_pwd, login_role ) 	
				VALUES	
					( :user, :pwd, :role )
			"
		, bindArgs = { 
				user = args.username
			, pwd = components.cms.encPass( args.password )
			, role = { value = args.role, type="integer" }
			}
		);

		if ( !r.status ) {
			return r;
		}
		
		r = myst.dbExec(
	   	string = "
				INSERT INTO #prefix#login_metadata
					( lm_match_id
					, lm_fname
					, lm_mname
					, lm_lname
					, lm_prefix
					, lm_suffix
					, lm_description
					, lm_avatar )
				VALUES	
					( :match_id
					, :fname
					, :mname
					, :lname
					, :prefix
					, :suffix
					, :desc
					, :avatar )
			"
		, bindArgs = { 
				match_id = r.prefix.generatedKey 
			, fname = { value = args.fname, type="varchar" }
			, mname = { value = args.mname, type="varchar" }
			, lname = { value = args.lname, type="varchar" }
			, prefix = { value = args.prefix, type="varchar" }
			, suffix = { value = args.suffix, type="varchar" }
			, desc = { value = args.description, type="varchar" }
			, avatar = { value = args.avatar, type="varchar" }
			}
		);

		return ( !r.status ) ? r : {
			status = true
		, id = get_long_id( r.prefix.generatedKey )
		}
	}

	public struct function update ( required args ) {
		return {};
	}

	public struct function delete ( required args ) {
		return {};
	}

	public struct function retrieve ( required args ) {
		return {};
	}

	function init( myst, model ) {
		Super.init( myst );
		table = "#prefix#login";
		return this;
	}
}
