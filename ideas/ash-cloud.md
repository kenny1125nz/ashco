the previous telemetry work(telemetry.md) only implemented a file based sink.
we need improve it to actual data store, mostly cloud based. 

we need consider hosting cost, shipping data to localhosted data store regularly could be an option.

event-driven.md assumed a daemon process on end user's machine, it can be a good bridge to tunnel data into cloud store.

 the data store solution need support customer's local deployment in case user have data privacy concern