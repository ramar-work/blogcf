<!---
/* ------------------------------------------ *
 * data.cfm
 * --------
 * 
 * Summary
 * --------
 * CFML-based configuration file.
 * 
 * Application routes, datasources and more
 * are all updated here.
 *
 * ------------------------------------------- */
 --->
<cfscript>
/*This variable is used by ColdMVC to load all configuration data*/
manifest = {
/*This should probably not be modified by you*/
 "cookie" = "07ad9c212802a24a8a129ca3ffd43e97bb3363bf35c09f4a1777c8d03b5f"

/*----------------- USER-MODIFIABLE STUFF ------------------*/
/*Turn on debugging, yes or no?*/
,"debug"  = 0  

/*Set a description for this new application*/
,"description"  = "__DESCRIPTION__" 

/*Set a primary author for SEO purposes*/
,"author"  = "Buddy Noone" 

/*Locations for alternate serving locations can go here*/
,"hosts"  = [ ]

/*Select a datasource*/
,"source" = "rcdb"

/*All requests will use this as the base directory*/
,"base"   = "/"

/*This is a symbolic name for the application*/
,"name"   = "collinsdesign.local"

/*Set a global site title from here for SEO purposes*/
,"title"  = "collinsdesign.local"

/*This is used to control how much logging to do where*/
,"settings" = {
	 "verboseLog" = 0
	,"addLogLine" = 0
}

/*This is used to run something after every request (onRequest could be used as
 *well)*/
,"post" = false

/*This was used to choose custom 404 and 500 error pages*/
,"localOverride" = {
	 "4xx"    = 0
	,"5xx"    = 0
}

/*----------------- CUSTOM  ---------------------------------*/
/*Add your custom variables here*/

/*----------------- DATABASES -------------------------------*/
/*Aliases for database tables can go here*/
,"data"   = {}

/*----------------- ROUTES ---------------------------------*/
/*Here are the application's routes or endpoints.*/
,"routes" = {

	"default"= { model="default", view = "default" }

 } /*end routes*/
};
</cfscript>
