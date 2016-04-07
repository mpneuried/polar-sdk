# # Config Module

# **node modules**

# **npm modules**
_isFunction = require( "lodash/isFunction" )
_isObject = require( "lodash/isObject" )
_isArray = require( "lodash/isArray" )
extend = require( "extend" )

# **internal modules**
utils = require( "./utils" )

_debug = process.env.POLAR_SDK_DEBUG or false

DEFAULTS =
	# **GENERAL**
	# **useSandbox** *Boolean* Use the sandbox configuration
	useSandbox: process.env.POLAR_SDK_SANDBOX or false
	# **authByHeader** *Boolean* Authentication through header
	authByHeader: false
	# **maxLoadUsers** *Number* The default count of users to load
	maxLoadUsers: 1000
	# **fallbackLocale** *String* The locale code to fallback if the given localed is not within the supported locales
	fallbackLocale: "en"

	# **AUTHENTICATION**
	# **host** *String* Polar AccessLink host
	host: process.env.POLAR_SDK_HOST or 'www.polaraccesslink.com'
	# **user** *String* Polar AccessLink api user. contact polar
	user: process.env.POLAR_SDK_USER or "-- define in config or as env var --"
	# **password** *String* Polar AccessLink api password
	password: process.env.POLAR_SDK_PASSWORD or "-- define in config or as env var --"
	# **ssl** *Boolean* Use https to access the api
	ssl: true
	
	# **sandbox** *Object* Sandbox configuration
	sandbox:
		# **sandbox.host** *String* Polar AccessLink Sandbox host
		host: process.env.POLAR_SDK_SANDBOX_HOST or "ppt-acl-sandbox.polar.com/accesslink"
		# **sandbox.user** *String* Polar AccessLink Sandbox api user. contact polar
		user: process.env.POLAR_SDK_SANDBOX_USER or "ppt-acl-sandbox"
		# **sandbox.password** *String* Polar AccessLink Sandbox api password
		password: process.env.POLAR_SDK_SANDBOX_PASSWORD or "-- define in config or as env var --"
		# **sandbox.ssl** *Boolean* Use https to access the api
		ssl: false
	
	
	# **INTERNALS**
	# **userRequestTypes** *String[]* List of user reqiuest types. ONLY FOR INTERNAL USE.
	userRequestTypes: [ "accepted", "deleted" ]
	# **transactionTypes** *String[]* List of transaction requests. ONLY FOR INTERNAL USE.
	transactionTypes: [ "activity", "exercise" ]
	# **langcodes** *String[]* List supported locales. ONLY FOR INTERNAL USE.
	locales: [ "da","de","en","es","fr","it","nl","no","pl","pt","fi","sv","ru","ja","zh" ]

	logging:
		severity: process.env[ "severity" ] or process.env[ "severity_polar_sdk"] or process.env.POLAR_SDK_SEVERITY or ( if _debug then "debug" else "warning" )
		severitys: "fatal,error,warning,info,debug".split( "," )

module.exports = class Config
	
	constructor: ( input )->
		for _k, _v of DEFAULTS
			utils.getter( _k, _v, @ )
			
		@set( input )
		return
		
	set: ( key, value )=>
		if not key?
			return
		if _isObject( key )
			for _k, _v of key
				@set( _k, _v )
			return
		if _isObject( @[ key ] ) and _isObject( value ) and not _isArray( value )
			@[ key ] = extend( true, {}, @[ key ], value )
		else
			@[ key ] = value
		return
