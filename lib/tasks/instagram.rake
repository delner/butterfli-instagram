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
          verify_token = Butterfli.configuration.providers(:instagram).verify_token
          client = Butterfli.configuration.providers(:instagram).client

          callback_url = Butterfli::Instagram::Tasks.url_for( url_or_host,
                                                              controller: :geography,
                                                              action: :callback)
          
          puts client.create_subscription(callback_url: callback_url,
                                          verify_token: verify_token,
                                          object: "geography",
                                          lat: lat,
                                          lng: lng,
                                          radius: radius)
        end
      end
      desc 'Setup Instagram location subscription.'
      namespace :location do
        desc 'Setup Instagram location subscription.'
        task :setup, [:url_or_host, :location_object_id] do |t, args|
          Butterfli::Instagram::Tasks.configure
          puts "Setting up Instagram location subscription..."

          # Parse arguments
          url_or_host = args.url_or_host
          location_object_id = args.location_object_id
          verify_token = Butterfli.configuration.providers(:instagram).verify_token
          client = Butterfli.configuration.providers(:instagram).client

          callback_url = Butterfli::Instagram::Tasks.url_for( url_or_host,
                                                              controller: :location,
                                                              action: :callback)

          puts client.create_subscription(callback_url: callback_url,
                                          verify_token: verify_token,
                                          object: "location",
                                          object_id: location_object_id)
        end
      end
    end
  end
end

