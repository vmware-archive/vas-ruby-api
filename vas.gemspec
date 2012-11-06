# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "vas"
  gem.version       = "1.1.1.dev"
  gem.author        = "VMware"
  gem.email         = "support@vmware.com"
  gem.homepage      = "http://vfabric.co"
  gem.description   = "A Ruby API for VMware vFabric Administration Server"
  gem.summary       = "vFabric Administration Server Ruby API"
  
  gem.platform = Gem::Platform::RUBY
  gem.extra_rdoc_files = %w(README.md LICENSE NOTICE)
  
  gem.add_dependency "json_pure", "~> 1.7.3"
  gem.add_dependency "multipart-post", "~> 1.1.5"
  gem.add_dependency "rubyzip", "~> 0.9.9"

  gem.add_development_dependency "simplecov", "~> 0.6.4"
  gem.add_development_dependency "fakeweb", "~> 1.3.0"

  gem.files         = %w(LICENSE NOTICE README.md Rakefile) + Dir.glob("lib/**/*")
  gem.require_path = "lib"
end
