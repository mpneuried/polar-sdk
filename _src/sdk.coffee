# # Polar requests
# ### extends [Basic](basic.coffee.html)
#
# Do polar api requests

# **node modules**

# **npm modules**
_isDate = require( "lodash/isDate" )

# **internal modules**
PolarRequest = require( "./request" )
utils = require( "./utils" )

module.exports = class PolarSDK extends require( "./basic" )
	
	initialize: =>
		@request = new PolarRequest( @config )
		
		if @config.fallbackLocale not in @config.locales
			@_handleError( null, "EINVALIDFALLBACKLOCALE" )
			
		return
	
	register: ( [ user, message, email ]..., cb )=>
		@debug "register", [user, message, email]
		if not ( email or user.email)?
			@_handleError( cb, "EMISSINGEMAIL", uid: user.id )
			return
		
		data =
			email: email or user.email
			"member-id": user.id
			message: message or "connect to miloncare"
			locale: @_getLocale( user.locale )
	
		@request.post "register", data, ( err, data )=>
			@debug "register-return", err, data
			if err?.statusCode is 409
				# assuming a reregister leads to a 409
				@warning "got 409 so guess a reregister", opt.json
				cb( null, true )
				return
				
			if err
				cb( err )
				return
				
			cb( null, true )
			return
		return
	
	deregister: ( [ user, message, email ]..., cb )=>
		@debug "deregister", user, message
		data =
			email: email or user.email
			"member-id": user.id
			message: message or "disconnect from miloncare"
		
		@request.post "deregister", data, ( err, data )->
			if err
				cb( err )
				return
				
			cb( null, true )
			return
		return
	
	users: ( type, [count, from]..., cb )=>
		if not type? or type not in @config.userRequestTypes
			@_handleError( cb, "EINVALIDUSERTYPE", { type: options.type, types: @config.transactionTypes } )
			return
			
		_q = {}
		if count?
			_q.count count
		else
			_q.count = @config.maxLoadUsers
			
		if type is "accepted"
			if not from? ot not _isDate( from )
				from = new Date()
			_q.begin_from = from.getFullYear() + '-' + from.getMonth() + '-' + from.getDate() + 'T' + from.getHours() + ':' + from.getMinutes()
			
		@request.get "#{type}-users", _q, ( err, result )=>
			if err
				cb( err )
				return
			
			users = []
			for user in result.user
				users.push
					user_id: user['member-id']
					date: new Date(user['registration-date'])
					email: user.email
					status: @_mapUserStatus( user.state )
					additional:
						polar_id: user['orgAppUserId']
						
			cb( null, users )
			return
		return
			
	listActivities: ( cb )->

		# start a transaction
		@request.transaction "activity", ( err, result, transaction_id )->
			if err
				cb( err )
				return
				
			activities = []
			for activity in result[ "activity-log" ]
				_ob =
					user_id: activity['member-id']
					day: new Date(activity['date'])
					calories: activity.calories
					steps: activity['active-steps']
					goal: activity['activity-goal']
					achieved: activity['activity-achieved']
					activetime: utils.duration( activity.duration )
					additional:
						polar_id: activity['polar-user']
						zones: []
						active_calories: activity['active-calories']
					_meta:
						id: activity.id
						transaction: transaction_id
				
				for zone in activity['activity-zones']
					_ob.additional.zones.push( utils.duration( zone.inzone ) )
				
				activities.push _ob
			
			cb( null, activities )
			return
		return
	
	listExercises: ( cb )->

		# start a transaction
		@request.transaction "exercise", ( err, result, transaction_id )->
			if err
				cb( err )
				return
				
			exercises = []
			for exercise in result.exercise
				exercises.push
					user_id: exercise['member-id']
					daytime: new Date(exercise['date'])
					device: exercise.device
					sport: exercise.sport
					calories: exercise.calories or 0
					duration: utils.duration( exercise.duration )
					distance: exercise.distance or 0
					heartrate_avg: exercise['heart-rate']['average'] or 0
					heartrate_max: exercise['heart-rate']['maximum'] or 0
					additional:
						polar_id: exercise['polar-user']
						hasroute: exercise['has-route']
					_meta:
						id: exercise.id
						transaction: transaction_id

			cb( null, exercises )
			return
		return
	
	_getLocale: ( locale )=>
		if locale.indexOf( "_" )
			[ lang, country ] = locale.split( "_" )
		else
			lang = locale
		lang = lang.toLowerCase()
		if lang in @config.locales
			return lang
		return @config.fallbackLocale
	
	_mapUserStatus: ( state )->
		return switch state.toLowerCase()
			when "accepted" then 1
			when "deleted" then -1
	
	ERRORS: =>
		return @extend {}, super,
			# Exceptions
			"EINVALIDFALLBACKLOCALE": [ 500, "The configured `fallbackLocale` is not supported" ]
			"EMISSINGEMAIL": [ 406, "missing email. Please define a separate email or make sure the user `<%= uid %>` has a email saved." ]
			"EINVALIDUSERTYPE": [ 406, "invalid user request type. You tried to use the type `<%= type %>`, but only the types  `<% types.join( '`, `' ) %>` are allowed" ]
