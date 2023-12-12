@tool
extends Node

## notifs ##########################################################################

signal notification(notif)

var queued_notifs = []

func notif(text, opts = {}):
	Log.pr("notif: ", text)
	if text is Dictionary:
		opts.merge(text)
		text = opts.get("text", opts.get("msg"))
	if typeof(opts) == TYPE_STRING or not opts is Dictionary:
		text += str(opts)
		opts = {}
	opts["text"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	notification.emit(opts)

var queued_notifs_dev = []

func dev_notif(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	msg = Log.to_printable(msgs)
	notification.emit({msg=msg, rich=true, ttl=5.0})
