should = require('should')

require( "dotenv" ).config( path: "./test.env" )

PolarSDK = require( "../." )
sdk = null

describe "----- polar-sdk TESTS -----", ->

	before ( done )->
		sdk = new PolarSDK()
		console.log "\n\tUse `#{sdk.config.host}` with api user `#{sdk.config.user}`\n"
		done()
		return

	after ( done )->
		done()
		return

	describe 'Main Tests', ->
		
		# it 'test activities processing', ( done )->
		# 	test_input = require( "../example_activities_res.json" )
		# 	activities = sdk._processActivities( test_input, "test" )
		# 	
		# 	if activities?.length
		# 		for activity in activities
		# 			activity.should.have.property( "user_id" ).with.instanceof( String )
		# 			activity.should.have.property( "day" ).with.instanceof( Date )
		# 			activity.should.have.property( "calories" ).with.instanceof( Number )
		# 			activity.should.have.property( "steps" ).with.instanceof( Number )
		# 			activity.should.have.property( "goal" ).with.instanceof( Number )
		# 			activity.should.have.property( "achieved" ).with.instanceof( Number )
		# 			activity.should.have.property( "activetime" ).with.instanceof( Number )
		# 			
		# 			activity.should.have.property( "additional" ).with.instanceof( Object )
		# 			activity.additional.should.have.property( "polar_id" )
		# 			activity.additional.should.have.property( "zones" ).with.instanceof( Array )
		# 			activity.additional.should.have.property( "active_calories" ).with.instanceof( Number )
		# 			
		# 			activity.should.have.property( "_meta" ).with.instanceof( Object )
		# 			activity._meta.should.have.property( "id" ).with.instanceof( Number )
		# 			activity._meta.should.have.property( "transaction" ).with.instanceof( String )
		# 	else
		# 		console.warn "\tWARNING: activities processed"
		# 	
		# 	done()
		# 	return
		# 
		# it "handle response", ( done )->
		# 	
		# 	test_input = require( "../example_activities_res.json" )
		# 	
		# 	_simres =
		# 		statusCode: 200
		# 		body: JSON.stringify( test_input )
		# 		headers: {
		# 			'ratelimit-usage': '7, 283',
		# 			'ratelimit-limit': '2000, 100000',
		# 			'ratelimit-reset': '279, 12579',
		# 			'content-type': 'Application/json',
		# 			'transfer-encoding': 'chunked',
		# 			date: 'Thu, 22 Dec 2016 07:26:21 GMT',
		# 			'set-cookie': [ 'NSC_eob1-qspe-xxb-mc-ttm=ffffffffc3a094ae45525d5f4f58455e445a4a4229a9;path=/;secure;httponly' ]
		# 		}
		# 	sdk.request._handleResponse "GET", "test", _simres, ( err, result )->
		# 		if err
		# 			throw err
		# 			return
		# 		should.exist( result )
		# 		
		# 		result.should.be.instanceof( Object )
		# 		result.should.have.property( "activity-log" ).with.instanceof( Array )
		# 		done()
		# 		return
		# 	return
		# 
		# return
		
		it "list accepted users", ( done )->
			sdk.users "accepted", ( err, users )->
				if err
					throw err
					return
				
				if users?.length
					for user in users
						#console.log user.email + " > " + user.user_id
						user.should.have.property( "user_id" ).with.instanceof( String )
						user.should.have.property( "date" ).with.instanceof( Date )
						user.should.have.property( "email" ).with.instanceof( String )
						user.should.have.property( "status" ).with.instanceof( Number ).with.equal( 1 )
						user.should.have.property( "additional" ).with.instanceof( Object ).with.property( "polar_id" ).with.instanceof( Number )
					console.warn "\tINFO: #{users.length} accepted users received"
				else
					#throw new Error( "no users received" )
					console.warn "\tWARNING: no accepted users received"
				done()
				return
			
			return
		
		###
		# currently in API version 2.20.1 documented methods `pending`, `requests` and `denied` are not working.
		it "list pending users", ( done )->
			
			sdk.users "pending", ( err, users )->
				if err
					throw err
					return
				
				if users?.length
					for user in users
						#console.log user.email + " > " + user.user_id
						user.should.have.property( "user_id" ).with.instanceof( String )
						user.should.have.property( "date" ).with.instanceof( Date )
						user.should.have.property( "email" ).with.instanceof( String )
						user.should.have.property( "status" ).with.instanceof( Number ).with.equal( 1 )
						user.should.have.property( "additional" ).with.instanceof( Object ).with.property( "polar_id" ).with.instanceof( Number )
				else
					#throw new Error( "no users received" )
					console.warn "\tWARNING: no pending users received"
				done()
				return
			
			return
			
		it "list requests users", ( done )->
			
			sdk.users "requests", ( err, users )->
				if err
					throw err
					return
				
				if users?.length
					for user in users
						#console.log user.email + " > " + user.user_id
						user.should.have.property( "user_id" ).with.instanceof( String )
						user.should.have.property( "date" ).with.instanceof( Date )
						user.should.have.property( "email" ).with.instanceof( String )
						user.should.have.property( "status" ).with.instanceof( Number ).with.equal( 1 )
						user.should.have.property( "additional" ).with.instanceof( Object ).with.property( "polar_id" ).with.instanceof( Number )
				else
					#throw new Error( "no users received" )
					console.warn "\tWARNING: no requests users received"
				done()
				return
			
			return
			
		it "list denied users", ( done )->
			
			sdk.users "denied", ( err, users )->
				if err
					throw err
					return
				
				if users?.length
					for user in users
						#console.log user.email + " > " + user.user_id
						user.should.have.property( "user_id" ).with.instanceof( String )
						user.should.have.property( "date" ).with.instanceof( Date )
						user.should.have.property( "email" ).with.instanceof( String )
						user.should.have.property( "status" ).with.instanceof( Number ).with.equal( 1 )
						user.should.have.property( "additional" ).with.instanceof( Object ).with.property( "polar_id" ).with.instanceof( Number )
				else
					#throw new Error( "no users received" )
					console.warn "\tWARNING: no denied users received"
				done()
				return
			
			return
		###
		
		it "list deleted users", ( done )->
			
			sdk.users "deleted", ( err, users )->
				if err
					throw err
					return
				
				if users?.length
					for user in users
						user.should.have.property( "user_id" ).with.instanceof( String )
						user.should.have.property( "date" ).with.instanceof( Date )
						user.should.have.property( "status" ).with.instanceof( Number ).with.equal( -1 )
						user.should.have.property( "additional" ).with.instanceof( Object ).with.property( "polar_id" ).with.instanceof( Number )
					console.warn "\tINFO: #{users.length} deleted users received"
				else
					#throw new Error( "no users received" )
					console.warn "\tWARNING: no deleted users received"
				done()
				return
		
		it "list activities", ( done )->
			@timeout( 30000 )
			sdk.listActivities ( err, activities )->
				if err
					throw err
					return
				
				if activities?.length
					for activity in activities
						#console.log activity
						activity.should.have.property( "user_id" ).with.instanceof( String )
						activity.should.have.property( "day" ).with.instanceof( Date )
						activity.should.have.property( "calories" ).with.instanceof( Number )
						activity.should.have.property( "steps" ).with.instanceof( Number )
						activity.should.have.property( "goal" ).with.instanceof( Number )
						activity.should.have.property( "achieved" ).with.instanceof( Number )
						activity.should.have.property( "activetime" ).with.instanceof( Number )
						
						activity.should.have.property( "additional" ).with.instanceof( Object )
						activity.additional.should.have.property( "polar_id" )
						activity.additional.should.have.property( "zones" ).with.instanceof( Array )
						activity.additional.should.have.property( "active_calories" ).with.instanceof( Number )
						
						activity.should.have.property( "_meta" ).with.instanceof( Object )
						activity._meta.should.have.property( "id" ).with.instanceof( Number )
						activity._meta.should.have.property( "transaction" ).with.instanceof( String )
					console.warn "\tINFO: #{activities.length} activities received"
				else
					console.warn "\tWARNING: no activities received"
				done()
				return
			
			return
			
		it "list exercises", ( done )->
			@timeout( 30000 )
			sdk.listExercises ( err, exercises )->
				if err
					throw err
					return
				
				if exercises?.length
					for exercise in exercises
						#console.log exercise
						exercise.should.have.property( "user_id" ).with.instanceof( String )
						exercise.should.have.property( "daytime" ).with.instanceof( Date )
						exercise.daytime.toString().should.not.equal( "Invalid Date" )
						exercise.should.have.property( "sport" ).with.instanceof( String )
						exercise.should.have.property( "calories" ).with.instanceof( Number )
						exercise.should.have.property( "duration" ).with.instanceof( Number )
						exercise.should.have.property( "distance" ).with.instanceof( Number )
						exercise.should.have.property( "heartrate_avg" ).with.instanceof( Number )
						exercise.should.have.property( "heartrate_max" ).with.instanceof( Number )
						
						exercise.should.have.property( "additional" ).with.instanceof( Object )
						exercise.additional.should.have.property( "polar_id" )
						exercise.additional.should.have.property( "hasroute" ).with.instanceof( Boolean )
						
						exercise.should.have.property( "_meta" ).with.instanceof( Object )
						exercise._meta.should.have.property( "id" ).with.instanceof( Number )
						exercise._meta.should.have.property( "transaction" ).with.instanceof( String )
					console.warn "\tINFO: #{exercises.length} exercises received"
				else
					console.warn "\tWARNING: no exercises received"
				done()
				return
			
			return

		return
	return
