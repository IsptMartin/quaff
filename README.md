Quaff is a Ruby library for writing SIP test scenarios. It is an
attempt to create something similar to [SIPp](http://sipp.sf.net) (which I also maintain),
but which can be more easily integrated into other test suites.

The current version is 0.7.0, and it can be installed as a Ruby gem
with 'gem install quaff' (see
[the RubyGems page](https://rubygems.org/gems/quaff) for more info).
Quaff does not support SDP, but
[the separate SDP gem](https://rubygems.org/gems/sdp) can be used to
parse SDP bodies.

A set of example Quaff scripts are available [here](https://github.com/rkday/quaff-examples).

This is still an early stage of Quaff's development, and the API is
likely to change before the 1.0.0 release. (Hopefully, lots of bugs
will be flushed out too - please report any you find on Github.)

## Basic Usage

Here's a simple example of creating a SIP endpoint and making a call:

```ruby
require 'quaff'

# Create a UDP SIP endpoint
endpoint = Quaff::UDPSIPEndpoint.new("sip:alice@example.com", "alice", "password", 5060)

# Make an outgoing call
call = endpoint.outgoing_call("sip:bob@example.com")

# Send a request
call.send_request("INVITE", nil, {}, "v=0\r\no=alice 2890844526 2890844526 IN IP4 host.example.com\r\n...")

# Receive response
response = call.recv_response("100")
```

For more comprehensive examples, see the [Quaff examples repository](https://github.com/rkday/quaff-examples).

## Development and Testing

### Running Tests

Quaff uses RSpec for testing. To run the test suite:

```bash
# Run all tests
rspec

# Run tests with detailed output
rspec --format documentation

# Run specific test files
rspec spec/auth_test.rb
rspec spec/parser_test.rb
rspec spec/endpoint_test.rb

# Run functional tests
rake functional_test
```

### Test Dependencies

The test suite will automatically handle dependency issues. If the `system-getifaddrs` gem cannot be compiled on your system (common on newer macOS versions), Quaff will gracefully fall back to a pure Ruby implementation for network interface detection while maintaining full functionality.

### Code Coverage

Test coverage reports are automatically generated and stored in the `coverage/` directory after running tests.

### Development Setup

1. Clone the repository
2. Run tests: `rspec`
3. All tests should pass with good coverage (typically >75%)

The library is designed to work reliably across different Ruby versions and operating systems, with automatic fallbacks for platform-specific dependencies.

### Optional Dependencies

For optimal performance, you can optionally install the `system-getifaddrs` gem for native network interface enumeration:

```bash
gem install system-getifaddrs
```

If this gem cannot be installed (common on newer macOS versions due to compilation issues), Quaff will automatically fall back to a pure Ruby implementation that provides the same functionality with slightly different performance characteristics.

The fallback implementation:

- Uses standard Ruby socket methods
- Provides accurate local IP detection
- Works across all platforms without native compilation
- Maintains full compatibility with the Quaff API
