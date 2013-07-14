$ ->
	pusher  = new Pusher('ae645a2445d2f72cf3d4')
	channel = pusher.subscribe('twitter')
	channel.bind 'tweet', (data) ->
		console.log data
		$("#tweets").prepend "<li><img src='/meme.jpg:#{ data.text.replace('#onlyinnola', '') }' /></li>"
