# ortools-sat

Crystal bindings for the OR-Tools SAT Solver

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ortools-sat:
       github: darkstego/ortools-sat
   ```

2. Run `shards install`

## Usage

Example:
```crystal
require "ortools-sat"

model = ORTools::Sat::Model.new
a = model.new_int_var(0,3)
b = model.new_int_var(5,10)
model.add_constraint 2*a > b
solution = model.solve
if solution.is_a? ORTools::Sat::ValidSolution
  puts "a = #{solution.value a}"
  puts "b = #{solution.value b}"
end
```

## Contributing

1. Fork it (<https://github.com/darkstego/ortools-sat/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Abdulla Bubshait](https://github.com/darkstego) - creator and maintainer
