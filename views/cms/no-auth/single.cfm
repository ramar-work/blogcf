<cfoutput>
<div class="collection single">
	<h2>#model.collection.set.title#</h2>
	<br /><p>Written by Antonio R. Collins II<!--- #model.collection.author# ---></p><br />
	<p>#model.collection.date#</p>
<cfloop query=model.collection.set>
	<div class="content-regular">
	<cfif #ctypei# eq model.collection.types.text>
		<p>#ctext#</p>
	<cfelseif #ctypei# eq model.collection.types.audio>
		<audio controls src="#ctext#">
			Your browser does not support HTML5 audio.
		</audio>
	<cfelseif #ctypei# eq model.collection.types.image>
		<img src="#ctext#">
	<cfelseif #ctypei# eq model.collection.types.video>
		<video controls src="#ctext#">
			Your browser does not support HTML5 video.
		</video>
	<cfelse>
		<a href="#ctext#">#ctext#</a>
	</cfif>
	</div>
</cfloop>
</div>
</cfoutput>
