/*
cmstest.cfc


*/
component extends="cms" accessors=true {

	property name="datasource" default="rcdb";
	property name="randcount" default=24;
	property name="myst"; 

	//Give me random bytes, copy b/c I don't want to init myst
	private function rando() {
		// make an array instead, and join it...
		var str="abcdefghijklmnoqrstuvwxyzABCDEFGHIJKLMNOQRSTUVWXYZ0123456789";
		var tr="";
		for ( var x=1; x<getRandcount()+1; x++) tr = tr & Mid(str, RandRange(1, len(str) - 1), 1);
		return tr;
	}

	private string function makedate() {
		return DateTimeFormat( Now(), "YYYY-MM-dd HH:mm:SS" );
	}

	//Load lorem ipsum, b/c no way in hell am I writing all of this... 
	private function text ( Required colString ) {

	}

	//Write this b/c writing tests is annoying
	private query function datainit ( Required colString, copyTemplate, Array keys ) {
		//This won't always exist.
		var cp = arguments.copyTemplate;

		//Analyze the list, and create columns
		var t = { 
			len=ListLen(colString)
		, types=""
		, srcArray=ListToArray(colString)
		};

		var qv = [];
		//Create types
		for ( var i=1; i <= t.len; i++ )
			t.types = ListAppend( t.types, "varchar" );

		//Move through the array set and turn them into structs
		for ( var i=1; i <= ArrayLen(keys); i++ ) {
			var innerCount=1;
			var vp = {};
			for ( var x in t.srcArray ) {
				if ( StructKeyExists( copyTemplate, x ) )
					vp[ x ] = copyTemplate[ x ]();
				else {
					vp[ x ] = keys[ i ][ innerCount++ ];
				}			
			}
			ArrayAppend( qv, vp );
		}

		//Finally, create a query...
		var p = QueryNew( colString, t.types, qv );
		return p;
	}

//just run and return a status...
public function dummy() {
	return 1;
}

	//Pass in form scope and an instantiated object
	public function init( mystObject, formScope ) {

		setMyst(mystObject);
		//Don't let API calls die immediately, (for testing purposes)
		mystObject.setApiAutodie( false );
		var twork="";
	
		try {
			//I can't do anything with these yet...
			var groups = datainit( "groupname,username", {}, [
				 [ "washed up bandmates", "tooty" ]
				,[ "The Avengers", "richard001,antonio446" ]
				,[ "bandmates", "tooty" ]
			]);

			//Notice how we'll only add the REQUIRED fields for the request to be successful...
			var users = datainit( 'username,password,nonce', { nonce=function() { return "somePassword"; }} , [
				  [ "tooty", encPass( getRandomString(20) ) ]
				, [ "richard001", encPass( getRandomString(20) ) ]
				, [ "antonio446", encPass( getRandomString(20) ) ]
				, [ "SAM'", encPass( getRandomString(20) ) ]
			]);

			var posts = datainit( "parent_id,title,draft", {}, [
					 [ "aaaaaaaaaaaaaaaa", "This post has a name", 0 ]
				  ,[ "bbbbbbbbbbbbbbbb", "This post has a name", 1 ]
					,[ "cccccccccccccccc", "This post has a name", 0 ]
					,[ "dddddddddddddddd", "This post has a name", 0 ]
					,[ "eeeeeeeeeeeeeeee", "This post has a name", 0 ]
					,[ "ffffffffffffffff", "This post has a name", 0 ]
					,[ "gggggggggggggggg", "This post has a name", 0 ]
					,[ "hhhhhhhhhhhhhhhh", "This post has a name", 0 ]
					,[ "iiiiiiiiiiiiiiii", "This post has a name", 0 ]
					,[ "jjjjjjjjjjjjjjjj", "This post has a name", 0 ]
					,[ "kkkkkkkkkkkkkkkk", "This post has a name", 0 ]
					,[ "llllllllllllllll", "This post has a name", 0 ]
			]); 
			
			//This does not yet address binary.  I can base64 encode and send though, which is cool...
			var content = datainit( "parent_id,order,lucy", {}, [
				 [ "aaaaaaaaaaaaaaaa", 0, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 1, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 2, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 3, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 4, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 5, "So much content in one place, I just can't stand it." ]
				,[ "aaaaaaaaaaaaaaaa", 6, "So much content in one place, I just can't stand it." ]

				,[ "bbbbbbbbbbbbbbbb", 0, "So much content in one place, I just can't stand it." ]
				,[ "bbbbbbbbbbbbbbbb", 1, "So much content in one place, I just can't stand it." ]
				,[ "bbbbbbbbbbbbbbbb", 2, "So much content in one place, I just can't stand it." ]

				,[ "cccccccccccccccc", 0, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 1, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 2, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 3, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 4, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 5, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 6, "So much content in one place, I just can't stand it." ]
				,[ "cccccccccccccccc", 7, "So much content in one place, I just can't stand it." ]

				,[ "dddddddddddddddd", 0, "So much content in one place, I just can't stand it." ]
				,[ "dddddddddddddddd", 1, "So much content in one place, I just can't stand it." ]
				,[ "dddddddddddddddd", 2, "So much content in one place, I just can't stand it." ]

				,[ "eeeeeeeeeeeeeeee", 0, "So much content in one place, I just can't stand it." ]

				,[ "ffffffffffffffff", 0, "So much content in one place, I just can't stand it." ]
				,[ "ffffffffffffffff", 1, "So much content in one place, I just can't stand it." ]
				,[ "ffffffffffffffff", 2, "So much content in one place, I just can't stand it." ]

				,[ "gggggggggggggggg", 0, "So much content in one place, I just can't stand it." ]
				,[ "gggggggggggggggg", 1, "So much content in one place, I just can't stand it." ]

				,[ "hhhhhhhhhhhhhhhh", 0, "So much content in one place, I just can't stand it." ]
				,[ "hhhhhhhhhhhhhhhh", 1, "So much content in one place, I just can't stand it." ]
				,[ "hhhhhhhhhhhhhhhh", 2, "So much content in one place, I just can't stand it." ]
				,[ "hhhhhhhhhhhhhhhh", 3, "So much content in one place, I just can't stand it." ]
				,[ "hhhhhhhhhhhhhhhh", 4, "So much content in one place, I just can't stand it." ]

				,[ "iiiiiiiiiiiiiiii", 0, "So much content in one place, I just can't stand it." ]
				,[ "iiiiiiiiiiiiiiii", 1, "So much content in one place, I just can't stand it." ]
				,[ "iiiiiiiiiiiiiiii", 2, "So much content in one place, I just can't stand it." ]

				,[ "jjjjjjjjjjjjjjjj", 0, "So much content in one place, I just can't stand it." ]
				,[ "jjjjjjjjjjjjjjjj", 1, "So much content in one place, I just can't stand it." ]

				,[ "kkkkkkkkkkkkkkkk", 0, "So much content in one place, I just can't stand it." ]
				,[ "kkkkkkkkkkkkkkkk", 1, "So much content in one place, I just can't stand it." ]
				,[ "kkkkkkkkkkkkkkkk", 2, "So much content in one place, I just can't stand it." ]

				,[ "llllllllllllllll", 0, "So much content in one place, I just can't stand it." ]
			]);

			//add a bunch of scattered comments... 
			var comments = datainit( "parent_id,cowner,cavatar,ctext", {}, [
					[ 1, "", "", "You suck" ]
				, [ 1, "", "", "I do think this is a valuable look on things.  Let's look at this another time." ]
				, [ 1, "", "", "This isn't what you should have stated..." ]
				, [ 1, "", "", "I don't think this comment is worth my time." ]
				, [ 1, "", "", "comment text" ]
				, [ 1, "", "", "askjsda;fkjsdfsad random spammy comment" ]
				, [ 1, "", "", "This is a comment." ]
				, [ 1, "", "", "This is another comment." ]
				, [ 1, "", "", "This is yet another comment." ]
			]);

			//add two galleries (composed of images)

			//add a bunch of scattered captions... 

			//add a store (composed of images, costs, and whatnot)

			//...
			var loop = [
				{ exec = register, query = users } 
			, { exec = qInsertPost, query = posts } 
			/*
			, { exec = 0, query = groups } 
			, { exec = 0, query = comments } 
			, { exec = 0, query = galleries } 
			, { exec = 0, query = captions } 
			, { exec = 0, query = store } 
			*/
			];

			//now move through each group and add the data
			twork &= "<table>";
			for ( var ll in loop ) {
				//loop through the query and insert all variables into scope 'form'
				for ( var q in ll.query ) {
					twork &= "<tr>";
					for ( var qq in q ) formScope[ qq ] = q[qq];
					var a = DeserializeJSON( ll.exec( formScope ) );
					for ( var y in a ) {
						twork &= "<td>#y#</td>"; 
						twork &= "<td>#a[y]#</td>";
					}
					//formScope = {};
					twork &= "</tr>";
				}	
				twork &= "</table>";
			}
			writeoutput("load successful.");
		}
		catch (any e) {
			writeoutput("load unsuccessful.");
			writedump(e);
		}

		writeoutput(twork);
		abort;
	}

}
