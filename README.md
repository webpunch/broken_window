# BrokenWindow

This project rocks and uses MIT-LICENSE.

### Installation

Add:

```
gem 'broken_window', github: 'webpunch/broken_window'
```

to your Gemfile

Run: `rake broken_window:install:migrations && rake db:migrate`

Add to your routes file:

```
mount BrokenWindow::Engine => "/status"
```

Create `config/initializers/broken_window.rb` to register your calculators:

```
BrokenWindow.register_calculators [
  BrokenWindow::Calculators::ExampleCalculator
]
```

Create your calculator:


```
module BrokenWindow
  module Calculators
    class ExampleCalculator
      def initialize(options = {})

      end

      def call
        # Thing to be calculated
      end

    end
  end
end
```
