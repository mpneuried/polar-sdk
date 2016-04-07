_isFunction = require( "lodash/isFunction" )

module.exports =
	###
	convertDuration
	convert Duration from Polar String to Number of Seconds
	
	#str = 'PT3H55M30S'
	###
	duration: (str)->
		ar = str.split(/P|T/)
		ymd = if ar[1].match(/Y/) then ar[1].split(/Y/) else ('Y'+ar[1]).split(/Y/)
		y = ymd[0]
		mo = ymd[1].split(/M|D/)[0] if ymd[1]
		d = ymd[1].split(/M|D/)[1] if ymd[1]

		if (!ar[2])
			h = m = s = 0
		else
			hms = if ar[2].match(/H/) then ar[2].split(/H/) else ('H'+ar[2]).split(/H/)
			h = hms[0]
			m = hms[1].split(/M|S/)[0] if hms[1]
			s = hms[1].split(/M|S/)[1] if hms[1]

		return ((if s then parseInt(s) else 0) + (if m then parseInt(m)*60 else 0) + (if h then parseInt(h)*3600 else 0) + (if d then parseInt(d)*24*3600 else 0) + (if mo then parseInt(mo)*30*24*3600 else 0) + (if y then parseInt(y)*365*24*3600 else 0))
	
	getter: ( prop, _get, context )->
		_obj =
			enumerable: true
			writable: true

		if _isFunction( _get )
			_obj.get = _get
		else
			_obj.value = _get
		Object.defineProperty( context, prop, _obj )
		return
