<!--- test.cfm - Test all the backend code in one place for the sake of speed --->
<!--- include dew/deux/dewm/ohm.js --->
<script src="/assets/js/cms/cms2.js"></script>

<style>
li div {
	width: 100%;
	height: 50px;
	background-color: #eee;
}
</style>

<script>
store = {};

//Callback for GET, DELETE requests
function init_uri_callback( item, type ) {
//console.log( item );
	return function (a) {
		if ( !a.status ) {
			console.log( "Request failed" );
		}
		else {
			console.log( "OK" );
			item.id = a.id;
		}
	}
}

//Callback for anything that requires a body
function init_post_callback( item, type ) {
	var i = item;
	//Creates get a certain callback
	//And so do the other ones...
	return function (a) {
		if ( !a.status ) {
			console.log( "Request failed" );
			console.log( a );
		}
		else if ( !( "id" in a ) ) {
			alert( "POSTs and PUTs should return an ID (even if they're an update)" );
		}
		else {
			console.log( "OK" );
			item[ type ].id = a.id;
			var d = document.createElement( "div" );
			d.innerHTML = "Working with " + type + " " + a.id;
			item[ type ].div.appendChild( d );
		}
		return
	}
}

document.addEventListener( "DOMContentLoaded", function(ev) {
	var b = [].slice.call( document.querySelectorAll("button") );
	const title = { title: 'The Cat is Out of the Bag' };
	//If there is no parentid yet, let's just add one
	if ( localStorage.getItem( "parent_id" ) )
		store.parent_id = localStorage.getItem( "parent_id" ); 

	if ( !( "parent_id" in store ) ) {
		Utils().post( "/cms/api/post/create", title, function (a) {
			if ( !a.status )
				alert( 'Problem creating initial post' );
			else {
				store.parent_id = a.id;
				localStorage.setItem( "parent_id", a.id );
			}	
		}); 
	}

	//Write the parent_id to div so that I can keep it in mind
	if ( 1 ) {
		var idiv = document.createElement( "div" );
		idiv.innerHTML = "Working with post ID: " + store.parent_id;
		document.querySelector( "div" ).append( idiv );
	}

	for ( var bb of b ) {
		bb.addEventListener( "click", function (vv) {
			var val = vv.currentTarget.getAttribute( "data-v" );
			var uri = vv.currentTarget.getAttribute( "data-uri" );
			var method = vv.currentTarget.getAttribute( "data-method" );
			var type = vv.currentTarget.getAttribute( "data-type" );
			var div = vv.currentTarget.parentElement.querySelector( "div" );
			var vset;

			//Create a store for each special type
			if ( !( type in store ) ) {
				store[ type ] = { "div": div };
			}	
			
			//console.log( method + ' => ' + uri );
			if ( method == "POST" ) {
				(vset = JSON.parse( val )).parent_id = store.parent_id;
				Utils()[ method.toLowerCase() ]( uri, vset, init_post_callback( store, type ) );
			}
			else if ( method == "PUT" || method == "PATCH" ) {
				(vset = JSON.parse( val )).parent_id = store.parent_id;
				var uu = ( "id" in store[ type ] ) ? uri + "/" + (store[type]).id : uri;
				Utils()[ method.toLowerCase() ]( uu, vset, init_post_callback( store, type ) );
			}
			else /*( method == "GET" || method == "DELETE" )*/ {
				//each type can have it's own id
				if ( "id" in store[ type ] ) {
					var uu = uri + "/" + (store[type]).id;
					console.log(( method == "GET" ? "getting" : "deleting item at" ) + uu );
					Utils()[ method.toLowerCase() ]( uu, init_uri_callback( store, type ) );
				}
				else {
					alert( "Do a CREATE first, then try the rest of the tests." );
					return
				}
			}
		});	
	}
});
</script>


<cfscript>
//here we'll write a data structure that will allow me to test all of the backends
var arr = [
	//should always work (and generated ID is stored in a data-holder or something)
	{ endpoint="create", text="fail", method="POST" }
,	{ endpoint="create", text="success", method="POST" }

	//will not always work, and should throw a code if item not found?
, { endpoint="delete", text="", method="DELETE" }

	//will not always work, and should throw a code if item not found?
, { endpoint="", text="fail", method="GET" }
, { endpoint="", text="success", method="GET" }

	//will not always work, and should throw a code if item not found?
, { endpoint="update", text="fail", method="PUT" }
, { endpoint="update", text="success", method="PUT" }
];

var data = [
	{ name="post", success = { title = "Overcooked Bacon" }, fail = { fail='fail so hard'} }
,	{ name="node", success = {}, fail = {} }
,	{ name="category", success = { name = 'New England' }, fail = {} }
,	{ name="comment", success = { text = 'Some comment by someone.' }, fail = { xxx = 'no' } }
,	{ name="keyword", success = { name = 'development' }, fail = {} }
,	{ name="image", success = {}, fail = {} }
,	{ name="metadata", success = {}, fail = {} }
,	{ name="user", success = { username='boogie328', password='hahaha77', role=1 }, fail = {} }
];

//Make a new array of buttons and values
var a = [];
for ( var n in data ) {
	//arr.data = 
	var ab = Duplicate(arr);
	ab[1].data = n.fail;
	ab[2].data = n.success;
	ab[3].data = {};
	ab[4].data = {};
	ab[5].data = {};
	ab[6].data = n.fail;
	ab[7].data = { name = model.randstr(66) };
	ArrayAppend( a, { name=n.name, array=ab } )	
}
</cfscript>


<ul>
<cfoutput>
<cfloop array=#a# index="aa">
	<li>
	<cfloop array=#aa.array# index="nn">
	<cfset uri="/cms/api/#aa.name##IIF(nn.endpoint neq "",DE('/#nn.endpoint#'),DE(''))#">
		<button 
			data-action="#nn.endpoint#"
			data-uri="#uri#"
			data-method="#nn.method#"
			data-type="#aa.name#"
			data-v='#SerializeJSON(nn.data)#'>
			#aa.name# #nn.endpoint# - #UCase(Left(nn.text,1))#
		</button>
	</cfloop>
		<div>
		</div>
	</li>
</cfloop>
</cfoutput>
</ul>
