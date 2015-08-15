module Butterfli
  module Instagram
    class Railtie < Rails::Railtie
      railtie_name :butterfli_instagram

      rake_tasks do
        load "tasks/instagram.rake"
      end
    end
  end
end