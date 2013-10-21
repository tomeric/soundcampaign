guard 'rspec', turnip: true, cli: '-r fuubar --drb --format Fuubar' do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  # Rails example
  watch('spec/spec_helper.rb')                       { 'spec' }
  watch('config/routes.rb')                          { 'spec/controllers' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/support/factories.rb')                 { 'spec/models' }
  watch('spec/support/sequences.rb')                 { 'spec/models' }
end
