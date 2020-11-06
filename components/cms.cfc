/* ----------------------------------------
cms.cfc

This is a management system that runs
via ColdFusion/Lucee.
---------------------------------------- */
component
name="cms"
extends="base"
accessors="true"
{
	//The title of our stupid component thing.
	property name="adminTitle" default="mystCMS"; 

	//How to store authentication details [cookie, db or session]
	property name="authStorage" default="session";

	//Different content type constants
	property name="constOctetStream" default=1;

	property name="constText" default=2;

	property name="constAudio" default=3;

	property name="constImage" default=4;

	property name="constVideo" default=5;

	property name="constMessage" default=6;

	property name="constApplication" default=7;

	//???
	property name="constants" default="1,2,3,4,5,6,7";

	//...
	property name="contentIdType" default="varchar";

	//
	property name="cssFilelist" default="zero,core,list-li,list-table";

	//...
	property name="dbTable" default="cms";

	//An expiry time (in seconds) for started sessions.
	property name="expiry" type="number" default="3000";

	//The name of a binary post field
	property name="fieldName" default="lucy";

	//The name of the text field.
	property name="fieldText" default="lucy-text";

	//Pages for user presentation
	property name="pageFront" default="blog";
	property name="pageSingle" default="blog";
	property name="pageArchive" default="archives";
	property name="pageRecallStyle" default="lucy";

	//?
	property name="js" default="core,list-li,list-table";

	//A spot for the Myst object.
	property name="mask" default="YYYY-MM-dd HH:nn:ss";

	//A password to stop random people from adding users.
	property name="nonce" default="somePassword";

	//...
	property name="prefix" default="cms_";

	//..
	property name="postCount" default=5;

	//A salt
	property name="salt" default="juicem4in";

	//The type of datasource in use (mysql/postgres will allow different things than MSsql)
	property name="sourceType" default="";

	//Weird content handling list
	property name="typeList" default="octet-stream,text,audio,image,video,message,application";

	//Return a generated numeric ID 
	public string function genContentId( ) {
		return "#getMyst().randNum(10)#";
	}


	//Return a generated string
	public string function getRandomString( ) {
		return "#getMyst().randStr(32)#";
	}


	//Private date string... for no particular reason...
	public function getCurrentDatestamp( string mask ) {
		var myMask = StructKeyExists( arguments,"mask" ) ? mask : getMask();
		return { value = DateTimeFormat( Now(), myMask ), type="timestamp" };
	}


	//Check the scope for parameters, fail if not there...	
	//This is a way to solve this, though not quite ideal.
	private struct function trap ( Required scope, Required Numeric hStatus, Array keys ) {
		for ( var n=1; n<ArrayLen(keys); n++ ) {
			if ( !StructKeyExists( scope, keys[n] ) || keys[n] eq "" ) {
				return {	
					status=0
			  , httpStatus=arguments.hStatus
				, message="Key '#keys[n]#' is required but not specified." 
				};
			}
		}
		return {
			status = 1
		}
	}	


	//...
	public string function getMimeCategory( required string mimetype ) {
		return Left( mimetype, Find( "/", mimetype ) - 1 );
	}


	public string function getMimetype( required string filetype ) {
		var constant = "text/html";
		if ( StructKeyExists( myst.getCommonExtensionsToMimeTypes(), filetype ) ) {
			return myst.getCommonExtensionsToMimeTypes()[ filetype ];
		}
		return constant;
	}


	public numeric function getMimeCategoryIndex( required string filetype ) {
		var constant = 2;
		if ( StructKeyExists( myst.getCommonExtensionsToMimeTypes(), filetype ) ) {
			var mm = myst.getCommonExtensionsToMimeTypes()[ filetype ];
			constant = ListFind( getTypeList(), getMimeCategory( mm ) );
		}
		return constant;
	}


	private query function duplicateBaseQuery ( required struct qd ) {
		var qset;
		var typeset = "";
		for ( var _ in qd.prefix.columnList ) {
			typeset = ListAppend( typeset, "varchar" );
		}
		return QueryNew( qd.prefix.columnList, typeset ); 
	}


	//Convert paths
	public query function convertResultSetToFullPaths( required struct qd, required string col ) {
		var bquery = duplicateBaseQuery( qd );
		//Need to be able to construct a query and reconstruct...
		for ( var qs in qd.results ) {
			var st = qs;
			//TODO: You can convert to base64 or you can serve a private path
			if ( ListFind( "image,audio,video", getMimeCategory( qs.content_type ) ) ) {
				st[ col ] = "/#getNamespace()#/file/#qs[ col ]#";
			}
			QueryAddRow( bquery, st );	
		}
		return bquery;
	}


	//check against the nonce
	private void function compareNonce( Required String text ) {
		if ( text neq getNonce() ) {
			getMyst().sendAsJson(
				status = 0
			, httpStatus=401
			, message="Nonce doesn't match, can't add user." 
			);	
		}
	}


	//encode passwords
	public string function encPass( required string pwd ) {
		return hash( "#pwd##getSalt()#", "SHA-384" );
	}


	//Start a user session
	public boolean function createUserSession( required string username ) {
		try {
			var status;
			//If session, just add it
			if ( getAuthStorage() eq "session" ) {
				//To keep all of this seperate, it might bge a good idea to make another folder in components/
				session.username = username;	
				session.token = myst.randStr( 64 );	
				session.startDate = Now();	
			}	
			else if ( getAuthStorage() eq "db" ) {
				status = myst.dbExec(
					string = "INSERT INTO #prefix#session VALUES ( :trkr, :start )"
				, bindArgs = { trkr = myst.randstr(32), start = getCurrentDatestamp() } 	
				);
			
				if ( !status ) {
					//TODO: Many failures could happen, but I don't want to return a struct...
					return false;
				}
			}
		}
		catch (Exception e) {
			return false;
		}
		return true;
	}


	//Delete a user session
	public boolean function destroyUserSession( string token ) {
		if ( getAuthStorage() eq "session" ) {	
			StructDelete( session, "username" );
			StructDelete( session, "token" );
			StructDelete( session, "startDate" );
		}
		else if ( getAuthStorage() eq "db" ) {
			var del = myst.dbExec(
				string = "DELETE FROM #prefix#session WHERE session_tracker = :trkr )"
			, bindArgs = { trkr = token }
			);
	
			if ( !del.status ) {
				return false;
			}
		}
		return true;
	}


	//Check for a valid source of authentication
	public boolean function checkUserToken( string token ) {
		//Check sessions, database, and url, depending on method chosen...
		if ( getAuthStorage() eq "session" ) {
			if ( !StructKeyExists( session, "startDate" ) || !StructKeyExists( session, "username" ) ) {
				return false;
			}
			if ( DateDiff( "s",  session.startDate, now() ) > getExpiry() ) {
				destroyUserSession();
			}
		}
		else if ( getAuthStorage() eq "db" ) {
			//TODO: Many failures could happen, but I don't want to return a struct...
			var del;
			var get;

			if ( !token ) {
				//no token supplied, fail
				return false;
			} 

			get = myst.dbExec(
				string = "SELECT * FROM #prefix#session WHERE session_tracker = :trkr )"
			, bindArgs = { trkr = token }
			);
	
			if ( !get.status || get.prefix.recordCount == 0 || get.prefix.recordCount > 1 ) {
				//getting token in db failed
				return false;
			}

			if ( DateDiff( "s", get.results.session_startdate, now() ) > getExpiry() ) {
				destroyUserSession( get.results.session_tracker );
			}
		}
		else {
			return false;
		}
		return true;
	}


	//Handle authentication
	public struct function checkAuthorization() {
		var r;
		var c = getMyst();
		var t = trap( form, 401, [ "username", "password" ] );

		if ( !t.status ) {
			//Need to return a 401 here...
			return t;
		}

		//Find the username and password if it exists...
		r = c.dbExec(
			datasource = getDatasource()
		, string = "SELECT * FROM #prefix#login WHERE login_usr = :usrid AND login_pwd = :pwd"
		, bindArgs = { usrid=form.username, pwd=encPass( form.password ) }
		);

		//...
		if ( !r.status ) {
			return myst.failure( 500, r.message );
		}

		if ( !r.prefix.recordCount ) {
			return myst.failure( 401, "No username/password combination found for this user." );
		}

		//add to session (since this is over JS, I"m not sure that this works...)
		return {
			status = true
		, message = r.message 
		};
	}


	//Get the collections
	public array function getCollections() {
		var dir = "#myst.getRootDir()#app/cms/shared/collection";
		var loc = DirectoryList( dir, false, 'name', "", "", "file" );
		var arr = [];
		for ( var n in loc ) {
			ArrayAppend( arr, Replace( n, ".cfc", "" ) );	
		}
		//return "#getMyst().randStr(32)#";
		return arr;
	}


/*
	//Retrieve basic metas, eventually feed from datasource
	public query function qGetStandardMetas() {
		//You can use a validator to catch arguments

		//Return a query	
		return QueryNew(
			"key,value,content"
		, "varchar,varchar,varchar"
		, [
				{ key="http-equiv", value="content-type", content="text/html; charset=utf-8" }
			 ,{ key="http-equiv", value="X-UA-Compatible", content="ie=edge" }
			 ,{ key="name", value="google-site-verification", content="rAPss2vKbyhbh6uzTuqqhhq2eoXUCKPQosTwcxNHjU4" }
			 ,{ key="name", value="viewport", content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no" }
			 ,{ key="name", value="apple-mobile-web-app-capable", content="yes" } 
			 ,{ key="name", value="apple-mobile-web-app-status-bar-style", content="black-translucent" } 
			 ,{ key="name", value="author", content="Antonio Ramar Collins II" } 
			 ,{ key="name", value="description", content="ramarcollins.com, a blog about programming and web design" } 
			 ,{ key="property", value="og:locale", content="en_US" } 
			 ,{ key="property", value="og:type", content="website" } 
			 ,{ key="property", value="og:title", content="ramarcollins.com | 5 Years In" } 
			 ,{ key="property", value="og:description", content=site_bar }
			 ,{ key="property", value="og:url", content="http://ramarcollins.com/" } 
			 ,{ key="property", value="og:site_name", content="ramarcollins.com" } 
			 ,{ key="name", value="twitter:card", content=site_bar } 
			// ,{ key="name", value="twitter:description", content="" }
			// ,{ key="name", value="twitter:title", content="" } 
			// ,{ key="name", value="twitter:site", content="@ranviainsights" } 
			// ,{ key="name", value="twitter:creator", content="@ranviainsights" } 
			]
		);
	}
*/


	//Get columns as a query (when things fail, return this)
	private query function _qGetColumns( Required tableName ) {
		var c = getMyst();
		//query the datasource and get the type of database
		//the strings used can be private properties...
	
		var r = c.dbExec(
			string = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
				WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :tb"
		, datasource = getDatasource()
		, bindArgs = { db = getDatasource(), tb = arguments.tableName }
		);

		return QueryNew( "a,b", "varchar,varchar" );
	}


	//Get columns as a query (when things fail, return this)
	private query function _qExecute( Required string string, bindArgs ) {
		var c = getMyst();
		var r = c.dbExec(
			datasource = getDatasource()
	  ,	string = arguments.string
		, bindArgs = ( StructKeyExists(arguments,"bindArgs") ) ? bindArgs : {}
		);
		return ( r.status ) ? r.results : _qGetColumns( arguments.table );
	}


/*
	all()
	//Retrieve all the posts.
	public query function qGetAllPosts() {
		return _qExecute(
	   	string = "
			SELECT * FROM
				( SELECT * FROM #prefix#post ) AS p
			INNER JOIN
				( SELECT * FROM #prefix#post_metadata ) AS m
			ON p.post_long_id = m.pmd_postmatch_id
			ORDER BY post_date_added DESC
			"
		, table = "post"
		);
	}


	//Retrieve all the posts.
	published()
	public query function qGetPublishedPosts() {
		return _qExecute(
	   	string = "
			SELECT * FROM
				( SELECT * FROM #prefix#post ) AS p
			INNER JOIN
				( SELECT * FROM #prefix#post_metadata WHERE pmd_isdraft = 0 ) AS m
			ON p.post_long_id = m.pmd_postmatch_id
			ORDER BY post_date_added DESC
			"
		, table = "post"
		);
	}


	//Retrieve all categories
	//category.cfc -> all()
	public query function qGetCategories() {
		return _qExecute(
	   	string = "SELECT * FROM #prefix#category"
		, table = "post"
		);
	}

*/


	//Retrieve a "post" type, and submit that... for components this should work too.
	public string function findPostType( Required String type ) {
		return "";
	}


	//Retrieve summary of posts.
	public query function qGetSummary( Numeric postcount, Numeric sumcount ) {
		var ct;
		var sumct = 1;
		var c = getMyst();

		if ( arguments[1] neq "" )
			ct = arguments[1];
		else if ( StructKeyExists( arguments, "postcount" ) )
			ct = count;
		else if ( StructKeyExists( url, "postcount" ) )
			ct = url.count;
		else {
			ct = getPostCount();
		}

		var b = c.dbExec(
			string = "	
			SELECT * FROM (
				SELECT * FROM
				( SELECT * FROM #prefix#post ) AS ap
				INNER JOIN
				( SELECT * FROM #prefix#post_metadata WHERE pmd_isdraft = 0 ) AS pm
				ON ap.post_long_id = pm.pmd_postmatch_id
			) as p
			INNER JOIN
				( SELECT * FROM #prefix#content WHERE content_order < :sumcount ) as c
			ON p.post_long_id	= c.content_postmatch_id
			ORDER BY p.post_id, c.content_order ASC
			"
		, bindArgs = { sumcount = sumct }
		, datasource = getDatasource()
		);

		if ( !b.status ) {
			//TODO: Obviously, this needs to return the correct columns...
			return QueryNew( "nothing,nothing_else", "varchar,varchar" );
		}

		//let's do a qoq to sort this
		var cc = c.dbExec(
			string = "SELECT * FROM __mem__ ORDER BY post_date_added DESC"
		, query = b.results 
		);

		if ( !cc.status ) {
			return QueryNew( "nothing,nothing_else", "varchar,varchar" );
		}

		return cc.results;
	}


	//Retrieve one single post by the appropriate filter.
	public query function qGetSinglePost( Numeric id, String lid ) {
		var pid; 
		var plid;
		var c = getMyst();
		//
		if ( StructKeyExists( arguments, "id" ) ) 
			{ pid = arguments.id; plid = -1; }
		else if ( StructKeyExists( arguments, "lid" ) ) 
			{ pid = -1; plid = arguments.lid; }
		else {
			//Useful to combine url and argument scopes?  Then I just move through one.
			var vs = c.validate( url, {
				{ post_id = { req = false, ifNone = -1 } }
			 ,{ post_long_id = { req = false, ifNone = -1 } }
			});
			pid = vs.results.post_id; 
			plid = vs.results.post_long_id; 
		}
/*			
		//you may need to give this another look
		return _qExecute(
			string = "	
			SELECT * FROM
				( SELECT * FROM post WHERE 
					post_id = :pid OR post_long_id = :plid ) as p
			INNER JOIN
				( SELECT * FROM content ) as c
			ON p.post_long_id	= c.parent_id
			ORDER BY c.content_order ASC 
			"
		, bindArgs = { 
				pid = pid
			, plid = plid
			}
		, table = "post"
		);
*/

		//Make the insert
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "	
			SELECT * FROM
				(
					SELECT * FROM
					( SELECT * FROM #prefix#post WHERE post_id = :pid OR post_long_id = :plid ) AS ap
					INNER JOIN
					( SELECT * FROM #prefix#post_metadata ) AS pm
					ON ap.post_long_id = pm.pmd_postmatch_id
				) as p
			INNER JOIN
				( SELECT * FROM #prefix#content ) as c
			ON p.post_long_id	= c.content_postmatch_id
			ORDER BY p.post_id, c.content_order ASC 
			"
		, bindArgs = { 
				pid = pid
			, plid = plid
			}
		);

		if ( !r.status ) {
			//writedump( r );
			//return c.sendAsJson( status=r.status, httpStatus=500, message="#r.message#" );
			return QueryNew("a,b","varchar,varchar");
		}

		//return r.results;
		var a = convertResultSetToFullPaths( r );
//writedump( a );abort;
return a;
	}


	//Insert Meta 
	public string function qInsertMeta ( ) {
		var c = getMyst();
		var vs = c.validate( form, {
			/*The name of the record is what should exist in POST or GET*/
		  parent_id = { req = true }
		, title = { req = true }
		, draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, httpStatus=500, message=vs.message );
		}
		
		return c.sendAsJson( status=1, httpStatus=200, message="SUCCESS @ featureImage" );
	}


	//Insert Keyword 
	public string function qInsertKeyword ( ) {
		var c = getMyst();
		var vs = c.validate( form, {
			/*The name of the record is what should exist in POST or GET*/
		  parent_id = { req = true }
		, title = { req = true }
		, draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, httpStatus=500, message=vs.message );
		}
		
		return c.sendAsJson( status=1, httpStatus=200, message="SUCCESS @ featureImage" );
	}


	//Insert FeatureImage 
	public string function qInsertFeatureImage ( ) {
		var c = getMyst();
		var vs = c.validate( form, {
			/*The name of the record is what should exist in POST or GET*/
		  parent_id = { req = true }
		, title = { req = true }
		, draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, httpStatus=500, message=vs.message );
		}
		
		return c.sendAsJson( status=1, httpStatus=200, message="SUCCESS @ featureImage" );
	}

	
	//This should extract the value from the proper scope
	//also, arguments[0] vs arguments[name] should ...
	private function scopecheck( ) {
		//url SHOULD be added, but...
		var a = StructIsEmpty(arguments) ? form : arguments;
		return a;
	}


	//A reusable registration function
	public string function insertUser() {
		var r;
		var c = getMyst(); 
		var t = trap( form, 417, [ "username", "password", "nonce" ] );
		compareNonce( form.nonce );

		//this should also be private funct
		if ( Len( form.username ) < 4 ) {
			return c.sendAsJson( status=0, httpStatus=410, message="Username needs to be a minimum of 4 characters." );
		}

		if ( Len( form.password ) < 8 ) {
			return c.sendAsJson( status=0, httpStatus=410, message="Password needs to be a minimum of 8 characters." );
		}

		//check for any users that match
		r = c.dbExec(
			datasource = getDatasource()
		, string = "SELECT * FROM #prefix#login WHERE username = :usrid"
		, bindArgs = { usrid=form.username }
		);

		if ( r.status ) {
			return c.sendAsJson( status=0, httpStatus=417, message="User #form.username# already exists." );
		}
			
		//if no one exists, add them
		r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO #prefix#login VALUES ( NULL, :usrid, :pwd )"
		, bindArgs = { usrid=form.username, pwd=encPass( form.password ) }
		);

		if ( !r.status ) {
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		}

		return c.sendAsJson( status=1, httpStatus=200, message="User #form.username# registered." );
	}


	//users - most of these serve other purposes... 
	public string function removeUser( string uid ) {
		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			uid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM #prefix#login WHERE username = :uid "
		, bindArgs = { usrid=vs.results.uid }
		);
	
		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="User #vs.results.username# registered." 
			);
		}
	} 
 
	//Comments	
	public string function removeComment( string cid ) {
		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			cid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM #prefix#comments WHERE comment_id = :cid"
		, bindArgs = { cid=vs.results.cid }
		);
	
		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="Comment #cid# deleted." 
			);
		}
	} 


	//metas
	public string function insertComment( string pid, string ctext, string owner, string oavatar ) {
		var c = getMyst();
		var vs = c.validate( form, {
		 	pid = { req = true }
		, commenttext = { req = true }
		, oavatar = { req = false, ifNone = "" }
		, owner = { req = false, ifNone = "anonymous" }
		});

		//this should be wrapped
		if ( !vs.status )
			return c.sendAsJson( status=0, httpStatus=400, message=vs.message );

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO #prefix#comments VALUES 
				( NULL, :pid, :owner, :oavatar, :ctext, :da, :dm )"
		, bindArgs = { 
				pid = { value=vs.results.pid, type="varchar" }
			, owner = { value=vs.results.owner, type="varchar" }
			, oavatar = { value=vs.results.oavatar, type="varchar" }
			, ctext = { value=vs.results.commenttext, type="varchar" }
			,	da = getCurrentDatestamp()
			,	dm = getCurrentDatestamp()
			}
		);
	
		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="Comment id '#vs.results.pid#' added to database." 
			);
		}
	} 


	/*
	insertMeta 
	----------
	Generates <meta name=$key content=$value> in succession.
	Some defaults are built-in to this component via properties, they
	are as follows:
	 - author
	 - description
	 - viewport  
	
	For the sake of minimizing aggravation, refresh should not be allowed
	here (though a user can type whatever they want in the views)
html tag title
meta name description
meta name keywords
meta name robots
meta name revisit-after
 
meta name abstract
meta name author
meta name contact
meta name copyright
meta name distribution
meta name expires
meta name generator
meta name googlebot
meta name language
meta name news keywords
meta name no email
meta name rating
meta name reply-to
meta name slurp
meta name webauthor
 
meta equiv cache-control
meta equiv content-type
meta equiv cookie
meta equiv disposition
meta equiv imagetoolbar
meta equiv ms theme
meta equiv pics-label
meta equiv pragma
meta equiv refresh
meta equiv resource type
meta equiv script-type
meta equiv style-type
meta equiv window-target
meta data Dublin Core
Meta tag Rel="nofollow"
Meta tag Rel="canonical"
Miscellaneous Meta Tags
Miscellaneous http-equiv
	*/
	public string function insertMeta( string pid, string name, string content ) {

		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			pid = { req = true }
		, name = { req = true }	
		, content = { req = true }	
		});

		//Check that the name is a supported type (according to w3, there are only 6)
		var a = [ "application-name", "author", "description", 
			"generator", "keywords", "viewport" ];

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO #prefix#metas VALUES ( NULL, :pid, :name, :content )"
		, bindArgs = { 
				pid = { value=vs.results.pid, type="varchar" }
			, name = { value=vs.results.name, type="varchar" }
			, content = { value=vs.results.content, type="varchar" }
			}
		);

		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="User #vs.results.username# registered." 
			);
		}
	} 


	public string function removeMeta( string mid ) {

		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			mid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM #prefix#metas WHERE meta_id = :mid" 
		, bindArgs = { 
				mid = { value=vs.results.mid, type="varchar" }
			}
		);

		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="User ## registered." 
			);
		}
	} 


	//keyword insertion - Generates meta name="keywords" content="..."
	public string function insertKeyword( string pid, string keyword ) {

		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			pid = { req = true }
		, keyword = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO #prefix#keywords VALUES ( NULL, :pid, :kwd )"
		, bindArgs = { 
				pid = { value=vs.results.pid, type="varchar" }
			, kwd = { value=vs.results.keyword, type="varchar" }
			}
		);

		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="Keyword '#vs.results.keyword#' added to post id '#vs.results.pid#'." 
			);
		}

	} 


	//keyword removal
	public string function removeKeyword( string kid ) {
		var c = getMyst();
		var vs = c.validate( scopecheck(), {
			kid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM #prefix#keywords WHERE keyword_id = :kid" 
		, bindArgs = { 
				kid = { value=vs.results.kid, type="varchar" }
			}
		);

		//this should be wrapped
		if ( !r.status )
			return c.sendAsJson( status=r.status, httpStatus=410, message=r.message );
		else {
			return c.sendAsJson( 
				status=1
			, httpStatus=200
			, message="Keyword '#vs.results.kid#' removed." 
			);
		}
	} 


/*
	//When initializing, always throw an instance of myst in as 
	//a dependency so I can use it's features.
	//Return the JSON reference list 
	//TODO: (converting from Query to JSON would speed you WAY up)
	public string function Reference () {
		//If the request is just for reference
		getMyst().sendAsJson(
			"savePost"= "post--save.cfm"
		,	"deletePost"= "post--remove.cfm"

		, "saveContent"= "content--add.cfm"
		, "removeContent"= "content--remove.cfm"
		//, "editMeta" = "meta--modify.cfm" 
		, "saveMeta" = "meta--add.cfm" 
		, "removeMeta" = "meta--remove.cfm" 
		//, "editComment" = "comment--add.cfm" 
		, "saveComment" = "comment--add.cfm" 
		, "removeComment" = "comment--remove.cfm" 

		, "home"="#getPublicPath( 'list.cfm' )#" 
		);	
	}
	function init(myst,model) {
		Super.init(myst);
		return this;
	}
*/
}
