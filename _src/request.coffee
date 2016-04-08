# # Polar requester
# ### extends [Basic](basic.coffee.html)
#
# a helper module to do the polar requests

# **node modules**
http = require( "http" )

# **npm modules**
_last = require( "lodash/last" )
_template = require( "lodash/template" )
request = require( "hyperrequest" )

# **internal modules**

module.exports = class PolarRequester extends require( "./basic" )
	
	_logname: ->
		return "PolarRequester"
	
	get: ( [ type, query, options ]..., cb )=>
		opt =
			url: @_url( type, options )
			qs: query
			headers: @_headers( type, options )
			method: "GET"
		
		@debug "#{type}-req", opt
		
		request opt, ( err, res )=>
			@debug "#{type}-return", [ err, res.statusCode, res.body ]
			if err
				cb( err )
				return
			
			if res.statusCode < 200 or res.statusCode >= 300
				@_handleError( cb, "EPOLARERROR", { message: res.statusCode + " " + http.STATUS_CODES[res.statusCode], statusCode: res.statusCode })
				return
			cb( null, res.body, res.headers )
			return
		return
		
	post: ( [ type, data, options ]..., cb )=>
		opt =
			url: @_url( type, options )
			headers: @_headers( type, options )
			method: "POST"
			json: data or {}
		
		@debug "#{type}-req", opt
		request opt, ( err, res )=>
			@debug "#{type}-return", [ err, res.statusCode, res.body ]
			if err
				cb( err )
				return
			
			if res.statusCode < 200 or res.statusCode >= 300
				@_handleError( cb, "EPOLARERROR", { message: res.statusCode + " " + http.STATUS_CODES[res.statusCode], statusCode: res.statusCode })
				return
			cb( null, res.body, res.headers )
			return
		return
		
	transaction: ( type, cb )=>
		if not type? or type not in @config.transactionTypes
			@_handleError( cb, "EINVALIDTRANSACTIONTYPE", { type: type, types: @config.transactionTypes } )
			return
			
		options =
			type: type
		
		@_createTransaction options, ( err, options )=>
			if err
				cb( err )
				return
				
			@get "transaction-list", null, options, ( err, result )=>
				if err
					cb( err )
					return
				@debug "transaction result data", result
				@_commitTransaction options, ( err )->
					if err
						cb( err )
						return
					cb( null, result, options.transaction_id )
					return
				return
		
	_createTransaction: ( options={}, cb )=>
		@get "transaction-new", null, options, ( err, body, headers )=>
			if err
				cb( err )
				return
			
			options.transaction_id = transaction_id = _last( headers.location.split( "/" ) )
			@debug "transaction new headers", headers, options
			cb( null, options )
			return
		return
	
	_commitTransaction: ( options={}, cb )=>
		if not options.transaction_id?
			@_handleError( cb, "EMISSINGTRANSACTIONID" )
			return
		
		@get "transaction-commit", null, options, ( err, body, headers )=>
			if err
				cb( err )
				return
			@debug "transaction commit return", body, headers
			cb( null )
			return
		return
		
	_url: ( type, data, query )=>
		if @config.useSandbox
			_cnf = @config.sandbox
		else
			_cnf = @config
		
		if _cnf.ssl
			_url = "https://"
		else
			_url = "http://"
		
		if not @config.authByHeader
			_url += "#{_cnf.user}:#{_cnf.password}@"
		
		_url += _cnf.host
		
		switch type
			when "register"
				_url += "/register/user"
			when "deregister"
				_url += "/register/user/delete"
			when "accepted-users"
				_url += "/users/accepted/list"
			when "deleted-users"
				_url += "/users/deleted/list"
			when "pending-users"
				_url += "/pending/list"
			when "denied-users"
				_url += "/denied/list"
			when "transaction-new"
				_url += "/<%= type %>-transactions/new"
			when "transaction-list"
				_url += "/<%= type %>-transactions/<%= transaction_id %>/list"
			when "transaction-commit"
				_url += "/<%= type %>-transactions/<%= transaction_id %>/commit"
				
		if data? and _url.indexOf( "<%" ) >= 0
			return _template( _url )(data)
			
		return _url
	
		
	_headers: ( type, data )=>
		if @config.useSandbox
			_cnf = @config.sandbox
		else
			_cnf = @config
		
		headers =
			'content-type': 'application/json'
		
		if @config.authByHeader
			headers.Authorization = new Buffer("#{_cnf.password}:#{_cnf.user}").toString('base64')
		
		switch type
			when "transaction-list"
				headers.Accept = "Application/json"
		return headers
	
		
	ERRORS: =>
		return @extend {}, super,
			# Exceptions
			"EPOLARERROR": [ 500, "EPOLARERROR" ]
			"EINVALIDTRANSACTIONTYPE": [ 406, "invalid transaction type. You tried to use the type `<%= type %>`, but only the types  `<% types.join( '`, `' ) %>` are allowed" ]
			"EMISSINGTRANSACTIONID": [ 406, "to commit a transaction you have to add a transaction id" ]
