<cfscript>

//data can be loaded from database or component (or some other place)

//Settings are loaded, and CMSes are configured according to these rules.
settingsStruct = {

	appearance = [
		{ name="app_bgcolor", key="Background Color", value="##ffffff", type="hexmap", tooltip="" }
	,	{ name="app_fgcolor", key="Foreground Color", value="##ffffff", type="hexmap", tooltip="" }
	,	{ name="app_favicon", key="Favicon", value="", type="file", tooltip="" }
	]

, "post configuration" = [
		{ name="pc_order", key="Post Order", value="up,down,right,left", type="radio", tooltip="" }
	,	{ name="pc_number", key="Number of Posts To Display", value=13, type="number", tooltip="" }
	,	{ name="pc_fimage", key="Show Featured Image", value=false, type="checkbox", tooltip="" }
	]

, "editor configuration" = [
		{ name="ed_dandd", key="Drag and Drop?", value=true, type="checkbox", tooltip="" }
	]

, branding = [
	 	{ name="br_logo", key="Logo", value="", type="file", tooltip="" }
	,	{ name="br_favicon", key="Favicon", value="", type="file", tooltip="" }
	]

, authors = [
	 	{ name="au_primaryauthorname", key="Primary Author", value="", type="text", tooltip="" }
	,	{ name="au_primaryauthormail", key="Primary Email", value="", type="email", tooltip="" }
	//{ additional authors will come from somewhere else, tooltip="" }
	]


/*
, services = [

	]
*/


};


</cfscript>
