module stripeclient

import time
import x.json2
import json

struct Event {
mut:
	id          string
	object      string
	api_version string
	created     time.Time
	eventtype   string
	data        EventData
}

struct EventData {
mut:
	object StripeObject
}

type StripeObject = Event | Session

// replacement for json decode
// json decode returns unknown sum type value
fn (client StripeClient) decode_event(event_str string) !Event {
	raw_event := json2.raw_decode(event_str) or { panic(err) }
	event_map := raw_event.as_map()
	event_type := event_map['type'] as string
	mut event := json.decode(Event, event_str) or { panic(err) }

	match event_type {
		'checkout.session.completed' {
			event_data := event_map['data'] as map[string]json2.Any
			event_object_ := json2.encode(event_data['object'])
			event_object := json.decode(Session, event_object_)!
			event.data.object = event_object
		}
		else {
			// todo
		}
	}
	return event
}
