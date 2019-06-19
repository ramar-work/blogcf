/* 
----------------------------------------
cms.cfc

This is a management system that runs
via ColdFusion/Lucee.
----------------------------------------
*/
component 
accessors=true
name="cms"
extends="Base"
{
	//A password to stop random people from adding users.
	property name="nonce" default="somePassword";

	//How to store authentication details 
	property name="authStorage" default="db"; //cookie, session and other options exist...

	//A salt
	property name="salt" default="juicem4in";

	//The type of datasource in use (mysql/postgres will allow different things than MSsql)
	property name="sourceType" default="";

	//..
	property name="postCount" default=5;

	//..
	property name="endpoint" default="cms";

	//The name of a binary post field
	property name="fieldName" default="lucy";

	//The name of the text field.
	property name="fieldText" default="lucy-text";

	//...
	property name="dbPrefix" default="cms";

	//...
	property name="dbTable" default="cms";

	//...
	property name="contentIdType" default="varchar"; //can also be varchar or alphanum

	//A spot for the Myst object.
	property name="mask" default="YYYY-MM-dd HH:nn:ss";

	//The title of our stupid component thing.
	property name="adminTitle" default="mystCMS"; 

	//
	property name="cssFilelist" default="zero,core,list-li,list-table";

	//
	property name="js" default="core,list-li,list-table";

	//Different content type constants
	property name="constOctetStream" default=1;
	property name="constText" default=2;
	property name="constAudio" default=3;
	property name="constImage" default=4;
	property name="constVideo" default=5;
	property name="constMessage" default=6;
	property name="constApplication" default=7;

	//Return a generated numeric ID 
	public string function genContentId( ) {
		return "#getMyst().randNum(10)#";
	}

	//Return a generated string
	public string function getRandomString( ) {
		return "#getMyst().randStr(32)#";
	}

	/*
	//Return the full asset path w/o using link()	
	public string function getAssetPath( required String type, required String file ) {
		return "#getMyst().getUrlBase()#assets/#arguments.type#/#getEndpoint()#/#arguments.file#";
	}

	//Return the path to what should be an endpoint.
	public string function getPublicPath( required String file ) {
		return "#getMyst().getUrlBase()##getNamespace()#/#arguments.file#";
	}
	
	//Return the path to what should be an endpoint.
	public string function getPrivatePath( required String file ) {
		return "#getMyst().getUrlBase()#files/#getEndpoint()#/#arguments.file#";
	}
	*/

	//...
	public string function getCssImagePath( Required string img ) {
		return "background-image:url( #getAssetPath('img',img)# ); background-size: 100%;";	
	}

	//Private date string... for no particular reason...
	private function getCurrentDatestamp( string mask ) {
		var myMask = StructKeyExists( arguments,"mask" ) ? mask : getMask();
		return { value = DateTimeFormat( Now(), myMask ), type="timestamp" };
	}

	//Check the scope for parameters, fail if not there...	
	//This is a way to solve this, though not quite ideal.
	private void function trap ( Required scope, Required Numeric hStatus, Array keys ) {
		for ( var n=1; n<ArrayLen(keys); n++ ) {
			if ( !StructKeyExists( scope, keys[n] ) || keys[n] eq "" ) {
				getMyst().sendAsJson( 
					status=0
			  , httpStatus=arguments.hStatus
				, message="Key '#keys[n]#' is required but not specified." 
				);
			}
		}
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
	private string function encPass( required string pwd ) {
		return hash( "#pwd##getSalt()#", "SHA-384", "UTF-8", 1000 );
	}

	//Handle authentication
	public string function authorize () {
		var c = getMyst(); var r;
		trap( form, 401, [ "username", "password" ] ); 	
		r = c.dbExec(
			datasource = getDatasource()
		, string = "SELECT * FROM login WHERE login_usr = :usrid AND login_pwd = :pwd"
		, bindArgs = { usrid=form.username, pwd=encPass( form.password ) }
		);
		if ( !r.status ) {
			return c.sendAsJson( status=r.status, httpStatus=401, message=r.message );
		}
		//add to session (since this is over JS, I"m not sure that this works...)
		return c.sendAsJson( status=1, httpStatus=200, message=r.message );
	}

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
	private query function _qExecute( Required string, bindArgs ) {
		var c = getMyst();
		var r = c.dbExec(
			datasource = getDatasource()
	  ,	string = arguments.string
		, bindArgs = ( StructKeyExists(arguments,"bindArgs") ) ? bindArgs : {}
		);

		return ( r.status ) ? r.results : _qGetColumns( arguments.table );
	}

	//Retrieve all the posts.
	public query function qGetAllPosts() {
		return _qExecute(
	   	string = "
			SELECT * FROM
				( SELECT * FROM cms_post ) AS p
			INNER JOIN
				( SELECT * FROM cms_post_metadata ) AS m
			ON p.post_long_id = m.pmd_postmatch_id
			ORDER BY post_date_added DESC
			"
		, table = "post"
		);
	}

	//Retrieve all the posts.
	public query function qGetPublishedPosts() {
		return _qExecute(
	   	string = "
			SELECT * FROM
				( SELECT * FROM cms_post ) AS p
			INNER JOIN
				( SELECT * FROM cms_post_metadata WHERE pmd_isdraft = 0 ) AS m
			ON p.post_long_id = m.pmd_postmatch_id
			ORDER BY post_date_added DESC
			"
		, table = "post"
		);
	}

	//Retrieve all categories
	public query function qGetCategories() {
		return _qExecute(
	   	string = "SELECT * FROM cms_category"
		, table = "post"
		);
	}


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
				( SELECT * FROM cms_post ) AS ap
				INNER JOIN
				( SELECT * FROM cms_post_metadata WHERE pmd_isdraft = 0 ) AS pm
				ON ap.post_long_id = pm.pmd_postmatch_id
			) as p
			INNER JOIN
				( SELECT * FROM cms_content WHERE content_order < :sumcount ) as c
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
		var pid; var plid;
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
					( SELECT * FROM cms_post WHERE post_id = :pid OR post_long_id = :plid ) AS ap
					INNER JOIN
					( SELECT * FROM cms_post_metadata ) AS pm
					ON ap.post_long_id = pm.pmd_postmatch_id
				) as p
			INNER JOIN
				( SELECT * FROM cms_content ) as c
			ON p.post_long_id	= c.content_postmatch_id
			ORDER BY p.post_id, c.content_order ASC 
			"
		, bindArgs = { 
				pid = pid
			, plid = plid
			}
		);

		if ( !r.status ) {
			writedump(r);
			//return c.sendAsJson( status=r.status, httpStatus=500, message="#r.message#" );
			return QueryNew("a,b","varchar,varchar");
		}
		return r.results;
	}


	//Insert Meta 
	public string function qInsertMeta ( ) {
		var c = getMyst();
		var vs = c.cmValidate( form, {
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
		var vs = c.cmValidate( form, {
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
		var vs = c.cmValidate( form, {
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

	//Delete post
	public string function qDeletePost( ) {
		//Remove the post and all the content
		var c = getMyst();
		var vs = c.cmValidate( form, {
			post_id = { req = true }
		});

		var d = c.dbExec(
			string = 'DELETE FROM cms_content WHERE content_postmatch_id = :pid'
		, datasource = getDatasource()
		, bindArgs = { pid = vs.results.post_id }
		);

		if ( !d.status ) {
			return c.sendAsJson( status=d.status, httpStatus=500, message=d.message );
		}
		
		d = c.dbExec(
			string = 'DELETE FROM cms_post WHERE post_long_id = :pid'
		, datasource = getDatasource()
		, bindArgs = { pid = vs.results.post_id }
		);

		if ( !d.status ) {
			return c.sendAsJson( status=d.status, httpStatus=500, message=d.message );
		}

		return c.sendAsJson( status=1, httpStatus=200, message="SUCCESS @ DeletePost" );
	}
	
	//Insert post
	public string function qInsertPost( ) {
		var c = getMyst();
		var vs = c.cmValidate( form, {
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

		//Make the insert
		var r = c.dbExec(
			datasource = getDatasource()
		,	string = "INSERT INTO cms_post VALUES ( NULL,:plong_id,:pname,:ptype,:pda,:pdm )"
		, bindArgs = {
				//pid = { value=getRandomString(), type="varchar" }
			 	plong_id = { value=vs.results.parent_id, type="varchar" }
			,	pname = { value=vs.results.title, type="varchar" }
			,	ptype = { value=0, type="integer" }
			,	pda = getCurrentDatestamp()
			,	pdm = getCurrentDatestamp()
			,	draft = { value=vs.results.draft, type = "bit" }
			}
		);

		if ( !r.status ) {
			return c.sendAsJson( status=r.status, httpStatus=500, message="#r.message#" );
		}

		//Make the insert
		r = c.dbExec(
			datasource = getDatasource()
		,	string = "INSERT INTO cms_post_metadata VALUES (
				NULL
			,	:plong_id
			, :draft
			, :footer
			, :previewimg
			, :comments
			)"
		, bindArgs = {
			 	plong_id = { value=vs.results.parent_id, type="varchar" }
			,	draft = { value=vs.results.draft, type = "bit" }
			,	footer = { value=vs.results.footer, type = "bit" }
			,	previewimg = { value=vs.results.previewimg, type = "bit" }
			,	comments = { value=vs.results.comments, type = "bit" }
/*
			,	footer = { value=0, type = "bit" }
			,	previewimg = { value=0, type = "bit" }
			,	comments = { value=0, type = "bit" }
*/
			}
		);

		if ( !r.status ) {
			return c.sendAsJson( status=r.status, httpStatus=500, message="#r.message#" );
		}

		return c.sendAsJson( status=1, httpStatus=200, message="Everything is successful." );
	}


	//Adds content node
	//TODO: Hopefully, it's a little easier to see how you can actually bypass model files completely.
	//save = { insertNode( ... ) }
	public string function qInsertNode( ) {
		var c = getMyst();
		var ft = getFieldtext();
		var fn = getFieldName();
		//The index of these mimetypes will tell a lot about what type of media is here.
		var t = [ "application", "text", "audio","image","video","message" ];

		//Make sure that at least these fields are here.
		var vStruct = { //c.cmValidate( form, {
			order = { req = true }
		, parent_id = { req = true }
		};

		//For the submitted field, make a distinction between text and binary
		if ( StructKeyExists( form, ft ) )
			vStruct[ ft ] = { req = true };
		else if ( StructKeyExists( form, fn ) ) {
			vStruct[ fn ] = { req = true, file = true };
		}

		//Validate
		var vs = c.cmValidate( form, vStruct );

		//Die if things are missing.
		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, message=vs.message );
		}

		//Have to do some things first...
		//This ought to be a method call
		var mimes = createObject("component","std.components.mimes").init();
		var mm = "text/html";
		var contentTypeConstant = getConstText();
		var writeableCont;
		//var ab="";
		//Fork again, and... 
		if ( StructKeyExists( form, ft ) )
			writeableCont = vs.results[ ft ];
		else if ( StructKeyExists( form, fn ) ) {
			//Figure out mimetype and extension
			var xy = vs.results[ fn ];
			var serverExt = xy.serverfileext;
			var extension = serverExt;
			if ( StructKeyExists( mimes, serverExt ) ) {
				mm = mimes[ serverExt ];
				//var contentMainType = REReplace(mm,"/[a-z]*","");
				var contentMainType = Left( mm, Find( "/", mm ) - 1 );  
				for ( var ij=1; ij <= ArrayLen(t); ij++ ) {
					//ab=ListAppend(ab,"#contentMainType# => #t[ij]#" );
					if ( contentMainType eq t[ij] ) {
						contentTypeConstant = ij; 
						break;
					}
				}
			} 

			//Read content in and write it to a random file...
			try {
				var contents = FileRead( xy.fullpath );
				var bc = BinaryDecode( contents, "Base64" );
				var fpath = c.getConstantMap()["files"];
				var rndFilename = c.randStr( 32 ) & "." & extension;
				//TODO: Writing to memory is the best option, this is stupid...
				if ( 0 ) 
					0;
				else {
					//Write new file and delete the original afterwards...
					FileWrite( "#fpath#/#rndFilename#", bc );
					FileDelete( xy.fullpath );
				}
				writeableCont = rndFilename;
			}
			catch ( any e ) {
				return c.sendAsJson( 
					status=0
				, httpStatus=500
				, exception=e
				, message="Failed to write stream to file."
				);
			}
			
			/*
			return c.sendAsJson(
				filename = writeableCont
			, cttest = ab 
			, originalFile = xy.fullpath
			, ctconst = contentTypeConstant
			, newFile = "#fpath#/#rndFilename#"
			, mimelong= mm	
			);
			*/
		}

		//This writes to the content table
		vs = c.dbExec(
			string = "INSERT INTO cms_content VALUES ( :cid,:pid,:ctype,:ctfull,NULL,:oid,:file,:da,:dm )"
		, datasource = getDatasource()
		, bindArgs = {
			//TODO: the sqltype doesn't have to be specified if I know it's going to be varchar
				cid    = { value = getRandomString(), type = "varchar" }
			,	ctype  = { value = contentTypeConstant, type = "integer" }
			,	ctfull = { value = mm, type = "varchar" }
			,	ctencoding = { value = 0, type = "varchar" }
			,	oid    = { value = vs.results.order, type = "varchar" }
			,	pid    = { value = vs.results.parent_id, type = "varchar" }
			,	file   = { value = writeableCont, type = "varchar" }
			,	da     = getCurrentDatestamp()
			,	dm     = getCurrentDatestamp()
			}
		);

		//Die if the write was unsuccessful.
		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, httpStatus=500, message=vs.message );
		}

		//This is just here as a test...
		return c.sendAsJson( status=1, httpStatus=200, message="Everything is successful." );
	}


	//Retrieve posts by some custom filter.
	public string function deleteNode( ) {
		var c = getMyst();
		var vs = c.cmValidate( form, {
			node_id = { req = true }
		});

		if ( !vs.status ) {
			return c.sendAsJson( status=vs.status, httpStatus=500, message=vs.message );
		}

		var vv = c.dbExec( 
			string = "DELETE FROM cms_content WHERE content_id = :cid"
		, bindArgs = { cid = vs.results.node_id }
		, datasource = getDatasource()
		); 

		if ( !vv.status ) 
			return c.sendAsJson( status=vv.status, httpStatus=500, message=vv.message );
		else {
			return c.sendAsJson( status=1, httpStatus=200, message="Everything is successful." );
		}
	}


	//Updates content node
	public string function updateNode( node_id ) {
		var c = getMyst();
		var vs = c.cmValidate( form, {
			{ node_id = { req = true } }
		});

		var vv = c.dbExec( 
			string = "UPDATE cms_content SET content_id = :cid WHERE xid = :ixd"
		, bindArgs = { cid = vs.results.node_id }
		, datasource = getDatasource()
		); 

		if ( !vv.status ) 
			return c.sendAsJson( status=vv.status, httpStatus=500, message=vv.message );
		else {
			return c.sendAsJson( status=1, httpStatus=200, message="Everything is successful." );
		}
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
		var c = getMyst(); var r;
		trap( form, 417, [ "username", "password", "nonce" ] ); 	
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
		, string = "SELECT * FROM cms_login WHERE username = :usrid"
		, bindArgs = { usrid=form.username }
		);

		if ( r.status ) {
			return c.sendAsJson( status=0, httpStatus=417, message="User #form.username# already exists." );
		}
			
		//if no one exists, add them
		r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO cms_login VALUES ( NULL, :usrid, :pwd )"
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
		var vs = c.cmValidate( scopecheck(), {
			uid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM cms_login WHERE username = :uid "
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
		var vs = c.cmValidate( scopecheck(), {
			cid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM cms_comments WHERE comment_id = :cid"
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
		var vs = c.cmValidate( form, {
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
		, string = "INSERT INTO cms_comments VALUES 
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
		var vs = c.cmValidate( scopecheck(), {
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
		, string = "INSERT INTO cms_metas VALUES ( NULL, :pid, :name, :content )"
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
		var vs = c.cmValidate( scopecheck(), {
			mid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM cms_metas WHERE meta_id = :mid" 
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
		var vs = c.cmValidate( scopecheck(), {
			pid = { req = true }
		, keyword = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "INSERT INTO cms_keywords VALUES ( NULL, :pid, :kwd )"
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
		var vs = c.cmValidate( scopecheck(), {
			kid = { req = true }
		});

		//removal... can kind of be wrapped...
		var r = c.dbExec(
			datasource = getDatasource()
		, string = "DELETE FROM cms_keywords WHERE keyword_id = :kid" 
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

	//Retrieve posts by some custom filter.
	public query function qGetCustomPosts() {
		var c = getMyst();
	}

	/*
	//When initializing, always throw an instance of myst in as 
	//a dependency so I can use it's features.
	function init( mystObject ) {
		setMyst( mystObject );
		return this;
	}
	*/

	

	//Return the JSON reference list 
	//TODO: (converting from Query to JSON would speed you WAY up)
	public string function reference () {
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
}
