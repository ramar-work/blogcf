<!---
/* ---------------------------------------------- *
Application.cfc
===============

Author
------
Antonio R. Collins II (rc@tubularmodular.com, ramar.collins@gmail.com)

Copyright
---------
Copyright 2016-Present, "Tubular Modular"
Original Author Date: Tue Jul 26 07:26:29 2016 -0400

Summary
-------
All Application.cfc rules are specified here.

 * ---------------------------------------------- */
 --->
component {

	function onRequestStart (string Page) {
		if (structKeyExists(url, "reload")) {
			onApplicationStart();
		}
	}


	function onRequest (string targetPage) {
		try {
			new myst( targetPage );	
		} 
		catch (any e) {
			writedump( e ); 
			abort;
		}
		return false;
	}


	function onMissingTemplate (string Page) {
		include "index.cfm";
	}

}
