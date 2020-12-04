/* ---------------------------------------------------------
 * index.js
 * --------
 * This contains all the Javascript for my portfolio page.
 * 
 * TODO
 * Could use a real router.  Not to mention a real library.
 *
 * CHANGELOG
 * 12/04/20 - Completely reworked the home page. 
 *          - Removed bad endpoints.
 * --------------------------------------------------------- */

/*
function ugly_quick_popup( cb ) {
	var node, shadenode, span, xout;
	shadenode = document.createElement( "div" );
	shadenode.className = "js-popup-underlay";
	shadenode.style.top = "0px";
	shadenode.style.left = "0px";
	shadenode.style.zIndex = "999";

	//Generate the 'X' to close the window
	span = document.createElement( "span" );
	span.className = "js-popup--close"; 
	span.innerHTML = "&times;";	
	span.addEventListener( "click", function (ev) {
		ev.preventDefault();
		shadenode.parentElement.removeChild( shadenode );
		cb();
		//const evt = new Event( "window-closed", { "bubbles":false, "cancelable":false });
		//shadenode.dispatchEvent( evt );
	});
	shadenode.appendChild( span );
	document.body.appendChild( shadenode );
	return shadenode;
}

function activate_set_of_thumbnails( selector ) {
	//...
	var isActivated = 0;
	var xx = [].slice.call( selector.querySelectorAll( "li" ) );
	var imgArray = [].slice.call( selector.querySelectorAll( "li img" ) );
	var div, img, index=0;

	//This way should even work in IE
	function deadly() {
		isActivated = 0;	
		index = 0;
	}

	for ( var x in xx ) {
		xx[ x ].addEventListener( "click", function (ev) {
			if ( isActivated ) 
				div.removeChild( img );
			else {
				//???uh
				div = ugly_quick_popup( deadly );
				//if there were a way to apply an onDestroy event, we'd be gucci
				//yet another way is using an eventEmitter, and I refuse to use Angular for this...
				isActivated = 1;
			}
			
			//create a node
			img = document.createElement( "img" );
			img.src = imgArray[ index ].src;
			div.appendChild( img );
			( ++index >= imgArray.length ) ? index = 0 : 0; 
		});
	}
}


//
function activate_all_thumbnails() {
	//Apply on all selectors here with this odd loop of doom...
	var images = [].slice.call( document.querySelectorAll( ".images" ) );
	for ( var i in images ) {
		activate_set_of_thumbnails( images[i] );	
	}
}


//
function activate_info() {
	//Simply unhide all description divs
	var ii = [].slice.call( document.querySelectorAll( "a.descinfo" ) );
	const className = "js-no-show";
	for ( var i in ii ) {
		ii[i].addEventListener( "click", function(ev) {
			ev.preventDefault();
			var c = ev.currentTarget.parentElement.parentElement.parentElement.querySelector(".description");
			c.classList.contains( className ) ? c.classList.remove( className ) : c.classList.add( className );
			return false;
		});
	}	
}

*/


//Arrow clicks to scroll through the ol' portfolio
function scroll_through_portfolio() {
	//Scroll through snapshots
	var pp = [].slice.call( document.querySelectorAll( ".next" ) );
	var ss = [].slice.call( document.querySelectorAll( "li.project-li" ) );
	var ssi = 0;
	for ( var p in pp ) {
		pp[p].addEventListener( "click", function (ev) {
			var li = ss[ ( ++ssi >= ss.length ) ? ( ssi = 0 ) : ssi ];
			window.scrollTo( { top: li.offsetTop, behavior: 'smooth' } );
		});
	}
}


//Set up smooth scrolling on hashes
function scroll_to_link( stub ) {
	var id, str =	String(stub).substr( 1, String(stub).length ) + "_"; 	
	if ( ( id = document.getElementById( str ) ) ) { 
		var count = 0, p = id.parentElement;
		while ( p = p.previousSibling ) count += ( p.nodeType == 1 ) ? 1 : 0;
		window.scrollTo( {
			behavior: 'smooth' 
		,	top: ( count * window.innerHeight ) + id.offsetTop - 100
		} );
	}	
}


//Set up click override
function setup_hash_override() {
	for ( var l of [].slice.call( document.querySelectorAll( "a" ) ) ) {
		if ( l.hash ) {
			l.addEventListener( "click", (function() { 
				var hash = l.hash;
				return function(ee) {
					location.href = hash;
					location.reload();
				}
			})() );
		}
	}
}



document.addEventListener( "DOMContentLoaded", function(ev) {
	if ( location.pathname == "/" ) { 
		setup_hash_override();
	}
	if ( location.hash ) {
		scroll_to_link( location.hash );
	}
	//On all links with a #, we need a listener
	//switch_themes();
	scroll_through_portfolio();
	//activate_all_thumbnails();
	//activate_info();
});
