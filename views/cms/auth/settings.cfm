<!--- settings.cfm --->
<div class="container">
	<cfoutput>
	<h1>Settings</h1>

	<!---
	There might be a better way to handle this...
	<ul class="container-navigation">
	<cfloop collection="#model.settings#" item="catTitle">
		<li><a href="###catTitle#">#LCase( catTitle )#</a></li>
	</cfloop>
	</ul>
	--->

	<!---
	<cfif cms.getDebug()>
		<cfinclude template="stubs/debug.cfm">
	</cfif>
	--->

	<!---
	<cfloop collection="#settingsStruct#" index="catTitle">
	--->
	<div>

		<!--- Title --->
		<div class="hider-section">
			<!---
			<h2 id="#catTitle#">#LCase( catTitle )#</h2>
			--->
			<div class="container-section--collapse">
				<div class="container-section--icon"></div>
			</div>
		</div>

		<!--- All tables --->
		<div class="container-section">
			<table class="params-table">
				<cfloop query="#model.settings#">
					<tr>
						<td>#setting_key#</td>
						<td>
					<cfswitch expression=#setting_type#>
						<cfcase value="checkbox">
							<input type="checkbox" checked="#setting_value#">
						</cfcase>
						<cfcase value="text">
							<input type="text" value="#setting_value#">
						</cfcase>
						<cfcase value="email">
							<input type="email" value="#setting_value#">
						</cfcase>
						<cfcase value="file">
							<cfset var inlineImage ="background-image: url('/assets/img/cms/suzuki_swift.jpg');">	
							<cfset inlineImage &="background-size:100%;">	
							<div class="admin hold image" style="#inlineImage#">
							</div>
							<input type="file" class="img-select"></input>
						</cfcase>
						<cfcase value="hexmap">
							<div class="admin hold hexmap">
								<div class="color" style="background-color( #setting_value# )"></div>
							</div>
						</cfcase>
						<cfcase value="number">
							<input type="numeric" value="#setting_value#">
						</cfcase>
						<cfcase value="radio">
							<cfloop list="#setting_value#" index="litem">
								<input type="radio" value="#litem#">#litem#</input>
							</cfloop>	
						</cfcase>
						<cfdefaultcase>
							#setting_value#
						</cfdefaultcase>
					</cfswitch>
						</td>
					</tr>
				</cfloop>
			</table>
		</div> <!--- class="container-section" --->
	</div>
	<!---
	</cfloop>
	--->
	</cfoutput>
</div> <!--- class="container" --->
