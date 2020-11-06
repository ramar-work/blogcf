/* ---------------------------------------------- *
 * cms.js
 * ------ 
 *
 * Reworked cms.js to work with objects.  Much
 * easier to move around in.
 *
 * TODO:
 * - Split Util, Router and others into dewm.js
 * ---------------------------------------------- */

/* ---------------------------------------------- *
 * App{}
 *
 * The only global data structure here...
 * ---------------------------------------------- */
App = {
	baseUri : "/api/cms"
, debug : 1
,	fileKey : "lucy"
, textKey : "lucy-text"
, pid : null 
, remainingTime: 0
};



//Cancel without exception
function cancel( e ) {
	( e.preventDefault ) ? e.preventDefault() : 0;
	return false;
}


/* ---------------------------------------------- *
 * Utils()
 *
 * Initialize general utilities...
 * ---------------------------------------------- */
function Utils() {

	//Set a spot for a callback
	var Callback = function () { ; };

	//Glad this isn't a singleton...
	var xhr = new XMLHttpRequest();

	//Create an XHR request with all the gubbins (older browsers may want the fallback)
	xhr.addEventListener( "progress", function ( ev ) {
		console.log( "Sending to server", xhr.status );
	} ); 
	
	//Set timeout
	xhr.addEventListener( "timeout", function ( ev ) {
		console.log( "Request timed out" );
	} );

	//Do something as a request takes place	
	xhr.onreadystatechange = function () {
		//Updating windows and whatnot is kind of hard... a callback?
		if ( xhr.readyState == XMLHttpRequest.DONE ) {
			try {
				//If the response header is application/[json,xml], then convert it.
				var response, ctheader = xhr.getResponseHeader( "Content-Type" );
				if ( ctheader.indexOf( "application/json" ) > -1 )
					response = JSON.parse( xhr.responseText );
				else if ( ctheader.indexOf( "application/xml" ) > -1 ) 
					response = xhr.responseXml;
				else if ( ctheader.indexOf( "text/xml" ) > -1 )  
					response = xhr.responseXml;
				else {
					response = xhr.responseText;
				}

				//Call a user-supplied callback...
				Callback( response );
			}
			catch (e) {
				//TODO: Handling exceptions could be set ahead of time somehow...
				console.log( e );
			}
		}
	}

	//?
	xhr.onload = function() {
		console.log( "Request fully sent", xhr.status ); 
		console.log( xhr.responseText );
		//local.preSend( );
	}

	//Create a POST request out of an object
	var pack = function (obj) {
		var arr = [], str = "";
		for ( var k in obj ) {
			arr.push( [k, encodeURI( obj[k] )].join("=") );
		}
		return arr.join( "&" );
	}

	//Create a multipart request out of an objects
	var binpack = function( obj ) {
		var str = "--" + boundary + "\r\n" +
					'Content-Disposition: form-data; name="'+obj.key+'"'; 

		if ( obj.file ) {
			str += '; filename="' + obj.file + '"'; 
		}

		str += '\r\nContent-Type: ' + obj.mimetype +  '\r\n\r\n';
		str += obj.value + '\r\n';	
		return str;
	}

	//Random string
	var randStr = function( length ) {
		var alphaStr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var rS="";

		function getRandomInt(min, max) {
			return Math.floor(Math.random() * (max - min)) + min;
		}

		for (n=0; n < length; n++) {
			rS += alphaStr[ getRandomInt(0, alphaStr.length) ];
		}

		return rS;
	}

	//A dummy function 
	var zer_ = function ( ) { 0; }

	//This should run one time and be all we need
	const boundary = "------------------" + randStr( 32 );

	return {

		//random string
		randStr : randStr,

		//return values from a selector (no traversal)
		values: function ( selector ) {
			return [].slice.call( document.querySelectorAll( selector ) );
		},

	
		//printf
		printf: function ( srcstr ) {
			if ( arguments.length > 1 ) {
				for ( var i = 1; i < arguments.length; i ++ ) {
					srcstr = srcstr.replace( "$" + i, arguments[ i ] );
				}
			}
			return srcstr;
		},


		//get values from a selector
		extract: function ( selector, loaded, extra ) {
			//Define some holding spots.
			var tv={}, av={}, mv=[]; 

			//if selector is an array, then loop through these
			//Get all the values
			if ( selector )	{
				//mv=[].slice.call( document.querySelectorAll( st.selector ) );
				var v = [].slice.call(document.querySelectorAll( selector ));
				for ( var i=0; i<v.length; i++ ) {
					mv.push( v[i] );
				}
			}

			/*
			//loaded selector assumes the dev ran querySelectorAll elsewhere
			if ( loaded ) {
				for ( var v in st.loadedSelector ) {
					//mv = st.loadedSelector;
					mv.push( v );
				}
			}

			//TODO: Check if 'name', 'value' and 'type' are valid keys
			//TODO: Also check the type of 'rawText'...
			if ( extra )
				mv.push( extra );
			*/

			//Get all the additional values
			//tmp = [].slice.call( document.querySelectorAll('.addl input') );
			//tmp.forEach( function (el) { mv.push( el ) } );
			//if ( st.extra ) st.extra.forEach( function (el) { mv.push( el ); } );

			//This simple loop is used to ensure I catch ALL form values, 
			//be they checkboxes or radios or not
			for ( var i=0; i < mv.length; i++ ) { 
				var fName = mv[ i ].name ;
				var ftype = mv[ i ].type.toLowerCase();

				//Make sure to track the value of ALL form input types
				if ( ["radio","checkbox","select-multiple"].indexOf( ftype ) == -1 )
					av[ fName ] = mv[i].value;
				else { 
					//Get values and add it to the list of values
					if ( !tv[ fName ] ) {
						tv[ fName ] = true;
						var ivals = [];
						var sel = ( ftype != "select-multiple" ) ? "input[name=" + fName + "]" : "select[name=" + fName + "] option"; 
						[].slice.call( document.querySelectorAll( sel + ":checked" ) )
							.forEach( function(el) { ivals.push( el.value ) } );
						av[ fName ] = ( ivals.length > 1 ) ? ivals : ivals[ 0 ]; 
						if ( ftype == "checkbox" ) { 
							av[fName] = !av[fName] ? false : ( av[fName] == "on" ) ? true : av[fName];
						}
					}
				}
			}
			return av;
		},

		//Cancel without exception
		cancel: function ( e ) {
			( e.preventDefault ) ? e.preventDefault() : 0;
			return false;
		},


		//
		get: function ( addr, callback ) {
			( callback ) ? Callback = callback : 0;
			xhr.open( "GET", addr, true );
			xhr.send();
			//callback would need to be passed in...	
		},

		//
		post: function ( addr, data, callback ) {
			if ( !data ) {
				console.log( "No data specified for POST request." );
				return;
			}	
			( callback ) ? Callback = callback : 0;
			xhr.open( "POST", addr, true );
			xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
			( App.debug ) ? console.log( "Sending: " + Debug().peel( data ) ) : 0;
			xhr.send( pack(data) );
		},

		put: function ( addr, data, callback ) {
			if ( !data ) {
				console.log( "No data specified for PUT request." );
				return;
			}
			( callback ) ? Callback = callback : 0;
			xhr.open( "PUT", addr, true );
			xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
			( App.debug ) ? console.log( "Sending: " + Debug().peel( data ) ) : 0;
			xhr.send( pack(data) );
		},

		patch: function ( addr, data, callback ) {
			if ( !data ) {
				console.log( "No data specified for PATCH request." );
				return;
			}	
			( callback ) ? Callback = callback : 0;
			xhr.open( "PATCH", addr, true );
			xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
			( App.debug ) ? console.log( "Sending: " + Debug().peel( data ) ) : 0;
			xhr.send( pack(data) );
		},

		mppost: function ( addr, data, callback ) {
			//console.log( "Multipart POSTing to " + addr );
			var req = "";
			if ( !data ) {
				console.log( "No data specified for POST request." );
				return;
			}
			( callback ) ? Callback = callback : 0;
			( App.debug ) ? console.log( "Sending: " + Debug().peel( data ) ) : 0;
			xhr.open( "POST", addr, true );
			xhr.setRequestHeader( 
				"Content-Type", "multipart/form-data; boundary=" + boundary );
			for ( var d of data ) {
				req += binpack( d );	
			}
			req += "--" + boundary + "--";
			xhr.send( req );
		},


		"delete": function ( addr, callback ) {
			( callback ) ? Callback = callback : 0;
			xhr.open( "DELETE", addr, true );
			xhr.send();
		},


		head: function ( addr, callback ) {
			( callback ) ? Callback = callback : 0;
			xhr.open( "HEAD", addr, true );
			xhr.send();
		},

		//Send values back to a server, based on a selector
		sendValsOverXhr: function ( st ) {
			//Define some holding spots.
			var tv={}, av=[], mv=[]; 

			//if selector is an array, then loop through these
			//Get all the values
			if ( st.selector )	{
				//mv=[].slice.call( document.querySelectorAll( st.selector ) );
				var v = [].slice.call(document.querySelectorAll( st.selector ));
				for ( var i=0; i<v.length; i++ ) {
					mv.push( v[i] );
				}
			}

			//loaded selector assumes the dev ran querySelectorAll elsewhere
			if ( st.loadedSelector ) {
				for ( var v in st.loadedSelector ) {
					//mv = st.loadedSelector;
					mv.push( v );
				}
			}

			//TODO: Check if 'name', 'value' and 'type' are valid keys
			//TODO: Also check the type of 'rawText'...
			if ( st.rawText ) {
				mv.push( st.rawText );
			}


			//Get all the additional values
			//tmp = [].slice.call( document.querySelectorAll('.addl input') );
			//tmp.forEach( function (el) { mv.push( el ) } );
			if ( st.extra ) {
				st.extra.forEach( function (el) { mv.push( el ); } );
			}

			//This simple loop is used to ensure I catch ALL form values, 
			//be they checkboxes or radios or not
			for (var i=0; i < mv.length; i++) { 
				var fName = mv[ i ].name ;
				var ftype = mv[ i ].type.toLowerCase();

				//Make sure to track the value of ALL form input types
				if ( [ "radio", "checkbox", "select-multiple" ].indexOf( ftype ) == -1 )
					av.push( fName + '=' + mv[i].value );
				else { 
					//Get values and add it to the list of values
					if ( !tv[ fName ] ) {
						tv[ fName ] = true;
						var ivals = [];
						var sel = ( ftype != "select-multiple" ) ? "input[name=" + fName + "]" : "select[name=" + fName + "] option"; 
						var abc = [].slice.call( document.querySelectorAll( sel + ":checked" ) );
						abc.forEach( function(el) { ivals.push( el.value ) } );
						av.push( fName + '=' + ivals.join( ',' ) ); 
					}
				}
			}

			//Join and make a payload
			var Vals = av.join( '&' ); 
			( cmsDebug ) ? console.log( Vals ) : 0;
			//( cmsDebug ) ? console.log( st.sendTo ) : 0;

			//Make XHR to server and you're done
			var x = new XMLHttpRequest();
			x.onreadystatechange = ( st.callback ) ? st.callback : function ( evt ) { 
				if ( this.readyState == 1 )
					console.log( evt, 'at ready state 1' );	
				if ( this.readyState == 2 )
					console.log( evt, 'at ready state 2' );	
				if ( this.readyState == 3 )
					console.log( evt, 'at ready state 3' );	
				if ( this.readyState == 4 ) {
					console.log( evt, x.responseText );
				}
			}

			//...
			x.open( ( st.method ) ? st.method : 'POST', st.sendTo, false );
			x.setRequestHeader( 'Content-Type', 
				(st.multipart) ? "multipart/form-data" : 'application/x-www-form-urlencoded' );
			x.send(Vals);
		},


		/*
		//This allows arguments to be bound to event handler
		Function.prototype.bindToEventHandler = function bindToEventHandler() {
			var handler = this;
			var boundParameters = Array.prototype.slice.call( arguments );
			
			return function (e)
			{
				e = e || window.event;
				boundParameters.unshift( e );
				handler.apply( this, boundParameters );
			}
		}
		*/
	}
}




/* ---------------------------------------------- *
 * Config()
 *
 * Initialize the app's initial configuration.
 * ---------------------------------------------- */
function Config() {

	//Properties for configuration...
	var api;
	var gar;

	//You can request endpoints here, this way you don't have to hardcode things...
	return function ( aEndpoint, deferred ) {
		var async = 0;

		if ( !aEndpoint ) {
			(cmsDebug ) ? console.log( "Endpoint not specified." ) : 0;
			return;
		}

		aEndpoint = aEndpoint.match(/.*\//)[0];
		( cmsDebug ) ? console.log( aEndpoint ) : 0;

		//Create an XHR request to request JSON data. 
		var j; 
		var local = {};
		local.xhr = new XMLHttpRequest();
		local.xhr.onreadystatechange = function () {
			( cmsDebug ) ? console.log( "Running statechange at getConfigData()" ) : 0;
			if ( local.xhr.readyState == XMLHttpRequest.DONE ) {
				console.log( local.xhr.responseText );
				( cmsDebug ) ? console.log( "Async request recvd: " + local.xhr.responseText ) : 0;
				deferred( JSON.parse( local.xhr.responseText ) );
				try {
					( cmsDebug ) ? console.log( local.xhr.responseText ) : 0;
					API = JSON.parse( local.xhr.responseText ).reference;
	console.log( API );
				}
				catch (e) {
					( cmsDebug ) ? console.log( "could not set up cms.js" ) : 0;
					return;
				}
			( cmsDebug ) ? console.log( endpoint ) : 0;
			}
		}
		
		//Make a request to the API endpoint that gives us direction 
		var nEndpoint = "/cms/api";
		( cmsDebug ) ? console.log( nEndpoint ) : 0;
		local.xhr.open( "GET", nEndpoint, true );
		local.xhr.send();
		
		//Sometimes, I seem to have async problems... dunno why
		if ( false ) {
			( cmsDebug ) ? console.log( "Non-async request recvd: " + local.xhr.responseText ) : 0;
			var vp = JSON.parse( local.xhr.responseText );
			var root = "/api/cms";
	console.log( vp );
	return;
			//recreate all relative API endpoints with the root 
			for ( var x in vp ) {
				//console.log( vp[x][0] );
				if ( vp[x][0] != "/" ) {
					vp[x] = [root, "/", vp[x]].join( "" );
				}
			}
			( cmsDebug ) ? console.log( vp.root ) : 0;
			vp.root = root;
			//console.log( vp );
			deferred( vp );
		} 
	}
}


/* ---------------------------------------------- *
 * Screen()
 *
 * Initialize all of the effects that have nothing
 * todo with content...
 * ---------------------------------------------- */
function Screen() {

	//All of these can be properties...
	var status;
	var drop;
	var parent_id;
	var list;
	var getId;
	var butt;

	return {
		//Do fade things...
		fade : function() {
			//Automate a fade effect on each refresh
			var op = 0.0; 
			getId[ 0 ].style.opacity = 0.0;	
			opa = window.setInterval( function () { 
				getId[0].style.opacity = ( op += 0.02 ); 
				if ( op >= 1 ) clearInterval( opa );
			}, 5 ); 
		},

		//Create a box
		box : function() {
			console.log( "Generate a box..." );
		},

		//Deal with all things related to the status bar
		status : {
			//Update the status box with a message
			update: function ( text ) {
				var status = document.getElementById( "status" );
				var newFile = document.createElement("div");
				newFile.innerHTML = text;
				status.appendChild( newFile );
			}
		},

		init : function () {
			//add something
			var collapsers = [].slice.call( document.querySelectorAll(".container-section--collapse") );
			for ( var i=0; i<collapsers.length; i++ ) {
				console.log( collapsers[i] );
				collapsers[i].addEventListener( "click", function(ev) {
		console.log(ev);
					this.classList.toggle( "container-section--collapsed" );
					//console.log( ev.target.parentElement );//.classList.toggle( "js-min" );
					//console.log( ev.target.parentElement.nextSibling.nextSibling );//.classList.toggle( "js-min" );
					this.parentElement.nextSibling.nextSibling.classList.toggle("js-min"); 
				});
			}

		/*
			//this allows people to edit things
			var regs = [].slice.call( document.querySelectorAll(".content-regular") );
			for ( var i=0; i<regs.length; i++ ) {
				regs[i].addEventListener( "click", modWindow );
			}
		*/
			//this allows people to edit things
			var dels = [].slice.call( document.querySelectorAll(".delete") );
			for ( var i=0; i<dels.length; i++ ) {
				dels[i].addEventListener( "click", deleteNode );
			}

			//this allows people to delete posts
			var dx = [].slice.call( document.querySelectorAll(".admin-delete") );
			for ( var i=0; i<dx.length; i++ ) {
				dx[i].addEventListener( "click", deletePost );
			}

			//this allows people to edit things
			var edls = [].slice.call( document.querySelectorAll(".edit") );
			for ( var i=0; i<edls.length; i++ ) {
				edls[i].addEventListener( "click", editNode );
			}

			return false;
		}
	}
}



/* ---------------------------------------------- *
 * CBox()
 *
 * Initialize the content drop box
 * ---------------------------------------------- */
function CBox( NodeUtils ) {
	//All content originally went here.
	var contents = [];

	//Post utilities went here
	var node = NodeUtils;

	//Screen is needed here...
	var screen = Screen();
	
	//The order of content
	var index = 0;

	const audioUnsupportedDefault = "Your browser does not support embedded HTML5 audio";

	const videoUnsupportedDefault = "Your browser does not support embedded HTML5 video";

	const fadeInterval = 0.05;

	const textBoxMinSize = 200;

	const textBoxMaxSize = 400;

	const textBoxIncrementor = 15;

	//initialize all your other crap ahead of time...
	return {
		transform : function( e ) {
			e.preventDefault();

			//Long way
			var ta = document.createElement( "textarea" );
			var tt  = this;
			this.appendChild( ta );

			//This new element is kind of here... but I guess I can just add a child...
			console.log( this.children[ 0 ] );
			var ne = this.children[ 0 ];

			//Disable further clicks
			drop.removeEventListener( "click", this.transform );

			//Handle focus off
			ne.addEventListener( "blur", function ( e ) {
				//Append whatever the user typed to the content stream
				var newDiv = document.createElement( "div" );	
				newDiv.className = "js-stub";
				newDiv.innerHTML = ne.value;
				list.appendChild( newDiv );

/*
				//Add to the global array
				gar[ ctr++ ] = {
					len: ne.value.length
				,	type: "text/html"
				,	name: "random content blob"
				,	content: ne.value
				}
*/

				//Send it immediately after sending
				if ( ne.value.length > 0 ) { 
					node.create( {
						content: ne.value
						/*mimetype:    "text/html",*/
					, type: "text"
					, index: index++
					, pid: App.pid 
					} );
				}

				//Reset size of box and remove element
				drop.removeChild( this );
				drop.style.height = "200px";

				//Add the listener again	
				drop.addEventListener( "click", this.transform ); 
			});

			//Handle focus on
			ne.addEventListener( "focus", function ( e ) {
				var va, size = textBoxMinSize;
				ta.style.fontSize = "2em";
				ta.style.zIndex = "99";
				ta.style.width = "100%";
				ne.style.border = "1px solid #ccc";
				ne.style.marginBottom = "10px";
				//ta.style.height = ( size += inc - 1 ) + "px";
				tt.style.height = "380px";

				//Set the animation from here for no particularly good reason
				va = window.setInterval( function ( ee ) {
					tt.style.height = ( size += textBoxIncrementor ) + "px";//"400px";
					ta.style.height = ( size += textBoxIncrementor - 1 ) + "px";
					if ( size >= textBoxMaxSize ) {
						clearInterval( va );
						return;
					}
				}	, 10 );
			});
			
			//Set focus here (and give the user a visual cue)
			ne.focus();
			return false;
		},

		//spawn
		spawn : function ( e ) {
			(e = e || window.event).preventDefault();
			var dt = e.dataTransfer;
			var files = dt.files;

			for ( var i=0; i < files.length; i++ ) {
				var reader, ff = files[ i ];

				//Add a listener for tracking upload progress
				(reader = new FileReader()).addEventListener( "loadend", ( function( file ) { 
					return function ( e ) {
						var bin, newDiv, media, mtype, nd, etc = 0;
						bin = this.result;
					
						//Add a new entry to the "status" bar...
						screen.status.update( "Loaded: " + file.name + file.size + " bytes of type: " + file.type );
	
						//Save to server
						node.create({ content: bin, name: file.name, type: file.type, index: index++, pid: App.pid });

						//Let's get creative with this.  It's an event as far as I know...
						(newDiv = document.createElement( "div" )).className = "js-stub";
					
						//create 3 divs and assign class names
						for ( var easy, divs=[], i=0; i < (easy = [ "config", "maximize", "remove" ]).length; i++ ) {
							( divs[i] = document.createElement("div") ).className = easy[i];
							newDiv.appendChild( divs[i] );
						}	

						//We can figure out mimetype here...
						if ( (mtype = file.type.replace( /\/.*/, '' )) == "image" )
							media = document.createElement( "img" ), media.file = file, media.src = bin;
						else if ( mtype == "audio" )
							media = document.createElement( "audio" ), media.controls = true, media.innerHTML = audioUnsupportedDefault;
						else if ( mtype == "video" )
							media = document.createElement( "video" ), media.controls = true, media.innerHTML = videoUnsupportedDefault;
						else {
							media = document.createElement( "img" );
						}
						
						//Add the new media
						media.file = file, 
						media.src = bin;
						newDiv.appendChild( media );
						list.appendChild( newDiv );	

						//Animate
						nd = window.setInterval( function () {
							newDiv.style.opacity = ( etc += fadeInterval );
							if ( etc >= 1 ) {
								clearInterval( nd );	
								return;
							}
						}, textBoxIncrementor );
					} 
				})( ff ) );

				//When this is done, send to server
				reader.readAsDataURL( ff );
				//reader.readAsArrayBuffer( file );
			}
			return false;
		}
	}
}



/* ---------------------------------------------- *
 * Post()
 *
 * Initialize all of the items that have to do 
 * with a Post...
 * ---------------------------------------------- */
function Post() {

	//Post data is saved to this endpoint
	const api = { 
		create : "/cms/api/post/create"
	,	"delete" : "/cms/api/post/delete"
	,	update : "/cms/api/post/update"
	};

	//The selectors used to extract values
	const selectors = ".input-group input, .input-group select";

	const redir = "/cms/posts";

	return {
		create : function () {
			Utils().post( api.create, { title: '' }, function (a) {
				a.status ? App.pid.set( a.id ) : 0; 
			});
			return true;
		},

		edit : function () {

		},

		remove : function () {
			Utils().post( api.delete, { id: this.id }, function (a) {
				console.log( a );
			});	
return;
			console.log( this.id );
			
			sendValsOverXhr({ 
				rawText: { value: this.id, name: "post_id", type: "text" }
			, sendTo: API.deletePost
			, callback: function (arg) {
					var x = arg.target;
					if ( x.readyState == 4 )  {
						try {
							var a = JSON.parse( x.responseText );
							console.log(a);
						}
						catch (e) {
							console.log( e );
						}
					}
					//this.remove();
				}
			} );	
		},

	  update: function( content ) {
			var values = Utils().extract( ".input-group input, .input-group select" );
			values.parent_id = App.pid.get();
			Utils().put( api.update + "/" + values.parent_id, values, function (a) { 
				if ( a.status ) {
					//TODO: A redirect can take place here... maybe
					console.log( "Post successfully updated." );
					App.pid.delete();
					window.location.href = redir;
				}	
			});
			return true;
		}
	};
}



/* ---------------------------------------------- *
 * Node()
 *
 * Initialize all of the items that have to do 
 * managing nodes...
 * ---------------------------------------------- */
function Node() {

	//Node data is saved to this endpoint
	const api = {
		create : "/cms/api/node/create"
	, remove : "/cms/api/node/delete"
	, update : "/cms/api/node/update"
	};

	//Initialize the parent ID of each of these nodes with this
	var getPid = function () { 
		return App.pid.get(); 
	};

	return {

		edit : function () {
			//Translate whatever content into a box...
			console.log( api.update );
		},

		remove : function () {
			var node = this.parentElement.parentElement;
			( App.debug ) ? console.log( node ) : 0;
			( App.debug ) ? console.log( node.id ) : 0;
			Utils().post( api.remove, { parent_id: getPid(), node_id: node.id }, function (a) {
				( a.status ) ? console.log( a ) : 0;	
			}); 		
		},

		create : function ( content ) {
			//Check that content was served
			if ( !content.content ) {
				console.log( "Content to stream into postback was not specified." ); 
				return; 
			}

			//This needs to now be indexed differently
			//var lv = local.lv[ local.lvIndex++ ] = { value : "", size : 0, reader: null };
			var obj = [];
			obj.push( { key: "order", value: content.index, mimetype: "text/html" } );
			obj.push( { key: "parent_id", value: getPid(), mimetype: "text/html" } );

			//Check if the content is a dataURI here (crude for now)
			if ( content.content.indexOf( "data:" ) == -1 )
				obj.push( { key: App.textKey, value: content.content, mimetype: "text/html" } );
			else {
				obj.push( { 	
					key: App.fileKey 
				, file: content.name
				, value: content.content.substr( content.content.indexOf( "," ) + 1 )
				, mimetype: content.type
				} );
			}
console.log(obj);
			Utils().mppost( api.create, obj, function (a) {
				( a.status ) ? console.log( a ) : 0;
			} );
		}
	}
}


/* ---------------------------------------------- *
 * User()
 *
 * Handler user info and profile...
 * ---------------------------------------------- */
function User() {
	return {
		administer: function ( action ) { 
			var b;
			document.addEventListener("DOMContentLoaded", function (ev) {
				if ( !( b = [].slice.call( document.querySelectorAll( ".login-box button" ) )[0]) ) 
					return;
				//(( ".login-box button" ) || Z )).addEventListener( "click", function(ev) {
				b.addEventListener( "click", function(evv) {
					evv.preventDefault();
					sendValsOverXhr({
						selector: ".login-box-input input"
					, sendTo: action
					, callback: function (arg) {
							var x = arg.target;
							if ( x.readyState == 4 )  {
								try {
									var a = JSON.parse( x.responseText );
									//console.log( a );
									//the component should give a lot of config details
									//after successful stuff, we go to the main page...
									if ( a.httpStatus == 200 && a.status ) {
										//apply the style and hope things hide...
										document.getElementById("login-container").classList.toggle( "js-minimize" );
										setTimeout( function (ev) { window.location.replace( API.home ); }, 1000 );
									}
									else {

									}
								}
								catch( e ) {
									//console.log( x.responseText );
									//console.log( e );
								}
							}
						} 
					});
					return false;
				});
			});
		}
	};
}


/* ---------------------------------------------- *
 * Debug()
 *
 * Initialize windows and methods for debugging.
 * ---------------------------------------------- */
function Debug() {
	const className = "debug";

	return {
	
		//Generate a new window	
		newWindow: function () {
			var win = document.createElement( "div" );
		},

		//"Peel" back an object like layers of an onion
		peel: function( d ) {
			var arr = [];
			for ( var dd in d ) {
				arr.push( dd ); 
			}
			return arr;
		}
	}
}



/* ---------------------------------------------- *
 * Debug()
 *
 * Primitives for dealing with the parent id
 * ---------------------------------------------- */
function Pid() {
	//We'll use local storage for now, but if it changes, then...
	const storage = localStorage;

	//Keep the pid stored here...	
	var pid = storage.getItem( "parent_id" );

	return {
		"get": function () {
			return ( pid = storage.getItem( "parent_id" ) );
		},

		"set": function ( id ) {
			storage.setItem( "parent_id", id );
			pid = id;
		},

		"delete": function () {
			storage.removeItem( "parent_id" );
			pid = null;
		}
	}
}


/* ---------------------------------------------- *
 * Router()
 *
 * Deal with routes
 * ---------------------------------------------- */
function Router (config) {

	//let the user know what happened if there wasn't anything...	
	if ( !( "routes" in config ) ) {
		console.log( "'routes' not in supplied configuration." );	
		return
	}

	var routes = config.routes;
	var ctx = config.context || {};

	//Needs another super... call both pre and post and whatnot...
	return {
		//Routes should probably be injected somehow...
		simple: function () {
			if ( location.pathname in routes ) {
				routes[ location.pathname ]( ctx );
			}
		},

		//Partial
		partial: function () {
			for ( var rr in routes ) {
				var ind = -1;
				if ( ( ind = location.pathname.indexOf( rr ) ) > -1 ) {
					//console.log(location.pathname.substring(0, rr.length))
					routes[ location.pathname.substring(0, rr.length ) ]( ctx );
				}
			}
		},

		//Regex
		regex: function () {
			( "Pre" in routes ) && routes.Pre( ctx );
			for ( var rr in routes ) {
				try {
					//Compile first, rhen call
					var x = (new RegExp( rr )).exec( location.pathname );
					//if there is more than one match, you need to find the longest one
					if ( x && ( x[0] == x.input ) ) {
						console.log( x ); 
						console.log( "Router found a match against: ", rr );
						( "MatchedPre" in routes ) && routes.MatchedPre( ctx );
						ctx.matched = x[0];
						console.log( ctx );
						routes[ rr ]( ctx );	 //Might need to try catch this...	
						( "MatchedPost" in routes ) && routes.MatchedPost( ctx );
					}
				}
				catch(e) {
					console.log( e );
				}
			}
			( "Post" in routes ) && routes.Post( ctx );
		}
	}
}



//Category generator
function catdog() {
	const uri = "/cms/api/category/retrieve/";
	//uri + id;
	Utils().get( uri + App.pid.get(), (a) => console.log(a) );
}


/* ---------------------------------------------- *
 * Routes()
 *
 * Set the routes
 * ---------------------------------------------- */
function Routes( routes ) {
	//do global inits first...

	//set a pre
	function pre() {
		//Check if we can use FileReader or not...
		if ( !window.FileReader ) {
			console.log( "Your browser does not support HTML5 FileReader API" );
			return;
		}

		//Add a hook for XHR open(?)
		//xhr.beforeParse( (a) => ( "status" in a ) );

		//Let's see what's in localStorge, specifically the last loaded post
		console.log( Pid().get() );
	}

	//and a post
	function post() {
		//...
	}

	//no-op
	function noop() { console.log( "I do nothing." ); }

	//then finally execute the routes
	return {
		Pre : pre,
		Post : post,
		MatchedPre : noop,
		MatchedPost : noop,


		"/cms/posts" : function (arg) {
			Pid().delete();
			const admin = ".admin-delete";
			const api_delete = "/cms/api/post/delete";
	
			for ( var i=0, d=Utils().values( admin ); i < d.length; i++ ) {
				d[i].addEventListener( "click", Post().remove );
			}
		},


		"/cms/login" : function (arg) {
			//Always get rid of the last post ID
			Pid().delete();
	
			//Submit button is hijacked to send a preliminary check
			document.querySelector( "form" ).addEventListener( "submit", function (ev) {
				var l = document.querySelector( "form" );
				const wrong = "login-wrong";
				ev.preventDefault();
				var status, p = { 
					username: l.querySelector( "input[name=username]" ).value
				, password: l.querySelector( "input[name=password]" ).value 
				}; 

				function applyWrong( element ) {
					element.classList.add( wrong );
					setTimeout( function() { element.classList.remove( wrong ); }, 500 );	
				}

				Utils().post( "/cms/api/check", p, function (a) {
					( a.status ) ? l.submit() : applyWrong( l ) }); 
				//Utils().post( "/cms/api/check", p, (a) => ... );
				return false;
			});
		},


		"/cms/posts/new|/cms/posts/edit/.*" : function (arg) {
			
			const post_create = "/cms/api/post/create";
			const keyword_create = "/cms/api/keyword/create";
			const keyword_delete = "/cms/api/keyword/delete";
			const drop = document.getElementById( "drop" );
			const node = new Node();
			const box = new CBox( node );

			//apply a listener...
			function listener( aa ) {
				if ( aa.key == "Tab" ) {
					var v = { parent_id: App.pid.get(), name: aa.currentTarget.value };
					Utils().post( keyword_create, v, function (a) {
						( a.status ) ? aa.currentTarget.value = "" : 0;
					});
				}
			}

			drop.addEventListener( "drop", box.spawn );
			drop.addEventListener( "click", box.transform );
			drop.addEventListener( "dragover", cancel );
			drop.addEventListener( "dragenter", cancel );

			//Check context and set the active id from here (in case something odd happens)
			if ( arg.matched.match( "edit" ) && !(App.pid = new Pid()).get() )
				App.pid.set( arg.active );
			else {
				var t = { title: '' };
				if ( !(App.pid = new Pid()).get() ) {
					Utils().post( post_create, t, (a) => App.pid.set( a.status ? a.id : 0 ) );	
				}
			}

			//Try overwriting String.prototype	
			//"#post-submit".click( Post().update );  //boi, that would be sweet...	
			document.getElementById( "post-submit" )
				.addEventListener( "click", function (a) { Post().update(); });

			for ( var i=0, d=Utils().values( ".delete" ); i<d.length; i++ )
				d[i].addEventListener( "click", node.remove );

			//this allows people to edit things
			for ( var i=0, e=Utils().values( ".edit" ); i<e.length; i++ ) {
				e[i].addEventListener( "click", node.edit );
			}

			//On categories, do something
			const cat = "input[name=category]";
			document.querySelector(cat).addEventListener( "keydown", function( aa ) {
				const uri = "/cms/api/category/retrieve/" + App.pid.get();
				Utils().get( uri, (a) => console.log(a) );
			});

			//Do tabbing of keys
			const kw = "input[name=keyword]";
			document.querySelector(kw).addEventListener( "keydown", function( aa ) {
				if ( aa.key == "Tab" ) {
					var input = aa.currentTarget;
					var div = input.nextSibling.nextSibling;
					var v = { parent_id: App.pid.get(), name: input.value };
					Utils().post( keyword_create, v, function (a) {
						if ( a.status ) {
							li = document.createElement( "li" );
							li.innerHTML = v.name;
							li.id = a.id;
							div.appendChild( li );
							input.value = "";
							li.addEventListener( "click", function (ev) {
								Utils().post( keyword_delete, { id: a.id }, function(a) {
									console.log(a);
								});
							});
						}
					});
				}
			});
		},
	}
}



/* ---------------------------------------------- *
 * main()
 *
 * ...
 * ---------------------------------------------- */
function main( api ) {
	//Create a list of routes and run them on that?
}


document.addEventListener( "DOMContentLoaded", function ( ev ) {
	new Router( { 
		routes: new Routes()
	, context: {
			active: location.pathname.split("/")[ location.pathname.split("/").length - 1 ]
		}
	}).regex();
	return;
});
