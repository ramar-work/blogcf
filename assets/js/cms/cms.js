/*cms.js*/
const cmsDebug = 1;
const fileKey = "lucy"; /*The backend code expects a hard-coded field name (for now)*/
const textKey = "lucy-text"; /*The backend code expects a hard-coded field name (for now)*/
//more global variables b/c this is badly designed :)
var status   ,    /*Status area of GUI*/
		drop     ,    /*Drag and drop zone of GUI*/
	  parent_id,    /*Parent ID of current post/content item*/
		list     ,    /*List of GUI*/
		getId    ,    /*ID of main container*/
		butt     ,    /*ID of a submit button, most likely*/
		post     ,    /*Spot to initialize PostUtils*/
		ctr = 0  ,    /*A global counter that was here in the previous version*/
		index = 0,    /*Index */
		endpoint = 0,    /*Index */
		API,    /*Spot for API JSON cloud...*/
		gar = [] ;    /*A global array for content values that was here in the previous version*/


//delete post
function deletePost () {
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
}


//delete node
function deleteNode () {
	var node = this.parentElement.parentElement;
	(cmsDebug) ? console.log( node ) : 0;
	(cmsDebug) ? console.log( node.id ) : 0;
	
	sendValsOverXhr({ 
		rawText: { value: node.id, name: "node_id", type: "text" }
	, sendTo: API.removeContent
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
			node.remove();
		}
	} );	
}


//edit node
function editNode ( ) {

}


//Cancel without exception
function cancel( e ) {
	( e.preventDefault ) ? e.preventDefault() : 0;
	return false;
}


//Change a content block when editing.
//Add some windows and some styles...
function modWindow ( ev ) {

	// - "activate" the div by clicking
	// - you can initialize and show a mini-menu, depending
	// 	on what content type is there (only the part before the '/')
	// - "deactivate" by clicking something in the mini-menu
	// 	close, minimize, remove, and of course html... 
	// - this is a little harder too, because each thing has its own
	//  controls.  theoretically...
	//   I guess JSON can be used to populate, but does it come from the component?
	//   this seems heavy.  Another way maybe base64 payloads, but... 

	//console.log( this.tagName );
	//change 'this'
	this.classList.toggle( "content-active" );	
	var child = this.nextSibling.nextSibling;
	//console.log( child );

	if ( child.tagName == "p" ) {
		//Load the details into a JSON structure...
		// - image path, text, formatting details...
	}

	/*
	var d = document.createElement( "div" );
	d.className = "content-shroud";
	document.body.appendChild( d );
	*/
	return false;
}



//Authorize / add users
function administerUser ( action ) { 
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


//Add this custom handler function for the last part...
function addEventHandler( obj, evt, handler ) {
	if ( obj.addEventListener )
		obj.addEventListener( evt, handler, false );
	else if ( obj.attachEvent )
		obj.attachEvent( "on" + evt, handler );
	else {
		obj[ "on" + evt ] = handler;
	}
}



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
};



//Generate a random string for removal and addition.
function randStr ( length ) {
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



//Loops through all elements in the "list" div and sends them as one big thing
//This first iteration puts a new element in each, that
//way you don't have to fight to get this to work...
function loopAdd ( arr ) {
	//...
	var local = {};
	var l     = document.getElementById( "list" );	
	var len   = l.children.length;

	//Create two strings for boundaries
	var innerB = randStr( 16 );
	/*; = boundary between keys and values*/
	var outerB = randStr( 16 );

	//Get reference to the form
	var d = document.getElementById( arr.id );

	//Create an element and add it to the form to be submitted (perhaps, that is an arg).
	//This will keep all of the metadata
	var c = document.createElement( "input" );
	c.name = arr.field;
	c.type = "text";

	//
	var title = document.getElementById( "tit" ); 

	//Serialize some JSON here and make it the value
	c.value = "{\"totalLoop\": " + len + ", \"title\": \"" + title.value + "\" }";
	//console.log( c.value );
	d.appendChild( c );

	//Loop through and add each node to this structure.
	for ( var x = 0; x < len; x ++ ) {
		//Create a new form element
		var n = document.createElement( "input" );
		n.name = arr.field + "-" + x;
		n.type = "text";
		//All binary files are split at the first comma
		n.value = gar[ x ].content; 
		//Append the child.
		d.appendChild( n );
	}

	//Will this submit the form?
	d.submit();	
}



//Turns the content drop box into a content-editable style field
function transformBox ( e ) {
	e.preventDefault();

	//Long way
	var ta = document.createElement( "textarea" );
	var tt  = this;
	this.appendChild( ta );

	//This new element is kind of here... but I guess I can just add a child...
	console.log( this.children[ 0 ] );
	var ne = this.children[ 0 ];

	//Disable further clicks
	drop.removeEventListener( "click", transformBox );

	//Handle focus off
	ne.addEventListener( "blur", function ( e ) {
		//Append whatever the user typed to the content stream
		var newDiv = document.createElement( "div" );	
		newDiv.className = "js-stub";
		newDiv.innerHTML = ne.value;
		list.appendChild( newDiv );

		//Add to the global array
		gar[ ctr++ ] = {
			len: ne.value.length
		,	type: "text/html"
		,	name: "random content blob"
		,	content: ne.value
		}

		//Send it immediately after sending
		if ( ne.value.length > 0 ) { 
			post.save( {
				content: ne.value
				/*mimetype:    "text/html",*/
			, type:    "text"
			, index:   index++
			, pid:     parent_id 
			} );
		}

		//Reset size of box and remove element
		drop.removeChild( this );
		drop.style.height = "200px";

		//Add the listener again	
		drop.addEventListener( "click", transformBox ); 
	});


	//Handle focus on
	ne.addEventListener( "focus", function ( e ) {
		const min = 200,
					max = 400,
					inc =  15;
		var va, size = min;

		//...
		ta.style.fontSize = "2em";
		ta.style.zIndex = "99";
		ta.style.width = "100%";
		ne.style.border = "1px solid #ccc";
		ne.style.marginBottom = "10px";
		//ta.style.height = ( size += inc - 1 ) + "px";
		tt.style.height = "380px";

		//Set the animation from here for no particularly good reason
		va = window.setInterval( function ( ee ) {
			tt.style.height = ( size += inc ) + "px";//"400px";
			ta.style.height = ( size += inc - 1 ) + "px";
			if ( size >= max ) {
				clearInterval( va );
				return;
			}
		}	, 10 );
	});
	
	//Set focus here (and give the user a visual cue)
	ne.focus();
	return false;
}


//Update the status box with a message
function updateStatus ( text ) {
	var status = document.getElementById( "status" );
	var newFile = document.createElement("div");
	newFile.innerHTML = text;
	status.appendChild( newFile );
}


//Enable drop zone and add stuff to content preview div
function boxLogic ( e ) {
	e = e || window.event;
	e.preventDefault();

	var dt = e.dataTransfer;
	var files = dt.files;

	for ( var i=0; i < files.length; i++ ) {
		var file = files[ i ];
		var reader = new FileReader();

		//Add a listener for tracking upload progress
		addEventHandler( reader, "loadend", function ( e, file ) {
			var bin = this.result;
		
			//Add a new entry to the "status" bar...
			updateStatus( "Loaded: " + file.name + file.size + " bytes of type: " + file.type );

			//Add a new entry here for stuff
			gar[ ctr++ ] = {
				len: file.size,
				name: file.name,
				type: file.type,
				content: bin
			};

			//Save to server
			post.save( {
				content: bin,
				/*mimetype:    "text/html",*/
				//type:    "file",
				name:    file.name,
				type:    file.type,
				index:   index++,
				pid:     parent_id 
			} );


			//Let's get creative with this.  It's an event as far as I know...
			//You can make it load slow and blink
			const ii = 0.05;
			var newDiv, media, mtype, nd, etc = 0;
			(newDiv = document.createElement( "div" )).className = "js-stub";
		
			//create 3 divs and assign class names
			var easy=[ "config", "maximize", "remove" ];
			var divs=[];
			for ( var i=0; i<easy.length; i++ ) {
				( divs[i] = document.createElement("div") ).className = easy[i];
				newDiv.appendChild( divs[i] );
			}	
			

			//We can figure out mimetype here...
			if ( (mtype = file.type.replace( /\/.*/, '' )) == "image" ) {
				//This has to support other mimetypes
				media = document.createElement( "img" ), media.file = file, media.src = bin;
				/*
				media.style.width = "50%";
				media.style.position = "relative";
				media.style.left = "25%";
				*/
			}
			else if ( mtype == "audio" ) {
				media = document.createElement( "audio" ), 
				media.controls = true,
				media.innerHTML = "Your browser does not support embedded HTML5 audio",
				media.file = file, 
				media.src = bin;
			}
			else if ( mtype == "video" ) {
				media = document.createElement( "video" ), 
				media.controls = true,
				media.innerHTML = "Your browser does not support embedded HTML5 video",
				media.file = file, 
				media.src = bin;
			}
			else {
				//???
				media = document.createElement( "img" ), media.file = file, media.src = bin;
			}
			
			//Add the new media
			newDiv.appendChild( media );
			list.appendChild( newDiv );	
			console.log( "Load end is done" );

			//Animate
			nd = window.setInterval( function () {
				newDiv.style.opacity = ( etc += ii );
				if ( etc >= 1 ) {
					clearInterval( nd );	
					return;
				}
			}, 15 );
		}.bindToEventHandler( file ));

		//When this is done, send to server
		reader.readAsDataURL( file );
		//reader.readAsArrayBuffer( file );
	}

	return false;
}


//Get parent id field, be careful
function getParentId ( ) {
	parent_id = document.getElementById( "parent_id" ).value;
	return parent_id;
}


//Utilities to wrap content in a multipart format for submittal 
function PostUtils (config) {
	//Defines
	function zer_ ( ) { 0; }
	var local = {};
	local.lv = [];
	local.lvIndex = 0;
	local.preSend = !config.presend ? zer_ : config.presend;
	local.postSend = !config.postsend ? zer_ : config.postsend;
	local.pid = 0; 

	//If this were multipart, you'd need to create all of this
	local.request = {};
	local.request.location = "POST";

	//Check if we can use FileReader or not...
	if ( !window.FileReader ) {
		console.log( "Your browser does not support HTML5 FileReader API" );
		return;
	}
	
	//Create an XHR request with all the gubbins (older browsers may want the fallback)
	(local.xhr = new XMLHttpRequest()).addEventListener( "progress", function ( ev ) {
		//Query the object here...
		console.log( "SENDING TO SERVER", local.xhr.status );
		console.log( "still sending..." );
	} ); 
	
	//Set timeout
	local.xhr.addEventListener( "timeout", function ( ev ) {
		console.log( "request timed out" );
	} );


	//Do something as a request takes place	
	local.xhr.onreadystatechange = function ( ) {
		//Updating windows and whatnot is kind of hard... a callback?
		console.log( "running statechange" );	

		if ( local.xhr.readyState == XMLHttpRequest.DONE && local.xhr.status == 200 ) {
			console.log( local.lv );
		}
	}

	//?
	local.xhr.onload = function() {
		console.log( "REQUEST FULLY SENT", local.xhr.status ); 
		console.log( local.xhr.responseText );
		local.preSend( );
	}

	//....
	local.address = !config.address ? "/" : config.address;
	local.boundary = "------------------" + randStr( 32 );

	function pkg( obj ) {
		var str;
		str = "--" + local.boundary + "\r\n" +
					'Content-Disposition: form-data; name="'+obj.key+'"'; 

		if ( obj.file ) {
			str += '; filename="' + obj.file + '"'; 
		}

		str += '\r\nContent-Type: ' + obj.mimetype +  '\r\n\r\n';
		str += obj.value + '\r\n';	
		return str;
	}

	return {
		/*contains: { index, pid, content, presend, postsend, address/location }*/
		save: function ( cont ) {
			//Check that content was served
			if ( !cont.content ) {
				console.log( "Content to stream into postback was not specified." ); 
				return; 
			} 

			//Open the request and start talking to the server
			(cmsDebug) ? console.log( local.address ) : 0;
			local.xhr.open( "POST", local.address, true );
			local.xhr.setRequestHeader( 
				"Content-Type", "multipart/form-data; boundary=" + local.boundary );

			//This needs to now be indexed differently
			var lv = local.lv[ local.lvIndex++ ] = { value : "", size : 0, reader: null };
			var v = "";
			var obj = [];
			obj[ 0 ]=	{key: "order", value: cont.index++, mimetype: "text/html" };
			obj[ 1 ]= {key: "parent_id", value: getParentId(), mimetype: "text/html" };

			//Check if the content is a dataURI here (crude for now)
			console.log( cont.content.indexOf( "data:" ) );
			if ( cont.content.indexOf( "data:" ) == -1 )
				obj[ 2 ] = { key: textKey, value: cont.content, mimetype: "text/html" };
			else {
				//Decode to regular binary (or string?)
				var b64St = cont.content.indexOf( "," ) + 1;
				var b64En = cont.content.substr( b64St );
				var b64Dc = window.atob( b64En ); 

				//???
				obj[ 2 ] = { 	
					key: fileKey 
			//,	file: "cheese.jpg",
				, file: cont.name
			//, value: b64Dc, 
				, value: b64En
			//, mimetype: "image/jpeg" 
				, mimetype: cont.type
				};
			}

			//Pack all of the keys
			for ( k=0; k<obj.length; k++ )
				v += pkg( obj[ k ] );

			//Append the finalizer
			v += "--" + local.boundary + "--";
			console.log( v );
			local.xhr.send( v );
		}
	};
}


//Send values back to a server, in anothe rway
function sendOverXhr( st ) {
	//obviously, this is not quite the same as the other function
	//you'll only be able to update one node at a time and right now 
	//it has to be the entire node (which will get heavy on roundtrip 
	//times and bandwidth)

	//do multipart later...	you need to worry about regular values...


	return;
}


//Send values back to a server, based on a selector
function sendValsOverXhr( st ) {
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
		if ( ["radio","checkbox","select-multiple"].indexOf( ftype ) == -1 )
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
}


//You can request endpoints here, this way you don't have to hardcode things...
function getConfigData( aEndpoint, deferred ) {
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
	/*
	local.xhr.onreadystatechange = function () {
		( cmsDebug ) ? console.log( "Running statechange at getConfigData()" ) : 0;
		if ( local.xhr.readyState == XMLHttpRequest.DONE ) {
			console.log( local.xhr.responseText );
			( cmsDebug ) ? console.log( "Async request recvd: " + local.xhr.responseText ) : 0;
			deferred( JSON.parse( local.xhr.responseText ) );
			try {
				( cmsDebug ) ? console.log( local.xhr.responseText ) : 0;
				API = JSON.parse( local.xhr.responseText );//).endpoint;
			}
			catch (e) {
				( cmsDebug ) ? console.log( "could not set up cms.js" ) : 0;
				return;
			}
		( cmsDebug ) ? console.log( endpoint ) : 0;
		}
	}
	*/
	
	//Make a request to the API endpoint that gives us direction 
	var nEndpoint = "/api/cms/reference.cfm";
	( cmsDebug ) ? console.log( nEndpoint ) : 0;
	local.xhr.open( "GET", nEndpoint, async );
	local.xhr.send();
	
	//Sometimes, I seem to have async problems... dunno why
	if ( !async ) {
		( cmsDebug ) ? console.log( "Non-async request recvd: " + local.xhr.responseText ) : 0;
		var vp = JSON.parse( local.xhr.responseText );
		var root = "/api/cms";
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


//A slightly better way to organize this...
function main( api ) {
	//Define element references here.
	status = document.getElementById( "status" );
	drop   = document.getElementById( "drop" );
	list   = document.getElementById( "list" );
	getId  = document.getElementsByClassName( "container" );
	parser = window.location;
	API    = api;
	( cmsDebug ) ? console.log( "main() is using: " ) : 0;
	( cmsDebug ) ? console.log( API ) : 0;

	//Get the JSON data from our CF component
	//TODO: This has to run first

	//Initialize PostUtils
	post = PostUtils( { address: API.saveContent } ); 

	//Stop if the container is not there for some reason...
	if ( !getId.length ) {
		return;
	}

	//Automate a fade effect on each refresh
	var op = 0.0; 
	getId[ 0 ].style.opacity = 0.0;	
	opa = window.setInterval( function () { 
		getId[0].style.opacity = ( op += 0.02 ); 
		if ( op >= 1 ) clearInterval( opa );
	}, 5 ); 

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

	//...
	if ( parser.pathname.indexOf("new") > -1 || parser.pathname.indexOf("edit") > -1 ) {
		//Add a listener to some button so I can see how it works...
		( butt = document.getElementById( "post-submit" )).addEventListener( "click", function (e) {
			e.preventDefault();
			(cmsDebug) ? console.log( "submitting post content to: " + API.savePost ) : 0;

			//why is the form global?
			//you can just assemble a POST (or PUT) request from the client and save data that way...
			var xhr = new XMLHttpRequest();

			//Get all of these values and put them together...
			//var a = [].slice.call( document.querySelectorAll( "input.input-member, select.input-member" ) );	
			//console.log( a );

			//This should return something..., but if async, I guess it can't...
			sendValsOverXhr({ 
				selector: "input.input-member, select.input-member" 
			, sendTo: API.savePost
			, callback: function (arg) {
					var x = arg.target;
					if ( x.readyState == 4 )  {
						var a;
						try {
							a = JSON.parse( x.responseText );
							console.log( a );
							if ( a.status && a.httpStatus == 200 ) {
								window.location.replace( API.home ); 
								return;
							}
						}
						catch (e) {
							//if not successful, log here and die
							console.log( x.responseText );
							console.log( e );
							return;
						}
						console.log( a );
						return;
					}
					return;
				}
			} );	
		});
	}

	//Please seperate this somehow
	if ( !window.FileReader ) {
		document.getElementById( "status" ).innerHTML = 
			"Your browser does not support HTML5 FileReader API";
	}
	else {
		if ( parser.pathname.indexOf("new") > -1 || parser.pathname.indexOf("edit") > -1 ) {
			//Enables d&d on the drop field
			drop.addEventListener( "dragover", cancel );
			drop.addEventListener( "dragenter", cancel );
			drop.addEventListener( "click", transformBox ); 

			//Files are loaded to browser mem here
			drop.addEventListener( "drop", boxLogic );
		}
	}
}


//A successful method for dragging and dropping files from the desktop...
document.addEventListener( "DOMContentLoaded", function ( ev ) {

	//Because I have to rely on this call, I do this...
	getConfigData( location.pathname, main );

});
