
# TODO: These won't work because Butterfli won't be configured w/ client & secret
#       Add some alternate way of reading these values (environment var?)
namespace :butterfli do
  namespace :instagram do
    namespace :subscription do
      desc 'Delete all Instagram subscriptions.'
      task :teardown do |t, args|
        client = Butterfli.configuration.providers(:instagram).client
        puts "Deleting all existing Instagram subscriptions..."
        puts client.delete_subscription( object: 'all')
      end

      desc 'Setup Instagram geography subscription.'
      namespace :geography do
        desc 'Setup Instagram geography subscription.'
        task :setup, [:callback_url, :lat, :lng, :radius] do |t, args|
          puts "Setting up Instagram geography subscription..."

          # Parse arguments
          callback_url = args.callback_url
          lat = args.lat.to_f
          lng = args.lng.to_f
          radius = args.radius.to_i
          client = Butterfli.configuration.providers(:instagram).client
          
          puts client.create_subscription( callback_url: callback_url,
                                      object: "geography",
                                      lat: lat,
                                      lng: lng,
                                      radius: radius)
        end
      end
    end
  end
end