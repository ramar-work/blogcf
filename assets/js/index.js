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
});
