module.exports = (grunt) ->
	# Project configuration.
	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		watch:
			module:
				files: ["_src/**/*.coffee"]
				tasks: [ "newer:coffee:base" ]
				
			module_test:
				files: ["_src/**/*.coffee"]
				tasks: [ "newer:coffee:base", "test" ]
			
		coffee:
			base:
				expand: true
				cwd: '_src',
				src: ["**/*.coffee"]
				dest: ''
				ext: '.js'

		clean:
			base:
				src: [ "lib", "test" ]

		includereplace:
			pckg:
				options:
					globals:
						version: '<%= pkg.version %>'
					prefix: "@@"
					suffix: ''

				files:
					"index.js": ["index.js"]

		
		mochacli:
			options:
				require: [ "should" ]
				reporter: "spec"
				bail: false
				timeout: 3000
				slow: 3

			main:
				src: [ "test/main.js" ]
				options:
					env: process.env
		
		

	# Load npm modules
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-newer"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-mocha-cli"
	grunt.loadNpmTasks "grunt-include-replace"

	# ALIAS TASKS
	grunt.registerTask "default", "build"
	grunt.registerTask "wt", "watcher-test"
	grunt.registerTask "watcher", [ "watch:module" ]
	grunt.registerTask "watcher-test", [ "watch:module_test" ]
	grunt.registerTask "clear", [ "clean:base" ]
	grunt.registerTask "test", [ "build", "mochacli:main" ]

	grunt.registerTask "w", "watcher"
	grunt.registerTask "b", "build"
	grunt.registerTask "t", "test"

	# build the project
	grunt.registerTask "build", [ "clear", "coffee:base", "includereplace" ]
	grunt.registerTask "build-dev", [ "clear", "coffee:base", "test" ]
	
	return
