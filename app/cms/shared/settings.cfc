component name="settings" extends="base" accessors=true {
	//Table long ID column name
	property name="uuidColumnName" type="string" default="setting_uuid";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="setting_id";

	function all() {
		return myst.dbExec( 
			string = "SELECT * FROM #prefix#settings"
		, datasource = myst.getDatasource()
		).results;
	}

	function init( myst, model ) {
		Super.init( myst );
		return this;
	}
}
