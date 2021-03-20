# Ruby::See5

A Ruby frontend for the See5/C5.0 family of classifiers and modellers. Builds models from Ruby objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'see5'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install see5
```

## Usage

### Training a classifier

`c5.0` must be available in the system path.

Input data must be an Enumerable of Hashes, OpenStructs, or ActiveModel-like objects—anything that responds to `#[]` or `#send(:attr_name)` for each attribute name. The objects must respond to `#each` for automatic schema construction; otherwise, you will have to specify the schema.

```ruby
data = [
  { a: true, b: 5, c: "yellow" },
  { a: false, b: 6, c: "green" },
  # ...
]
```

Train a classifier by calling `See5.train`. Pass in the data and the name of the class attribute.

```ruby
classifier = See5.train(data, class_attribute: :a)
```

Use the model to classify new records by calling `#classify`.

```ruby
classifier.classify(b: 5)
# => true

classifier.classify(b: 8, c: "green")
# => false
```

Inspect the classifier's rules with `#rules`.

```ruby
classifier.rules
```

### Dumping and loading a classifier

A model can be dumped to JSON, to be loaded and used later. Perhaps you want to run the classifier in a production system.

Loading and using a classifier does not have any dependencies outside the gem.

```ruby
File.write("classifier.json", classifier.to_json)
```

Load a classifier from a JSON string.

```ruby
classifier = See5::Model.from_json(json_string)
```

### Anomaly detection

Anomaly detection uses the same input format as training a model. Call `See5.audit` to detect anomalies in the set.

```ruby
anomalies = See5.audit(data, class_attribute: :a)
```

Anomalies are hashes.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/elebow/ruby-see5>.
