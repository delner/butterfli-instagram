namespace :butterfli do
  namespace :instagram do
    namespace :subscription do
      desc 'Get list of Instagram subscriptions.'
      task :list do |t, args|
        Butterfli::Instagram::Tasks.configure
        puts "Getting list of Instagram subscriptions..."

        # Parse arguments
        client = Butterfli.configuration.providers(:instagram).client

        subscriptions = client.subscriptions
        if subscriptions.meta.code == 200
          client.subscriptions.each do |subscription|
            puts "Subscription:"
            puts "  ID:        #{subscription.id}"
            puts "  Object:    #{subscription.object}"
            puts "  Object ID: #{subscription.object_id}"
            puts "  Callback:  #{subscription.callback_url}"
          end
        else
          puts "Failed to retrieve list of subscriptions!"
          puts "  Code:    #{subscriptions.meta.code}"
          puts "  Type:    #{subscriptions.meta.error_type}"
          puts "  Message: #{subscriptions.meta.error_message}"
        end
      end
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
      desc 'Setup Instagram tag subscription.'
      namespace :tag do
        desc 'Setup Instagram tag subscription.'
        task :setup, [:url_or_host, :tag] do |t, args|
          Butterfli::Instagram::Tasks.configure
          puts "Setting up Instagram tag subscription..."

          # Parse arguments
          url_or_host = args.url_or_host
          tag = args.tag
          verify_token = Butterfli.configuration.providers(:instagram).verify_token
          client = Butterfli.configuration.providers(:instagram).client

          callback_url = Butterfli::Instagram::Tasks.url_for( url_or_host,
                                                              controller: :tag,
                                                              action: :callback)

          puts client.create_subscription(callback_url: callback_url,
                                          verify_token: verify_token,
                                          object: "tag",
                                          object_id: tag)
        end
      end
    end
  end
end

