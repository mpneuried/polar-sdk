should = require('should')

PolarSDK = require( "../." )

sdk = null

describe "----- polar-sdk TESTS -----", ->

	before ( done )->
		sdk = new PolarSDK()
		done()
		return

	after ( done )->
		done()
		return

	describe 'Main Tests', ->

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
				else
					throw new Error( "no users received" )
				done()
				return
			
			return
		
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
				else
					throw new Error( "no users received" )
				done()
				return
		
		it "list activities", ( done )->
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
						activity.additional.should.have.property( "polar_id" ).with.instanceof( Number )
						activity.additional.should.have.property( "zones" ).with.instanceof( Array )
						activity.additional.should.have.property( "active_calories" ).with.instanceof( Number )
						
						activity.should.have.property( "_meta" ).with.instanceof( Object )
						activity._meta.should.have.property( "id" ).with.instanceof( Number )
						activity._meta.should.have.property( "transaction" ).with.instanceof( String )
				else
					console.warn "\tINFO: no activities received"
				done()
				return
			
			return
			
		it "list exercises", ( done )->
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
				else
					console.warn "\tINFO: no exercises received"
				done()
				return
			
			return

		return
	return
