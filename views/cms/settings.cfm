<!--- settings.cfm --->
<div class="container">
	<cfoutput>
	<h1>Settings</h1>

	<ul class="container-navigation">
	<cfloop collection="#settingsStruct#" item="catTitle">
		<li><a href="###catTitle#">#LCase( catTitle )#</a></li>
	</cfloop>
	</ul>

	<cfif cms.getDebuggable()>
		<cfinclude template="stubs/debug.cfm">
	</cfif>

	<cfloop collection="#settingsStruct#" index="catTitle">
	<div>

		<!--- Title --->
		<div class="hider-section">
			<h2 id="#catTitle#">#LCase( catTitle )#</h2>
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>

		<!--- All tables --->
		<div class="container-section">
			<table class="params-table">
				<cfloop array="#settingsStruct[ catTitle ]#" item="ss">
					<tr>
						<td>#ss.key#</td>
						<td>
					<cfswitch expression=#ss.type#>
						<cfcase value="checkbox">
							<input type="checkbox" checked="#ss.value#">
						</cfcase>
						<cfcase value="text">
							<input type="text" value="#ss.value#">
						</cfcase>
						<cfcase value="email">
							<input type="email" value="#ss.value#">
						</cfcase>
						<cfcase value="file">
							<cfset var inlineImage ="background-image: url('#cms.getAssetPath("img","suzuki_swift.jpg")#');">	
							<cfset inlineImage &="background-size:100%;">	
							<div class="admin hold image" style="#inlineImage#">
							</div>
							<input type="file" class="img-select"></input>
						</cfcase>
						<cfcase value="hexmap">
							<div class="admin hold hexmap">
								<div class="color" style="background-color( #ss.value# )"></div>
							</div>
						</cfcase>
						<cfcase value="number">
							<input type="numeric" value="#ss.value#">
						</cfcase>
						<cfcase value="radio">
							<cfloop list="#ss.value#" index="litem">
								<input type="radio" value="#litem#">#litem#</input>
							</cfloop>	
						</cfcase>
						<cfdefaultcase>
							#ss.value#
						</cfdefaultcase>
					</cfswitch>
						</td>
					</tr>
				</cfloop>
			</table>
		</div> <!--- class="container-section" --->
	</div>
	</cfloop>
	</cfoutput>
</div> <!--- class="container" --->
