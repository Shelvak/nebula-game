# Preface

This document explains various gotchas that you need to be aware of while
developing server code.

## Fibers, Tasks and database connections

Celluloid works in a way that each method invoked gets its own Task, which
brings a new Fiber with it. JRuby currently doesn't have lightweight Fibers, so
they are emulated by a thread pool.

ActiveRecord connection pooling relies on thread locals to store connection id.
But they are not preserved between Fibers. That means such code is leaking DB
connections:

      class WithDb
        include Celluloid

        def initialize
          # This checked out connection is never used in #work, because #work
          # always has new fiber.
          @connection = ActiveRecord::Base.connection_pool.checkout
        end

        def finalize
          ActiveRecord::Base.connection_pool.checkin(@connection)
        end

        def work
          # This method is invoked in separate Task, separate Fiber, and has
          # separate thread locals. That means it automatically checks out a new
          # connection.
          unit = Unit.all
          # ... do things ... #

          # And this connection is never checked back in, which means we'll
          # run out of connections in the pool.
        end

The solution is either:

* Use ```ActiveRecord::Base.connection_pool.with_connection``` when DB
conectivity is needed. Beware that this will return existing connection if it
is not currently used and does not ensure that new connection will always be
checked out.
* Use ```ActiveRecord::Base.connection_pool.checkout``` and
```ActiveRecord::Base.connection_pool.checkin``` in ```ensure``` section if
you really need a separate connection.