<cfscript>
model = {
	edit = 0
, parent_id = cms.getRandomString()
, metas = QueryNew( "tagname", "varchar", [
		{ tagname = "tasks" }
	,	{ tagname = "North Memphis" }
	,	{ tagname = "coke" }
	])
, contentMessage = "Start adding your content here."
, postContent = {
		post_name = ""
	 ,pmd_isdraft = false 
	}
};
</cfscript>
