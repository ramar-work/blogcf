<!--- get.cfm --->
<cfset model = cms.qGetSinglePost( lid=url.id )>
<!---
<cfquery name="post" datasource="#data.source#">

	SELECT * FROM #data.data.posts# 
		WHERE post_id = <cfqueryparam value="#url.id#" cfsqltype="integer">

</cfquery>



<cfquery name="all" datasource="#data.source#">

	SELECT 
		*
	FROM

	( SELECT * FROM #data.data.posts# 
		WHERE post_id = <cfqueryparam value="#url.id#" cfsqltype="integer"> 
	) AS p

	LEFT JOIN

	( SELECT * FROM #data.data.content# 
		WHERE parent_id = <cfqueryparam value="#post.post_long_id#" cfsqltype="varchar">
	) AS c

	ON p.post_long_id = c.parent_id

</cfquery>


<cfset model = {}>
<cfset model.results = "#all#" >
--->
