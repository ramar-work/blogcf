<!--- archives.cfm --->
<cfoutput>
<div>
<h2>Archives</h2>
<table>
	<thead>
		<th>Title</th>
		<th>Date</th>
		<th>Link</th>
		<th>Popularity</th>
	</thead>
	<tbody>
	<cfloop query=model.collection.set>
		<tr>
			<!--- title --->
			<td>#collection_name#</td>
			<!--- author --->
			<!--- written on --->
			<td>#DateFormat( collection_date_added, "mmmm d, yyyy" )#</td>
			<!--- read the whole article --->
			<td><a href="#link("blog/#collection_long_id#")#">Read More</a></td>
			<!--- count comments --->
			<td>0</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</div>
</cfoutput>
