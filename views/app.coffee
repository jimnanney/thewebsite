$ ->
	pusher  = new Pusher('ae645a2445d2f72cf3d4')
	channel = pusher.subscribe('twitter')
	channel.bind 'tweet', (data) ->
		console.log data
		$("#tweets").prepend "<li class='meme'><figure><img src='http://onlyinnola.tw/meme.jpg:#{ data.text }'><figcaption class='social'><ul><li><a href='TheLinkThing'>Reddit</a></li><li><a href='TWEETLINK'>The Original Tweet</a></li><li><a href='PERMALINK'>Link to this</a></li></ul></figcaption></figure></li>"
