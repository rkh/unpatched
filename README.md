Convenience library, like ActiveSupport or extlib, but without a single
monkey-patch. It is also an API experiment.

# Usage

Stand alone:

``` ruby
require 'unpatched'
include Unpatched

like("FooBar").but.underscore!
about(1).month.and(4).days.ago!
```

Is that too much sugar? Try this:

``` ruby
require 'unpatched'
include Unpatched::Unfancy
_('FooBar').underscore!
```

Still too much?

``` ruby
require 'unpatched'
Unpatched['FooBar'].underscore!
```

With Sinatra:

``` ruby
require 'sinatra'
require 'unpatched'
helpers Unpatched

get '/' do
  expires exactly(1.5).minutes.from_now!
  "Hey, ho, let's go!"
end
```

# When to use an exclamation mark

Short: You don't have to. But methods without one will always return magically
enhanced objects. Since you never want to pass those on (otherwise, what's the
point?), you can get vanilla objects by using an exclamation mark.

Rule of thumb: Use it at the end of your method chain.

# Installation

    gem install unpatched

