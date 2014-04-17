#!/bin/bash
rm -f *_test.rb
wget relbell.com/homeroute/odb_test.rb
wget relbell.com/homeroute/cdn_test.rb
chmod +x odb_test.rb cdn_test.rb
