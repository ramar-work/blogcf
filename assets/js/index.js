/*index.js*/
/*
grab all the things, move the list up?
*/
document.addEventListener( "DOMContentLoaded", function(ev) {
	var switchThemes = [].slice.call( document.querySelectorAll( ".switch-theme a" ) );
	var head = document.getElementsByTagName( "head" )[0];
	console.log( head );
	console.log( head.querySelector( "link" ) );
	var link = head.querySelector( "link#theme" );
	for ( var st of switchThemes ) {
		st.addEventListener( "click", function (ev) {
			link.href = ( ev.target.className == "js-dark" ) ? "/assets/dark.css" : "/assets/light.css"; 
		});
	}

	//apply the listener to next
	var pp = [].slice.call( document.querySelectorAll( ".next" ) );
	var ss = [].slice.call( document.querySelectorAll( "li.project-li" ) );
	var ssi = 0;
	for ( var p in pp ) {
		pp[p].addEventListener( "click", function (ev) {
			//find the next list item 
			var s = document.querySelector( "li.project-li" );
			var li = ss[ ( ++ssi > ss.length ) ? ( ssi = 0 ) : ssi  ];
			window.scrollTo( { top: li.offsetTop, behavior: 'smooth' } );
		});
	}

});
