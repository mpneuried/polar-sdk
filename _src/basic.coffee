# # PolarSDKBasic Module
# ### extends [Basic](basic.coffee.html)
#
# Basic polar module to handle the configuration

# **node modules**

# **npm modules**

# **internal modules**
Config = require "./config"

module.exports = class PolarSDKBasic extends require( "mpbasic" )()

	constructor: ( options )->
		@on "_log", @_log

		@getter "classname", ->
			return @constructor.name.toLowerCase()

		# extend the internal config
		if options instanceof Config
			@config = options
		else
			@config = new Config( options )

		# init errors
		@_initErrors()

		@initialize( options )

		@debug "loaded"
		return
