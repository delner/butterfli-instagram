namespace :butterfli do
  namespace :instagram do
    namespace :subscription do
      desc 'Delete all Instagram subscriptions.'
      task :teardown do |t, args|
        Butterfli::Instagram::Tasks.configure
        client = Butterfli.configuration.providers(:instagram).client
        puts "Deleting all existing Instagram subscriptions..."
        puts client.delete_subscription( object: 'all')
      end

      desc 'Setup Instagram geography subscription.'
      namespace :geography do
        desc 'Setup Instagram geography subscription.'
        task :setup, [:url_or_host, :lat, :lng, :radius] do |t, args|
          Butterfli::Instagram::Tasks.configure
          puts "Setting up Instagram geography subscription..."

          # Parse arguments
          url_or_host = args.url_or_host
          lat = args.lat.to_f
          lng = args.lng.to_f
          radius = args.radius.to_i
          client = Butterfli.configuration.providers(:instagram).client

          callback_url = Butterfli::Instagram::Tasks.url_for( url_or_host,
                                                              controller: :geography,
                                                              action: :callback)
          
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

