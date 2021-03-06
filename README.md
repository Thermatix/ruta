# Ruta

##TODO
### Patch


### Minor
1. Conditional Routes
    Routes that can only be accessed when a condition is met
2. queries
    Being able to use query style params

### Major

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruta

## Usage

##config settings

To configure Ruta's settings you can use a config block

Here's a config block with Ruta's default settings
```ruby
Ruta.configure do |config|
  config.context_prefix = false
end
```

The following settings have the following effects:
1. `context_prefix`
  This setting turns on context prefixing, whenever you navigate to a route
  the context it's located in is pre-fixed to the front of it, navigating to
  a context with this turned on will set the url to being just the context name


Making use of this router is pretty simple.

###Contexts

The first thing to do is to define your contexts.

A context is a composition of on screen component containers, routes and handlers.

You can even place another context under a context as a sub-context

`component` is used to define a container, you give it a name and then a block and inside of which you
place a renderable component.

you can also use `sub_context` to mount a sub-context at this position, first you give it a name then
a reference to the context you wish to place here.

This initial composition is used to as the default settings for when the context is first rendered

```ruby
Ruta::Context.define :main do
  component :header do
    Header
  end

  sub_context :info, :info_view

  component :footer do
    Footer
  end
end


Ruta::Context.define :info_view do
  component :hero do
    Hero_Image
  end

  component :scroller do
    Info_Scroller
  end

  component :buttons do
    Buttons
  end
end

Ruta::Context.define :sign_up do
  component :sign_up_form do
    Sign_Up_Form
  end
end
```

###Handlers

Next you should define some handlers, not every component needs a handler but every component has one
needs to match names with a corresponding handler.

you use the `handle` macro to define a handler and you pass into it the name of the element you want this
handler to drive.

You can also however render a sub-context instead of a component, just use:

```ruby
handle :component do |params,url|
  mount :sub_context
end
```

The handler has two variables passed to it:

1. `params` a hash containing the named params of the route
2. `url` a string containing the url of the route being passed to the handler

The handler must return a renderable component or mount a sub-context.

```ruby
Ruta::Handlers.define_for :main do

end

Ruta::Handlers.define_for :info_view do
  handle :scroller do |params,url|
    Info_Scroller.render(page: params[:switch_to])
  end

  handle :buttons do |params,url|
    Buttons.render(selected: params[:switch_to])
  end
end

Ruta::Handlers.define_for :sign_up do

end
```

You can use `default` inside of a handler to render the component in the default state
as it is defined in the context.

###Routes

The last thing to define before your app is ready is the routes that will activate the correct handlers to
drive onscreen components.

Roots that drive on screen components should always be mounted to a context.
You can state the context using `for_context` then pass in the context you wish to define routes for.
whilst you can place context's within each other this doesn't actually do anything beyond aesthetics, but
it's planned that you can mount contexts to routes

You map a route by using the `map` command then pass a unique reference (to that context) for the route,
the route you want to match against and then the driver, one or more handlers; remember handlers are
executed in the order specified. You can also provide a context that the route will activate.

To set the initial context that is presented use `root_to` then provide the context you want to be rendered first

```ruby
Ruta::Router.define do
  for_context :main do
    for_context :info_view do
      map :i_switch, '/buttons/:switch_to', to: [:scroller,:buttons]
      map :sign_up, '/sign_up', context: :sign_up
    end
  end

  root_to :main
end

```

###Renderer

The penultimate step is to tell the router how to render your components.

You do this using `Ruta::Context.handle_render` and then define the render macro.
Passed into the macro is the `component` you wish to render and the `element_id` of the components mounting
point.

```ruby
Ruta::Context.handle_render do |component,element_id|
  element = if component.class == React::Element
    component
  else
    React.create_element(component)
  end
  React.render element, `document.getElementById(#{element_id})`
end
```

###Navigating your app

Navigating your app is super duper easy.
All you have to do is this

```ruby
Ruta.navigate_to_ref(:info_view,:i_switch,value)
```
The first arg is the context of the route you wish to navigate to is located in, the second is the
reference of the route, lastly any params you wish to place into the route go next, they are placed into the route as they come.

You would most probably use it in a 'click' callback in response to the user clicking on somthing



###Starting the app

The last step is to start the router and thus your app this can be accomplished by using `Ruta.start_app`;
it's best to wrap this inside of a `$document.ready` block so that the app will only start when the dom is
fully ready.
```ruby
$document.ready do
  Ruta.start_app
end
```

### Example

Here is an [example app](https://github.com/Thermatix/ruta_with_reactrb_example) where you can see the router in action, remember to `bundle install` first before running with `rackup`



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruta. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
